//
//  PMImageProcessingView.m
//  PhotoMaker
//
//  Created by Nikita on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMImageProcessingView.h"
#import "GPUImage.h"
#import "PMOperationQueue.h"
#import "PMConst.h"
#import "PMImageUtils.h"

static const int kPMImageCameraOffset = 68;

@interface PMImageProcessingView()

@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) GPUImageOutput *gpuImageOutput;

@property (nonatomic, assign) PMImageProcessingViewMode viewMode;
@property (nonatomic, assign) BOOL alreadyConfigured;
@property (unsafe_unretained, nonatomic, readonly) GPUImageStillCamera *cameraOutput;
@property (unsafe_unretained, nonatomic, readonly) GPUImagePicture *imageOutput;
@property (nonatomic, assign) PMFilterType filterType;
@property (nonatomic, assign) BOOL blurEnabled;
@property (nonatomic, strong) GPUImageOutput *lastFilterInChain;

@end


@implementation PMImageProcessingView

#pragma mark - Properties

-(void) setFlashEnabled:(BOOL)flashEnabled
{
	_flashEnabled = flashEnabled;
}


-(GPUImageStillCamera *) cameraOutput
{
	GPUImageStillCamera *result = nil;
	
	if (self.viewMode == PMImageProcessingViewModeCamera) {
		result = (GPUImageStillCamera *)self.gpuImageOutput;
	}
	
	return result;
}


-(GPUImagePicture *) imageOutput
{
	GPUImagePicture *result = nil;
	
	if (self.viewMode == PMImageProcessingViewModeImage) {
		result = (GPUImagePicture *)self.gpuImageOutput;
	}
	
	return result;
}

#pragma mark - init/dealloc

-(void) commonInit
{
	[super commonInit];
	self.gpuImageView = [[GPUImageView alloc] initWithFrame:self.bounds];
	self.gpuImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:self.gpuImageView];
	self.alreadyConfigured = NO;
	self.backgroundColor = [UIColor clearColor];
}


-(void) configureWithViewMode:(PMImageProcessingViewMode)viewMode
{
	DAssert(!self.alreadyConfigured, @"PMImageProcessingView configureWithViewMode: called twice");
	self.alreadyConfigured = YES;
	self.viewMode = viewMode;
	
	if (viewMode == PMImageProcessingViewModeCamera) {
		
		GPUImageStillCamera *stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
		stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
		[stillCamera addTarget:self.gpuImageView];
		self.gpuImageOutput = stillCamera;
		self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
		
	} else 
	if (viewMode == PMImageProcessingViewModeImage) {
		DAssert(self.sourceImage, @"Source image must be set");
		GPUImagePicture *stillImage = [[GPUImagePicture alloc] initWithImage:self.sourceImage];
		self.gpuImageOutput = stillImage;
	}
}


-(void) dealloc
{
	// Need stop capture before releasing
	[self shutdown];
	
}

#pragma mark - Utils

-(void) assertConfigured
{
	DAssert(self.alreadyConfigured, @"Image processing view must be configured before use");
}


-(void) displayLastFilteredImageView
{
	DAssert(self.viewMode == PMImageProcessingViewModeImage, @"displayLastFilteredImageView can be called only in image mode");
	UIImage *image = [self.lastFilterInChain imageFromCurrentlyProcessedOutput];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = self.gpuImageView.frame;
	[self addSubview:imageView];
	
	self.gpuImageView.hidden = YES;
}

#pragma mark - Filtering framework work

-(void) makePhotoWithCompletionBlock:(void (^)(UIImage *image, NSError * error))completionBlock
{
	[self assertConfigured];
	DAssert(self.viewMode == PMImageProcessingViewModeCamera, @"Can't make photo in image mode");
	
	GPUImageFilter *filter = [PMImageFilter configureCameraForCapture:self.cameraOutput 
																input:self.gpuImageView 
														   filterType:self.filterType 
														  blurEnabled:self.blurEnabled];
	
	[self.cameraOutput capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *resultImage, NSError *resultError){
		
		UIImage *correctedImage = [PMImageUtils correctImage:resultImage];
		
		[[PMOperationQueue mainQueue] addOperationWithBlock:^{
			completionBlock(correctedImage, resultError);
		}];
	}];
}


-(void) startup
{
	[self assertConfigured];
	
	if (self.viewMode == PMImageProcessingViewModeCamera) {
		[self.cameraOutput startCameraCapture];
	}
}


-(void) shutdown
{
	[self assertConfigured];
	
	if (self.viewMode == PMImageProcessingViewModeCamera) {
		[self.cameraOutput stopCameraCapture];
	}
}


-(void) switchCamera
{
	[self assertConfigured];
	DAssert(self.viewMode == PMImageProcessingViewModeCamera, @"Can't switch camera in image mode");
	
	[self.cameraOutput rotateCamera];
}


-(void) setFilterWithType:(PMFilterType)filterType blurEnabled:(BOOL)blurEnabled
{
	[self assertConfigured];
	
	self.filterType = filterType;
	self.blurEnabled = blurEnabled;
	
	BOOL cropCamera = self.viewMode == PMImageProcessingViewModeCamera;
	BOOL addPlaceholder = self.viewMode == PMImageProcessingViewModeImage;
	
	GPUImageOutput *lastFilter = [PMImageFilter configureFilterWithOutput:self.gpuImageOutput 
																	input:self.gpuImageView 
															   filterType:filterType 
															  blurEnabled:blurEnabled
															   cropCamera:cropCamera 
													 addPlaceholderFilter:addPlaceholder];
	
	// Manually update in image mode
	if (self.viewMode == PMImageProcessingViewModeImage) {
		[self.imageOutput processImage];
		self.lastFilterInChain = lastFilter;
	}
}

@end
