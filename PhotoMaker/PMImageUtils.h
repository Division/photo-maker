//
//  PMImageUtils.h
//  PhotoMaker
//
//  Created by NSidorenko on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMImageUtils : NSObject

+(UIImage *) imageNamed:(NSString *)imageName;

/**
 Returns image that meets requirements of the application
 Small images become larger
 Large images become smaller
 Image rotated if needed (to the up orientation)
 Image scale set to 2.0
 */
+(UIImage *) correctImage:(UIImage *)image;

+(UIImage *) buttonBlack;
+(UIImage *) buttonBlackHighlited;
+(UIImage *) buttonBlue;
+(UIImage *) buttonBlueHighlited;
+(UIImage *) buttonTransparent;
+(UIImage *) buttonTransparentHighlited;
+(UIImage *) buttonAction;
+(UIImage *) buttonActionHighlited;
+(UIImage *) buttonActionActive;
+(UIImage *) buttonBlur;
+(UIImage *) buttonFlashlight;
+(UIImage *) buttonSwitchCamera;
+(UIImage *) imageEditorInput;
+(UIImage *) tabMiddle;
+(UIImage *) tabMiddleActive;
+(UIImage *) tabLeft;
+(UIImage *) tabLeftActive;
+(UIImage *) tabRight;
+(UIImage *) tabRightActive;

@end
