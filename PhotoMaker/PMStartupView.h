//
//  MPStartupView.h
//  PhotoMaker
//
//  Created by Nikita on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PMView.h"

@class PMButton;
@class PMGridView;

@interface PMStartupView : PMView

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet PMButton *takePhotoButton;
@property (nonatomic, strong) IBOutlet PMButton *cameraRollButton;
@property (nonatomic, strong) IBOutlet PMGridView *bottomScroll;
@property (nonatomic, strong) IBOutlet UILabel *bottomScrollLabel;

-(void) playButtonShowAnimation;
-(void) updateBottomScrollLabelWithCameraRollSuccess:(BOOL)cameraRollSuccess;
-(void) showBottomScrollWithCameraRollSuccess:(BOOL)cameraRollSuccess;
-(void) hideBottomScroll;

@end
