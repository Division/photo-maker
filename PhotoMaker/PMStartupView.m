//
//  MPStartupView.m
//  PhotoMaker
//
//  Created by Nikita on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMStartupView.h"
#import "PMConst.h"
#import "PMButton.h"
#import "PMStringDefines.h"
#import "PMGridView.h"
#import "PMImageUtils.h"

static const NSTimeInterval kPMBottomScrollAnimationDuration = 1.0f;

@implementation PMStartupView

@synthesize titleLabel = _titleLabel;
@synthesize takePhotoButton = _takePhotoButton;
@synthesize cameraRollButton = _cameraRollButton;
@synthesize bottomScroll = _bottomScroll;
@synthesize bottomScrollLabel = _bottomScrollLabel;

-(void) commonInit
{
	[super commonInit];
	UIImage *backgroundPattern = [PMImageUtils imageNamed:kPMImageStartupBackgrounPattern];
	self.backgroundColor = [UIColor colorWithPatternImage:backgroundPattern];
}


-(void) awakeFromNib
{
	[super awakeFromNib];
	self.titleLabel.font = [UIFont fontWithName:kPMFontTT1018M size:30];
	
    self.takePhotoButton.pmButtonType = PMButtonTypeBlack;
    [self.takePhotoButton setTitle:string_take_a_photo forState:UIControlStateNormal];
	
    self.cameraRollButton.pmButtonType = PMButtonTypeBlue;
	[self.cameraRollButton setTitle:string_camera_roll forState:UIControlStateNormal];
	
	UIImage *bottomScrollImage = [PMImageUtils imageNamed:kPMImageStartupBottomRoll];
	self.bottomScroll.backgroundColor = [UIColor colorWithPatternImage:bottomScrollImage];
	self.bottomScroll.layoutType = PMGridViewLayoutTypeHorizontal;
}




-(void) playButtonShowAnimation
{
	self.takePhotoButton.alpha = 0;
	self.cameraRollButton.alpha = 0;
	
	[UIView animateWithDuration:1 animations:^{
		self.takePhotoButton.alpha = 1;
		self.cameraRollButton.alpha = 1;		
	}];
}


-(void) hideBottomScroll
{
	self.bottomScroll.hidden = YES;
	self.bottomScrollLabel.alpha = 0;
}


-(void) updateBottomScrollLabelWithCameraRollSuccess:(BOOL)cameraRollSuccess
{
	NSString *title = cameraRollSuccess ? string_choose_recent_photo : string_choose_predefined_photo;
	self.bottomScrollLabel.text = title;	
}


-(void) showBottomScrollWithCameraRollSuccess:(BOOL)cameraRollSuccess
{
	[self updateBottomScrollLabelWithCameraRollSuccess:cameraRollSuccess];
	self.bottomScroll.hidden = NO;
	
	CGRect scrollFrame = self.bottomScroll.frame;
	CGRect oldScrollFrame = scrollFrame;
	oldScrollFrame.origin.y += oldScrollFrame.size.height + 10;
	self.bottomScroll.frame = oldScrollFrame;
	
	[UIView animateWithDuration:kPMBottomScrollAnimationDuration animations:^{
		self.bottomScrollLabel.alpha = 1;
		self.bottomScroll.frame = scrollFrame;
	}];
}

@end
