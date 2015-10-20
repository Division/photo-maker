//
//  PMProcessPhotoController.h
//  PhotoMaker
//
//  Created by Nikita on 9/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMViewController.h"
#import "PMImageFilter.h"

#import "PMFilterSelectionView.h"

@interface PMPhotoProcessorController : PMViewController <PMFilterSelectionViewDelegate>

-(void) configureWithImage:(UIImage *)image filterType:(PMFilterType)filterType blurEnabled:(BOOL)blurEnabled sourceIsCameraRoll:(BOOL)sourceIsCameraRoll;

-(IBAction) didPressRetale:(id)sender;
-(IBAction) didPressSave:(id)sender;
-(IBAction) didPressCaption:(id)sender;

@end
