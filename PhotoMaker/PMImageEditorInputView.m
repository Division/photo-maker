//
//  PMImageEditorInputView.m
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMImageEditorInputView.h"
#import "PMImageUtils.h"
#import "PMConst.h"
#import "PMButton.h"
#import "PMFontDefinition.h"

static NSString *const kPMFontDisplayString = @"Aa";

@interface PMImageEditorInputView()

@property (nonatomic, strong) NSArray *fonts;

@end

@implementation PMImageEditorInputView 

#pragma mark Properties

-(void) setDelegate:(id<PMImageEditorInputViewDelegate>)delegate
{
	self.inputTextView.delegate = delegate;
	_delegate = delegate;
}

#pragma mark - init/dealloc

-(void) awakeFromNib
{
	[super awakeFromNib];
	self.inputTextView.contentInset = UIEdgeInsetsZero;
	self.inputTextView.userInteractionEnabled = NO;
	self.inputTextView.text = @"";
	self.inputTextView.delegate = self.delegate;
	
	self.inputBackgroundImageView.image = [PMImageUtils imageEditorInput];
	
    [self.fontTabBar configureWithButtonCount:6
                              backgroundImage:[PMImageUtils imageEditorInput]
                                    leftImage:[PMImageUtils tabLeft]
                              leftImageActive:[PMImageUtils tabLeftActive]
                                  middleImage:[PMImageUtils tabMiddle]
                            middleImageActive:[PMImageUtils tabMiddleActive]
                                   rightImage:[PMImageUtils tabRight]
                             rightImageActive:[PMImageUtils tabRightActive]];
	
	self.fontTabBar.delegate = self;
	
	self.fonts = @[kPMFontBALLW,
										   kPMFontCollegiate,
										   kPMFontCompleteHim,
										   kPMFontLobster,
										   kPMFontTT1018M,
										   kPMFontHelvetica];
	
	int i = 0;
	NSArray *buttons = [self.fontTabBar allButtons];
	for (PMButton *button in buttons) {
		[button setTitle:kPMFontDisplayString forState:UIControlStateNormal];
		button.titleLabel.font = [PMFontDefinition fontWithIndex:i forSize:16];
		i++;
	}
}




-(void) inpuStateChanged:(BOOL)isEnabled
{
	if (isEnabled) {
		if (self.inputTextView.canBecomeFirstResponder) {
			[self.inputTextView becomeFirstResponder];
		}
	} else {
		if (self.inputTextView.canResignFirstResponder) {
			[self.inputTextView resignFirstResponder];
		}
	}
}


#pragma mark - Tab Bar Delegate

-(void) tabBar:(PMTabBar *)tabBar didSelectItemWithIndex:(NSInteger)index
{
	[self.delegate fontDidChange:index];
}

@end
