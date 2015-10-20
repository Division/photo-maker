//
//  PMViewController.m
//  PhotoMaker
//
//  Created by NSidorenko on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMStartupController.h"
#import "PMStartupView.h"
#import "PMCellView.h"
#import "PMStartupPhotosDataProvider.h"
#import "PMTakePhotoController.h"
#import "PMPhotoProcessorController.h"
#import "PMStringDefines.h"
#import "PMConst.h"
#import "PMImageUtils.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PMStartupController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic, readonly) PMStartupView *startupView;
@property (weak, nonatomic, readonly) PMGridView *bottomScroll;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) PMStartupPhotosDataProvider *photoDataProvider;
@property (nonatomic, assign) BOOL buttonAnimPlayed;

@end

@implementation PMStartupController

#pragma mark - Properties

-(PMStartupView *) startupView
{
	return (PMStartupView *)self.view;
}


-(PMGridView *) bottomScroll
{
	return self.startupView.bottomScroll;
}

#pragma mark - init/dealloc

-(void) commonInit
{
	[super commonInit];
    self.photoDataProvider = [[PMStartupPhotosDataProvider alloc] init];
    self.photoDataProvider.delegate = self;
    [self.photoDataProvider loadCameraRoll];
	self.buttonAnimPlayed = NO;
}



#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
	self.bottomScroll.dataSource = self;
	self.bottomScroll.delegate = self;
	[self.bottomScroll reloadData];
	
	if (self.photoDataProvider.dataLoaded) {
		[self.startupView updateBottomScrollLabelWithCameraRollSuccess:self.photoDataProvider.usingCameraRoll];
	} else {
		[self.startupView hideBottomScroll];
	}
	
	if (!self.buttonAnimPlayed) {
		self.buttonAnimPlayed = YES;
		[self.startupView playButtonShowAnimation];
	}
}


-(void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - Utils

-(void) showProcessorControllerWithImage:(UIImage *)image
{
	if (image.size.width * image.scale < kPMMinimumImageSize || image.size.height * image.scale < kPMMinimumImageSize) {
		// Image is incorrect size
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string_error 
														 message:string_image_too_small
														delegate:nil 
											   cancelButtonTitle:string_ok 
											   otherButtonTitles:nil];
		[alert show];
	} else {
		PMPhotoProcessorController *processorController = [PMPhotoProcessorController loadFromNib];
		image = [PMImageUtils correctImage:image];
		[processorController configureWithImage:image filterType:PMFilterTypeNone blurEnabled:NO sourceIsCameraRoll:YES];
		[self presentViewController:processorController animated:YES completion:nil];
	}
}


#pragma mark - Grid View Data Source

-(PMCellView *) gridView:(PMGridView *)gridView cellForItemAtIndex:(NSInteger)cellIndex
{
	PMCellView *cell = [gridView dequeueReusableCell];
	if (!cell) {
		CGSize size = [self sizeForCellsInGridView:gridView];
		CGRect cellRect = CGRectMake(0, 0, size.width, size.height);
		cell = [[PMCellView alloc] initWithFrame:cellRect];
	}
	
	for (UIView *view in cell.subviews) {
		[view removeFromSuperview];
	}

    UIImage *image = [self.photoDataProvider thumbnailAtIndex:cellIndex];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = cell.bounds;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [cell addSubview:imageView];
	
	return cell;
}


-(CGSize) sizeForCellsInGridView:(PMGridView *)gridView
{
	return CGSizeMake(60, 60);
}


-(NSInteger) numberOfItemsInGridView:(PMGridView *)gridView
{
	return [self.photoDataProvider countOfImages];
}

#pragma mark - Grid View Delegate

-(void) gridView:(PMGridView *)gridView didTapOnItemAtIndex:(NSInteger)index
{
	UIImage *image = [self.photoDataProvider imageAtIndex:index];
	[self showProcessorControllerWithImage:image];
}


#pragma mark - Startup Photos Data Provider Delegate

-(void) imageDataDidUpdate:(BOOL)cameraRollFailed
{
    [self.bottomScroll reloadData];
	BOOL cameraRollSuccess = !cameraRollFailed;
	[self.startupView showBottomScrollWithCameraRollSuccess:cameraRollSuccess];
}

#pragma - Button handlers

-(IBAction)didPressTakeAPhoto:(id)sender
{
	// Checking if device has camera
	if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
		PMTakePhotoController *takePhotoController = [PMTakePhotoController loadFromNib];
		[self presentViewController:takePhotoController animated:YES completion:nil];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string_error 
														 message:string_camera_unavailable 
														delegate:nil 
											   cancelButtonTitle:string_ok 
											   otherButtonTitles:nil];
		[alert show];
	}
}


-(IBAction) didPressCameraRoll:(id)sender
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	picker.delegate = self;
	[self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = info[UIImagePickerControllerOriginalImage];
	[self dismissViewControllerAnimated:NO completion:nil];
	[self showProcessorControllerWithImage:image];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


-(void) assetsChanged
{
	[self.startupView hideBottomScroll];
}

@end
