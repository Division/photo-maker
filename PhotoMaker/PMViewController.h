//
//  PMViewController.h
//  PhotoMaker
//
//  Created by Nikita on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMViewController : UIViewController

+(id) loadFromNib;

// Subclasses can owerride
-(void) commonInit;

@end
