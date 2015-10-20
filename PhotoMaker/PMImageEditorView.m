//
//  PMImageEditorView.m
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMImageEditorView.h"
#import "PMImageEditorInputView.h"
#import "PMImageProcessingView.h"
#import "PMImageEditorPresetBase.h"
#import "PMImageEditorPresetManagerView.h"
#import "PMImageEditorTransformView.h"
#import "PMImageUtils.h"
#import "PMConst.h"

static const int kPMInputOffset = 15;

@interface PMImageEditorView() <PMImageEditorInputViewDelegate, PMImageEditorPresetManagerViewDelegate>

@property (nonatomic, strong) PMImageProcessingView *imageProcessingView;
@property (nonatomic, strong) PMImageEditorInputView *inputView;
@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) PMView *containerView;
@property (nonatomic, strong) PMImageEditorTransformView *imageTransformView;
@property (nonatomic, assign) BOOL captionVisible;
@property (unsafe_unretained, nonatomic, readonly) PMImageEditorPresetBase *currentPreset;
@property (nonatomic, strong) PMImageEditorPresetManagerView *presetManager;
@property (nonatomic, strong) NSString *currentText;
@property (nonatomic, assign) int currentFont;
@property (nonatomic, assign) BOOL adviceShown;

@end


@implementation PMImageEditorView

#pragma mark - Properties

-(PMImageEditorPresetBase *)currentPreset
{
	return self.presetManager.currentPreset;
}


#pragma mark - init/dealloc

-(void) awakeFromNib
{
	[super awakeFromNib];
	self.backgroundColor = [UIColor clearColor];
	
	// Input view
	self.inputView = [PMImageEditorInputView loadFromNib];
	[self addSubview:self.inputView];

	self.containerView = [[PMView alloc] initWithFrame:self.bounds];
	[self addSubview:self.containerView];
	
	// Creating scroll view that contains filtered image with editor preset on top
/*	self.containerScrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
	self.containerScrollView.scrollEnabled = NO;
	[self addSubview:self.containerScrollView];*/

	// Adding filtered image to the scroll view
	// It is displayed above input view
	self.imageProcessingView = [[PMImageProcessingView alloc] initWithFrame:self.bounds];
	
	// Adding 
	self.imageTransformView = [[PMImageEditorTransformView alloc] initWithFrame:self.bounds andImageProcessingView:self.imageProcessingView];
	[self.containerView addSubview:self.imageTransformView];
//	[self addSubview:self.imageTransformView];

	// Preset manager
	self.presetManager = [[PMImageEditorPresetManagerView alloc] initWithFrame:self.bounds];
	[self.containerView addSubview:self.presetManager];
	self.presetManager.delegate = self;
	
	// Configuring input view
	CGRect inputViewFrame = self.inputView.frame;
	inputViewFrame.origin.y = self.frame.size.height - inputViewFrame.size.height + kPMInputOffset;
	self.inputView.frame = inputViewFrame;
	self.inputView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
	self.inputView.alpha = 0;
	self.inputView.delegate = self;
	
	self.captionVisible = NO;
	
	// Setup gestures
    UIPanGestureRecognizer *twoFingerPan = [[UIPanGestureRecognizer alloc] init];
    twoFingerPan.minimumNumberOfTouches = 2;
    twoFingerPan.maximumNumberOfTouches = 2;
    [self.imageTransformView addGestureRecognizer:twoFingerPan];
	
	UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	recognizerLeft.numberOfTouchesRequired = 2;
	[self.imageTransformView addGestureRecognizer:recognizerLeft];
	
	UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
	recognizerRight.numberOfTouchesRequired = 2;
	[self.imageTransformView addGestureRecognizer:recognizerRight];

	[twoFingerPan requireGestureRecognizerToFail:recognizerLeft];
    [twoFingerPan requireGestureRecognizerToFail:recognizerRight];
	
	UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
	[self.containerView addGestureRecognizer:recognizerDown];

	UITapGestureRecognizer * tapGecture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewTap)];
	[self.containerView addGestureRecognizer:tapGecture];
	
	self.currentFont = 0;
	
	self.adviceShown = [[NSUserDefaults standardUserDefaults] boolForKey:kPMKeyAdviceUsed];
}



#pragma mark - Actions

-(void) toggleCaption
{
	self.captionVisible = !self.captionVisible;
	[self animateInputVisible:self.captionVisible];
	self.imageTransformView.userInteractionEnabled = !self.captionVisible;
	[self.inputView inpuStateChanged:self.captionVisible];
}


-(UIImage *) getEditedImage
{
	UIImage *result = nil;
	
	[self.imageProcessingView displayLastFilteredImageView];
	
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 2);
	[self.containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	result = [PMImageUtils correctImage:image];
	UIGraphicsEndImageContext();
	
	DLog(@"result w:%f, h:%f", result.size.width, result.size.height);
	
	return result;
}

#pragma mark - Utils

-(int) getScrollViewYForInputVisible:(BOOL)visible
{
	int result;
	
	if (visible) {
		result = self.inputView.frame.origin.y - self.containerView.frame.size.height;
	} else {
		result = 0;
	}
	
	return result;
}

#pragma mark - Animation

-(void) animateInputVisible:(BOOL)visible
{
	float inputAlpha = visible ? 1.0f : 0.0f;
	CGRect scrollViewRect = self.containerView.frame;
	scrollViewRect.origin.y = [self getScrollViewYForInputVisible:visible];
	
	[UIView animateWithDuration:0.3 animations:^{
		self.inputView.alpha = inputAlpha;
		self.containerView.frame = scrollViewRect;
	}];
}


#pragma mark - Image filtering

-(void) configureWithImage:(UIImage *)image
{
	DAssert(image, @"Image can't be nil");
	NSLog(@"size: %f, %f scale: %f", image.size.width, image.size.height, image.scale);
	
	self.imageProcessingView.sourceImage = image;
	[self.imageProcessingView configureWithViewMode:PMImageProcessingViewModeImage];
	[self.imageTransformView configure];
}


-(void) startup
{
	[self.imageProcessingView startup];
}


-(void) shutdown
{
	[self.imageProcessingView shutdown];
}


-(void) setFilterWithType:(PMFilterType)filterType blurEnabled:(BOOL)blurEnabled
{
	[self.imageProcessingView setFilterWithType:filterType blurEnabled:blurEnabled];
}


#pragma mark - Image Editor Input View Delegate

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
	BOOL success = [self.currentPreset updateText:newText];
	
	if (success) {
		self.currentText = newText;
	}
	
	return success;
}


-(void) fontDidChange:(int)newFontIndex
{
	[self.currentPreset updateFontWithIndex:newFontIndex];
	self.currentFont = newFontIndex;
}


#pragma mark - Presets

-(void) presetDidChanged:(PMImageEditorPresetBase *)currentPreset
{
	[currentPreset updateText:self.currentText];
	[currentPreset updateFontWithIndex:self.currentFont];
	[self.delegate presetChangedWithCaptionEnabled:[currentPreset captionEnabled]];
}


#pragma mark - Gestures

-(void) handleScrollViewTap
{
	if (self.captionVisible) {
		[self.delegate askToggleCaption];
	}
}


-(void) handleSwipe:(UISwipeGestureRecognizer *)swipeRecognizer 
{
	
	if (self.captionVisible) {
		if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
			[self.delegate askToggleCaption];
		}
	} else {
		BOOL isLeft = swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft;
		[self.presetManager handleSwipe:isLeft];
		
		if (!self.adviceShown) {
			self.adviceShown = YES;
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPMKeyAdviceUsed];
		}
	}
}

@end
