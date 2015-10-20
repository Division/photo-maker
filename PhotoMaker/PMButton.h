//
//  PMButton.h
//  PhotoMaker
//
//  Created by Nikita on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PMView.h"

typedef enum
{
    PMButtonTypeBlack,
    PMButtonTypeBlue,
    PMButtonTypeTransparent,
    PMButtonTypeAction,
	PMButtonTypeFlashlight,
	PMButtonTypeBlur,
	PMButtonTypeSwitchCamera,
    PMButtonTypeTab
    
} PMButtonType;

@interface PMButton : UIButton

+(PMButton *)buttonWithPMType:(PMButtonType)type;

@property (nonatomic, assign) PMButtonType pmButtonType;
@property (nonatomic, assign) BOOL blurEnabled;

-(void) commonInit;

@end
