//
//  PMImageEditorPresetManagerView.m
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMImageEditorPresetManagerView.h"
#import "PMImageEditorPresetBase.h"
#import "PMImageEditorPresetDemotivator.h"
#import "PMImageEditorPresetTextBottom.h"
#import "PMImageEditorPresetPolaroid.h"
#import "PMImageEditorPresetDog.h"
#import "PMImageEditorPresetPrison.h"
#import "PMImageEditorPresetPhotoFrame.h"
#import "PMImageEditorPresetGoldFrame.h"
#import <QuartzCore/QuartzCore.h>

@interface PMImageEditorPresetManagerView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) PMImageEditorPresetBase *currentPreset;
@property (nonatomic, strong) NSArray *presetClasses;
@property (nonatomic, assign) int currentIndex;

@end


@implementation PMImageEditorPresetManagerView

@synthesize currentPreset = _currentPreset;
@synthesize presetClasses = _presetClasses;
@synthesize currentIndex = _currentIndex;
@synthesize delegate = _delegate;

-(void) commonInit
{
	[super commonInit];
	self.presetClasses = @[[PMImageEditorPresetTextBottom class], 
												   [PMImageEditorPresetDemotivator class],
												   [PMImageEditorPresetPolaroid class],
												   [PMImageEditorPresetDog class],
												   [PMImageEditorPresetPrison class],
												   [PMImageEditorPresetGoldFrame class],
												   [PMImageEditorPresetPhotoFrame class]];
	
	self.currentPreset = [(self.presetClasses)[0] loadFromNib];
	self.currentIndex = 0;
	
	[self addSubview:self.currentPreset];
	self.currentPreset.frame = self.bounds;
	self.userInteractionEnabled = NO;
}


-(void) handleSwipe:(BOOL) isLeft
{
	int index = _currentIndex;
	if (isLeft) {
		index++;
		if (index >= self.presetClasses.count) {
			index = 0;
		}
		[self switchPreset:index directionIsLeft:NO];
	} else {
		index--;
		if (index < 0) index = self.presetClasses.count - 1;
		[self switchPreset:index directionIsLeft:YES];
	}
}


-(void) switchPreset:(int)index directionIsLeft:(BOOL)isleft
{
	DAssert(index >= 0 && index < self.presetClasses.count, @"Invalid preset index");
	if (index == _currentIndex) {
		return;
	}
	
	[self.currentPreset removeFromSuperview];
	self.currentPreset = [(self.presetClasses)[index] loadFromNib];
	[self addSubview:self.currentPreset];

	CATransition *animation = [CATransition animation];
	[animation setDuration:0.2];
	[animation setType:kCATransitionPush];

	if (isleft) {
		[animation setSubtype:kCATransitionFromLeft];
	} else {
		[animation setSubtype:kCATransitionFromRight];
	}

	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

	[self.layer addAnimation:animation forKey:@"SwitchViews"];

	_currentIndex = index;
	[self.delegate presetDidChanged:self.currentPreset];
}



@end
