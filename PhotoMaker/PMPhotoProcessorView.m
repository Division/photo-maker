//
//  PMPhotoProcessorView.m
//  PhotoMaker
//
//  Created by Nikita on 9/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMPhotoProcessorView.h"
#import "PMConst.h"
#import "PMImageUtils.h"
#import "PMButton.h"
#import "PMStringDefines.h"
#import "PMImageProcessingView.h"
#import "PMImageEditorView.h"

@interface PMPhotoProcessorView() <PMImageEditorViewDelegate>

@end

@implementation PMPhotoProcessorView

@synthesize retakeButton = _retakeButton;
@synthesize saveButton = _saveButton;
@synthesize captionButton = _captionButton;
@synthesize imageEditorView = _imageEditorView;
@synthesize filterSelectionView = _filterSelectionView;
@synthesize containerView = _containerView;

#pragma mark - init/dealloc

-(void) awakeFromNib
{
	[super awakeFromNib];
	UIImage *backgroundPattern = [PMImageUtils imageNamed:kPMImageStartupBackgrounPattern];
	self.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];

	self.saveButton.pmButtonType = PMButtonTypeBlue;
	[self.saveButton setTitle:string_save forState:UIControlStateNormal];
	
	self.retakeButton.pmButtonType = PMButtonTypeAction;
	[self.retakeButton setTitle:string_retake forState:UIControlStateNormal];
	
	self.captionButton.pmButtonType = PMButtonTypeAction;
	[self.captionButton setTitle:string_caption forState:UIControlStateNormal];
	
	self.imageEditorView.delegate = self;
}




#pragma mark - Actions

-(void) applySourceIsCameraRoll:(BOOL)sourceIsCameraRoll
{
	NSString *retakeCaption;
	
	if (sourceIsCameraRoll) {
		retakeCaption = string_cancel;
	} else {
		retakeCaption = string_retake;		
	}
	
	[self.retakeButton setTitle:retakeCaption forState:UIControlStateNormal];
}


-(void) toggleCaption
{
	[self.imageEditorView toggleCaption];
	self.captionButton.selected = self.imageEditorView.captionVisible;
}


-(void) handleKeyboardAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve andOffset:(int)offset
{
	CGRect containerFrame = self.containerView.frame;
	containerFrame.origin.y = -offset;
	
	[UIView animateWithDuration:duration delay:0 options:curve animations:^{
		self.containerView.frame = containerFrame;
	} completion:nil];
}


-(void) disableInput
{
	self.userInteractionEnabled = NO;
}


#pragma mark - Image Editor View Delegate

-(void) askToggleCaption
{
	[self toggleCaption];
}


-(void) presetChangedWithCaptionEnabled:(BOOL)captionEnabled
{
	self.captionButton.enabled = captionEnabled;
}

@end
