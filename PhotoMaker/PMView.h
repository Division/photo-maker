//
//  PMView.h
//  PhotoMaker
//
//  Created by Nikita on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Base class for all view in the application
 */
@interface PMView : UIView

+(id) loadFromNib;

-(void) commonInit;

@end
