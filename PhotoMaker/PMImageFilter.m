//
//  PMImageFilter.m
//  PhotoMaker
//
//  Created by Nikita on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMImageFilter.h"
#import "PMConst.h"
#import "GPUImage.h"
#import "PMImageUtils.h"

const int kPMNumberOfVisibleFilters = 9;
const int kPMNumberOfFilters = 10;

@implementation PMImageFilter

static NSArray *_filterImages;
static GPUImageCropFilter *_cameraCropFilter;
static GPUImageFilter *_placeholderFilter;

+(void) initialize
{
	if (self == [PMImageFilter class]) {
		// Initializing prerendered filter images
		[self initializeFilterPrerenderedImages];
	}
}


+(void) assertFilterTypeIsCorrect:(PMFilterType)filterType
{
	BOOL filterTypeInBounds = (int)filterType >= 0 && (int)filterType < [self totalFilterCount];
	
	DAssert(filterTypeInBounds, @"Filter type is out of bounds: %d", filterType);
}


+(NSInteger) filterCount
{
	return kPMNumberOfVisibleFilters;
}


+(NSInteger) totalFilterCount
{
	return kPMNumberOfFilters;
}


+(UIImage *) imageForFilterType:(PMFilterType)filterType
{
	[self assertFilterTypeIsCorrect:filterType];
	return _filterImages[filterType];
}


+(GPUImageCropFilter *) cameraCropFilter
{
	if (!_cameraCropFilter) {
		_cameraCropFilter = [[GPUImageCropFilter alloc] init];
		[_cameraCropFilter prepareForImageCapture];
	}
	
	[_cameraCropFilter removeAllTargets];
	float aspectDifference = 1 - kPMCameraAspect;
	float halfOffset = aspectDifference / 2;
	_cameraCropFilter.cropRegion = CGRectMake(0, halfOffset, 1, kPMCameraAspect);
	return _cameraCropFilter;
}


+(GPUImageFilter *) placeholderFilter 
{
	if (!_placeholderFilter) {
		_placeholderFilter = [[GPUImageGammaFilter alloc] init];
	}
	GPUImageGammaFilter *gammaFilter = (GPUImageGammaFilter *)_placeholderFilter;
	[gammaFilter removeAllTargets];
	return gammaFilter;
}


+(GPUImageOutput <GPUImageInput> *) filterForType:(PMFilterType)filterType
{
	[self assertFilterTypeIsCorrect:filterType];
	
	GPUImageOutput <GPUImageInput> *result = nil;
	
	if (filterType == PMFilterTypeNone) {
		// Do nothing, nil returned
	} else
	if (filterType == PMFilterTypeSepia) {
		GPUImageSepiaFilter *sepia = [[GPUImageSepiaFilter alloc] init];
		result = sepia;
	} else
	if (filterType == PMFilterTypeMonochrome) {
		GPUImageMonochromeFilter *monochrome = [[GPUImageMonochromeFilter alloc] init];
		result = monochrome;
	} else
	if (filterType == PMFilterTypeGrayscale) {
		GPUImageGrayscaleFilter *grayscale = [[GPUImageGrayscaleFilter alloc] init];
		result = grayscale;
	} else
	if (filterType == PMFilterTypeAmatorika) {
		GPUImageAmatorkaFilter *amarotika = [[GPUImageAmatorkaFilter alloc] init];
		result = amarotika;
	} else		
	if (filterType == PMFilterTypeSoftElegance) {
		GPUImageSoftEleganceFilter *softElegance = [[GPUImageSoftEleganceFilter alloc] init];
		result = softElegance;
	} else
	if (filterType == PMFilterTypeMissEtikate) {
		GPUImageMissEtikateFilter *missEtikate = [[GPUImageMissEtikateFilter alloc] init];
		result = missEtikate;
	} else
	if (filterType == PMFilterTypeHaze) {
		GPUImageHazeFilter *haze = [[GPUImageHazeFilter alloc] init];
		haze.distance = 0.25;
		result = haze;
	} else
	if (filterType == PMFilterTypeToneCurve) {
		GPUImageToneCurveFilter *toneCurve = [[GPUImageToneCurveFilter alloc] init];
		[toneCurve setBlueControlPoints:@[[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.8)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)]]];
		result = toneCurve;
	} else

	if (filterType == PMFilterTypeBlur) {
		GPUImageTiltShiftFilter *blurFilter = [[GPUImageTiltShiftFilter alloc] init];
		
		[blurFilter setTopFocusLevel:0.4];
		[blurFilter setBottomFocusLevel:0.6];
		[blurFilter setFocusFallOffRate:0.2];
		
		result = blurFilter;
	}
	
	return result;
}


+(GPUImageFilter *) configureCameraForCapture:(GPUImageStillCamera *)camera 
										input:(id<GPUImageInput>)input 
								   filterType:(PMFilterType)filterType 
								  blurEnabled:(BOOL)blurEnabled 
{
	[self configureFilterWithOutput:camera input:input filterType:filterType blurEnabled:blurEnabled cropCamera:NO addPlaceholderFilter:YES];
	return _placeholderFilter;
}


+(GPUImageOutput *) configureFilterWithOutput:(GPUImageOutput *)output 
							input:(id<GPUImageInput>)input 
					   filterType:(PMFilterType)filterType 
					  blurEnabled:(BOOL)blurEnabled 
					   cropCamera:(BOOL)cropCamera
{
	return [self configureFilterWithOutput:output input:input filterType:filterType blurEnabled:blurEnabled cropCamera:cropCamera addPlaceholderFilter:NO];
}


+(GPUImageOutput *) configureFilterWithOutput:(GPUImageOutput *)output 
										input:(id<GPUImageInput>)input 
								   filterType:(PMFilterType)filterType 
								  blurEnabled:(BOOL)blurEnabled 
								   cropCamera:(BOOL)cropCamera
						 addPlaceholderFilter:(BOOL)addPlaceholder
{
	[self assertFilterTypeIsCorrect:filterType];
	
	[output removeAllTargets];

	GPUImageOutput *currentOutput = output;
	GPUImageOutput *firstOutput = nil;
	
	if (!cropCamera) {
		_placeholderFilter = nil;
	}
	
	// SoftElegance doesn't work if blur enabled
	if (blurEnabled && filterType == PMFilterTypeSoftElegance) {
		blurEnabled = NO;
	}
	
	addPlaceholder = YES;
	if (addPlaceholder) {
		GPUImageFilter *placeholderFilter = [self placeholderFilter];
		[currentOutput addTarget:placeholderFilter];
		currentOutput = placeholderFilter;
		if (!firstOutput) {
			firstOutput = currentOutput;
		}
	}
	
	if (blurEnabled) {
		GPUImageOutput <GPUImageInput> *blurFilter = [self filterForType:PMFilterTypeBlur];
		[currentOutput addTarget:blurFilter];
		currentOutput = blurFilter;

		if (!firstOutput) {
			firstOutput = currentOutput;
		}
	}
	
	
	GPUImageOutput <GPUImageInput> *filter = [self filterForType:filterType];
	if (filter) {
		[currentOutput addTarget:filter];
		currentOutput = filter;
		if (!firstOutput) {
			firstOutput = currentOutput;
		}
	}
	
	[currentOutput addTarget:input];
	
	if (cropCamera) {
		// Magic numbers for decrease camera preview resolution
		[firstOutput forceProcessingAtSize:CGSizeMake(180 * 2, 240 * 2)];
	}
	
	return currentOutput;
}


+(UIImage *) filteredImage:(UIImage *)image withFilterType:(PMFilterType)filterType
{
	[self assertFilterTypeIsCorrect:filterType];
	
	UIImage *result = nil;
	
	GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
	GPUImageOutput <GPUImageInput> *filter = [self filterForType:filterType];
	
	if (filter) {
		[filter prepareForImageCapture];
		[stillImageSource addTarget:filter];
		[stillImageSource processImage];
		result = [filter imageFromCurrentlyProcessedOutput];
	} else {
		result = image;
	}
	
	return result;
}


+(void) initializeFilterPrerenderedImages
{
	NSMutableArray *images = [NSMutableArray array];
	
	UIImage *originalImage = [PMImageUtils imageNamed:kPMImageFilterExampleImage];
	
	for (int i = 0; i < [self totalFilterCount]; i++) {
		UIImage *filteredImage = [self filteredImage:originalImage withFilterType:i];
		[images addObject:filteredImage];
	}
	
	_filterImages = [[NSArray alloc] initWithArray:images];
}

@end
