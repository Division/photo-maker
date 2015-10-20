//
//  PMAppDelegate.h
//  PhotoMaker
//
//  Created by NSidorenko on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMStartupController;

@interface PMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PMStartupController *viewController;

@end
