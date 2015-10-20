//
//  PMTakePhotoController.h
//  PhotoMaker
//
//  Created by Nikita on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMViewController.h"

@interface PMTakePhotoController : PMViewController

-(IBAction) didPressCancel:(id)sender;
-(IBAction) didPressFilters:(id)sender;
-(IBAction) didPressMakePhoto:(id)sender;
-(IBAction) didPressFlashlightToggle:(id)sender;
-(IBAction) didPressFrontBackCameraToggle:(id)sender;
-(IBAction) didPressBlurToggle:(id)sender;

@end
