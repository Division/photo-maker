//
//  PMImageProcessingView.h
//  PhotoMaker
//
//  Created by Nikita on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"
#import "PMImageFilter.h"

// View can work in two modes - display video from the camera and display image
typedef	enum
{
	PMImageProcessingViewModeCamera,
	PMImageProcessingViewModeImage
	
} PMImageProcessingViewMode;

/**
 * View used to display image or camera output with filters applied
 */
@interface PMImageProcessingView : PMView

@property (nonatomic, assign) BOOL flashEnabled;

/**
 * Set image to be filtered. Only supported in image processing mode.
 */
@property (nonatomic, strong) UIImage *sourceImage;

-(void) displayLastFilteredImageView;
-(void) makePhotoWithCompletionBlock:(void (^)(UIImage *image, NSError * error))completionBlock;
-(void) startup;
-(void) shutdown;
-(void) configureWithViewMode:(PMImageProcessingViewMode)viewMode;
-(void) switchCamera;
-(void) setFilterWithType:(PMFilterType)filterType blurEnabled:(BOOL)blurEnabled;

@end
