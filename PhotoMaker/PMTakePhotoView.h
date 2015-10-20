//
//  PMTakePhotoView.h
//  PhotoMaker
//
//  Created by Nikita on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"

@class PMButton;
@class PMImageProcessingView;
@class PMFilterSelectionView;

@interface PMTakePhotoView : PMView

@property (strong, nonatomic) IBOutlet PMButton *flashLightButton;
@property (strong, nonatomic) IBOutlet PMButton *cameraSwitchButton;
@property (strong, nonatomic) IBOutlet PMButton *blurButton;
@property (strong, nonatomic) IBOutlet PMButton *cancelButton;
@property (strong, nonatomic) IBOutlet PMButton *makePhotoButton;
@property (strong, nonatomic) IBOutlet PMButton *filtersButton;

@property (strong, nonatomic) IBOutlet PMFilterSelectionView *filterSelectionView;
@property (strong, nonatomic) IBOutlet PMImageProcessingView *imageProcessingView;
@property (strong, nonatomic) IBOutlet PMView *bottomContainerView;

-(void) setInputEnabled:(BOOL)enabled;
-(void) displayBlurEnabled:(BOOL)blurEnabled;
-(void) displayFlashEnabled:(BOOL)flashEnabled;
-(void) hideFlash;
-(void) hideFilters;
-(void) toggleFiltersDisplay;
-(void) handleBlurEnabled:(BOOL)blurEnabled;

@end
