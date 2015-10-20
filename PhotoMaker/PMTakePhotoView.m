//
//  PMTakePhotoView.m
//  PhotoMaker
//
//  Created by Nikita on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMTakePhotoView.h"
#import "PMButton.h"
#import "PMImageProcessingView.h"
#import "PMStringDefines.h"
#import "PMFilterSelectionView.h"

static const int kPMBottomControlsOffset = 10;

@interface PMTakePhotoView()

@property (nonatomic, assign) BOOL filterSelectionVisible;
@property (nonatomic, strong) NSArray *allButtons;
@property (nonatomic, assign) CGRect initialBottomContainerFrame;

@end


@implementation PMTakePhotoView

#pragma mark - init/dealloc

-(void) awakeFromNib
{
	self.cancelButton.pmButtonType = PMButtonTypeTransparent;
	self.filtersButton.pmButtonType = PMButtonTypeTransparent;
	
	self.flashLightButton.pmButtonType = PMButtonTypeFlashlight;
	[self displayBlurEnabled:NO];
	
	self.blurButton.pmButtonType = PMButtonTypeBlur;
	[self displayFlashEnabled:NO];
	
	self.cameraSwitchButton.pmButtonType = PMButtonTypeSwitchCamera;
	
	self.filterSelectionVisible = NO;
	self.filterSelectionView.alpha = 0;
	
	self.initialBottomContainerFrame = self.bottomContainerView.frame;
	
	self.allButtons = @[self.flashLightButton, self.cameraSwitchButton, self.blurButton, self.cancelButton, self.makePhotoButton, self.filtersButton];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentDidTap:)];
	[self.imageProcessingView addGestureRecognizer:tapRecognizer];
}



#pragma mark - View updates


-(void) setInputEnabled:(BOOL)enabled
{
	for (PMButton *button in self.allButtons) {
		button.enabled = enabled;
	}
}


-(void) displayBlurEnabled:(BOOL)blurEnabled
{
	[self.blurButton setTitle:string_blur forState:UIControlStateNormal];
}


-(void) displayFlashEnabled:(BOOL)flashEnabled
{
	NSString *flashTitle = flashEnabled ? string_on : string_off;
	[self.flashLightButton setTitle:flashTitle forState:UIControlStateNormal];	
}


-(void)hideFlash
{
	self.flashLightButton.hidden = YES;
}


-(void) hideFilters
{
	self.filterSelectionVisible = NO;
	self.bottomContainerView.frame = self.initialBottomContainerFrame;
	self.filterSelectionView.alpha = 0;
}


-(void) toggleFiltersDisplay
{
	self.filterSelectionVisible = !self.filterSelectionVisible;
	float newAlpha = self.filterSelectionVisible ? 1 : 0;
	CGRect newContainerRect = self.initialBottomContainerFrame;
	if (self.filterSelectionVisible) {
		newContainerRect.origin.y += kPMBottomControlsOffset;
	}
	
	[UIView animateWithDuration:0.5 animations:^{
		self.filterSelectionView.alpha = newAlpha;
		self.bottomContainerView.frame = newContainerRect;
	}];
}


-(void) handleBlurEnabled:(BOOL)blurEnabled
{
	self.blurButton.blurEnabled = blurEnabled;
}


-(void) contentDidTap:(UIGestureRecognizer *)recognizer
{
	if (self.filterSelectionVisible) {
		[self toggleFiltersDisplay];
	}
}

@end
