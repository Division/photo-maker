//
//  PMViewController.h
//  PhotoMaker
//
//  Created by NSidorenko on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PMViewController.h"
#import "PMGridView.h"
#import "PMStartupPhotosDataProvider.h"

@interface PMStartupController : PMViewController<PMGridViewDataSource, PMGridViewDelegate, PMStartupPhotosDataProviderDelegate>

-(IBAction) didPressCameraRoll:(id)sender;
-(IBAction)didPressTakeAPhoto:(id)sender;

@end
