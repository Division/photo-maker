//
//  PMProcessPhotoController.m
//  PhotoMaker
//
//  Created by Nikita on 9/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMPhotoProcessorController.h"
#import "PMPhotoProcessorView.h"
#import "PMImageEditorView.h"
#import "PMConst.h"
#import "PMStringDefines.h"
#import "PMOperationQueue.h"

@interface PMPhotoProcessorController() <UIAlertViewDelegate>

@property (nonatomic, assign) BOOL alreadyConfigured;
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, assign) BOOL blurEnabled;
@property (nonatomic, assign) PMFilterType currentFilterType;
@property (nonatomic, assign) BOOL sourceIsCameraRoll;

@property (weak, nonatomic, readonly) PMImageEditorView *imageEditorView;
@property (weak, nonatomic, readonly) PMPhotoProcessorView *photoProcessorView;
@property (weak, nonatomic, readonly) PMFilterSelectionView *filterSelectionView;

@end

@implementation PMPhotoProcessorController

static BOOL _sessionAdviceShown = NO;

#pragma mark - Properties

-(PMPhotoProcessorView *) photoProcessorView
{
	return (PMPhotoProcessorView *)self.view;
}


-(PMImageEditorView *) imageEditorView
{
	return self.photoProcessorView.imageEditorView;
}


-(PMFilterSelectionView *) filterSelectionView
{
	return self.photoProcessorView.filterSelectionView;
}

#pragma mark - init/dealloc

-(void) commonInit
{
	[super commonInit];
	self.alreadyConfigured = NO;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	DAssert(self.alreadyConfigured, @"PMPhotoProcessorController must be configured before loading");
	[self.imageEditorView configureWithImage:self.sourceImage];
	self.filterSelectionView.filterSelectionDelegate = self;
	[self.photoProcessorView applySourceIsCameraRoll:self.sourceIsCameraRoll];
	
	[self applyCurrentFiltering];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) viewWillAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.filterSelectionView.selectedIndex = self.currentFilterType;
	[self.imageEditorView startup];
	[self applyCurrentFiltering];

	// Listening to keyboard appearing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.imageEditorView shutdown];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	BOOL adviceUsed = [[NSUserDefaults standardUserDefaults] boolForKey:kPMKeyAdviceUsed];
	if (!adviceUsed && !_sessionAdviceShown) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string_advice message:string_editor_help delegate:nil cancelButtonTitle:string_ok otherButtonTitles:nil];
		_sessionAdviceShown = YES;
		[alert show];
	}
}

#pragma mark - Filtering

-(void) applyCurrentFiltering
{
	[self.imageEditorView setFilterWithType:self.currentFilterType blurEnabled:self.blurEnabled];
}

#pragma mark - Configuration

-(void) configureWithImage:(UIImage *)image filterType:(PMFilterType)filterType blurEnabled:(BOOL)blurEnabled sourceIsCameraRoll:(BOOL)sourceIsCameraRoll
{
	DAssert(!self.alreadyConfigured, @"PMPhotoProcessorController configured twice");
	self.alreadyConfigured = YES;
	self.currentFilterType = filterType;
	self.sourceImage = image;
	self.blurEnabled = blurEnabled;
	self.sourceIsCameraRoll = sourceIsCameraRoll;
}

#pragma mark - Filter Selection View Delegate

-(void) filterDidSelect:(PMFilterType)type
{
	self.currentFilterType = type;
	[self applyCurrentFiltering];
}

#pragma mark - Button actions

-(IBAction) didPressRetale:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction) didPressSave:(id)sender
{
	UIImage *result = [self.imageEditorView getEditedImage];
	[self.photoProcessorView disableInput];
	UIImageWriteToSavedPhotosAlbum(result, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string_done message:string_image_saved delegate:self cancelButtonTitle:string_ok otherButtonTitles:nil];
	[alert show];		
}


-(IBAction) didPressCaption:(id)sender
{
	[self.photoProcessorView toggleCaption];
}


#pragma mark - Keyboard

-(void) keyboardWillShow:(NSNotification*)notification
{
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect keyboardFrame;
	
	[[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[notification userInfo][UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
	
	[self.photoProcessorView handleKeyboardAnimationWithDuration:animationDuration curve:animationCurve andOffset:keyboardFrame.size.height];
}

-(void)keyboardWillHide:(NSNotification*)notification
{
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;

    [[notification userInfo][UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

	[self.photoProcessorView handleKeyboardAnimationWithDuration:animationDuration curve:animationCurve andOffset:0];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
