//
//  PMTakePhotoController.m
//  PhotoMaker
//
//  Created by Nikita on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMTakePhotoController.h"
#import "PMTakePhotoView.h"
#import "PMImageProcessingView.h"
#import "PMFilterSelectionView.h"
#import "PMPhotoProcessorController.h"
#import "PMImageUtils.h"
#import <AVFoundation/AVFoundation.h>

static const NSTimeInterval kPMCameraSwitchDelay = 1;

@interface PMTakePhotoController () <PMFilterSelectionViewDelegate>

@property (weak, nonatomic, readonly) PMImageProcessingView *imageProcessingView;
@property (weak, nonatomic, readonly) PMTakePhotoView *takePhotoView;
@property (weak, nonatomic, readonly) PMFilterSelectionView *filterSelectionView;
@property (nonatomic, assign) BOOL blurEnabled;
@property (nonatomic, assign) BOOL flashEnabled;
@property (nonatomic, assign) PMFilterType currentFilterType;
@property (nonatomic, assign) NSTimeInterval lastCameraSwitchTime;

@end


@implementation PMTakePhotoController

#pragma mark - Properties

-(PMTakePhotoView *) takePhotoView
{
	return (PMTakePhotoView *)self.view;
}


-(PMImageProcessingView *) imageProcessingView
{
	return self.takePhotoView.imageProcessingView;
}


-(PMFilterSelectionView *) filterSelectionView
{
	return self.takePhotoView.filterSelectionView;
}


#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
	
	if (![self hasFlash]) {
		[self.takePhotoView hideFlash];
	}
	
	[self.imageProcessingView configureWithViewMode:PMImageProcessingViewModeCamera];
	self.filterSelectionView.filterSelectionDelegate = self;
	self.currentFilterType = PMFilterTypeNone;
}


-(void)viewDidUnload
{
    [super viewDidUnload];
}


-(void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if (self.flashEnabled) {
		[self turnTorchState:NO];
	}
	
	[self.imageProcessingView shutdown];
}


-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.imageProcessingView startup];
	[self applyCurrentFiltering];
	[self.takePhotoView setInputEnabled:YES];
}


-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.flashEnabled = NO;
	self.imageProcessingView.flashEnabled = self.flashEnabled;
	[self.takePhotoView hideFilters];
}


#pragma mark - Other

-(BOOL) hasFlash
{
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	return [device hasTorch] && [device hasFlash];
}


- (void) turnTorchState:(bool)enabled
{
	if ([self hasFlash]){
		AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];		
		[device lockForConfiguration:nil];
		if (enabled) {
			[device setTorchMode:AVCaptureTorchModeOn];
			[device setFlashMode:AVCaptureFlashModeOn];
		} else {
			[device setTorchMode:AVCaptureTorchModeOff];
			[device setFlashMode:AVCaptureFlashModeOff];
		}
		[device unlockForConfiguration];
	}
}


-(void) applyCurrentFiltering
{
	[self.imageProcessingView setFilterWithType:self.currentFilterType blurEnabled:self.blurEnabled];
}


-(void) performMakePhoto
{
	[self.takePhotoView setInputEnabled:NO];
	[self.imageProcessingView makePhotoWithCompletionBlock:^(UIImage *image, NSError *error){
		PMPhotoProcessorController *processor = [PMPhotoProcessorController loadFromNib];
		[processor configureWithImage:image filterType:self.currentFilterType blurEnabled:self.blurEnabled sourceIsCameraRoll:NO];
		[self presentViewController:processor animated:YES completion:nil];
	}];
}


#pragma mark - Button actions

-(IBAction) didPressCancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction) didPressFilters:(id)sender
{
	[self.takePhotoView toggleFiltersDisplay];
}


-(IBAction) didPressMakePhoto:(id)sender
{
	[self performMakePhoto];
}


-(IBAction) didPressFlashlightToggle:(id)sender
{
	self.flashEnabled = !self.flashEnabled;
	self.imageProcessingView.flashEnabled = self.flashEnabled;
	[self turnTorchState:self.flashEnabled];
}


-(IBAction) didPressFrontBackCameraToggle:(id)sender
{
	// Disable fast touches on the button
	NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
	if (currentTime - self.lastCameraSwitchTime > kPMCameraSwitchDelay) {
		[self.imageProcessingView switchCamera];
		self.lastCameraSwitchTime = currentTime;
	}
}


-(IBAction) didPressBlurToggle:(id)sender
{
	self.blurEnabled = !self.blurEnabled;
	[self.takePhotoView handleBlurEnabled:self.blurEnabled];
	[self.takePhotoView displayBlurEnabled:self.blurEnabled];
	[self applyCurrentFiltering];
}

#pragma mark - Filter Selection View Delegate

-(void) filterDidSelect:(PMFilterType)type
{
	self.currentFilterType = type;
	[self applyCurrentFiltering];
}

@end
