//
//  PMImageUtils.m
//  PhotoMaker
//
//  Created by NSidorenko on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMImageUtils.h"

#import "PMButton.h"
#import "PMConst.h"

@implementation PMImageUtils

static UIImage *_imageButtonBlack;
static UIImage *_imageButtonBlackHighlited;
static UIImage *_imageButtonBlue;
static UIImage *_imageButtonBlueHighlited;
static UIImage *_imageButtonAction;
static UIImage *_imageButtonActionHighlited;
static UIImage *_imageButtonActionActive;
static UIImage *_imageEditorInput;
static UIImage *_imageTabMiddle;
static UIImage *_imageTabMiddleActive;
static UIImage *_imageTabLeft;
static UIImage *_imageTabLeftActive;
static UIImage *_imageTabRight;
static UIImage *_imageTabRightActive;



#pragma mark - Initialization


+(void) initialize
{
    if (self == [PMImageUtils class]) {
        _imageButtonBlack = [[self imageNamed:kPMImageButtonBlack] stretchableImageWithLeftCapWidth:kPMDefaultButtonCaps.width 
																						topCapHeight:kPMDefaultButtonCaps.height];
        
        _imageButtonBlackHighlited = [[self imageNamed:kPMImageButtonBlackPressed]stretchableImageWithLeftCapWidth:kPMDefaultButtonCaps.width 
																									   topCapHeight:kPMDefaultButtonCaps.height];
        
        _imageButtonBlue = [[self imageNamed:kPMImageButtonBlue] stretchableImageWithLeftCapWidth:kPMDefaultButtonCaps.width 
																					  topCapHeight:kPMDefaultButtonCaps.height];
        
        _imageButtonBlueHighlited = [[self imageNamed:kPMImageButtonBluePressed]stretchableImageWithLeftCapWidth:kPMDefaultButtonCaps.width 
																									 topCapHeight:kPMDefaultButtonCaps.height];
		
        _imageButtonAction = [[self imageNamed:kPMImageButtonAction] stretchableImageWithLeftCapWidth:kPMActionButtonCaps.width 
																						  topCapHeight:kPMActionButtonCaps.height];

        _imageButtonActionHighlited = [[self imageNamed:kPMImageButtonActionPressed] stretchableImageWithLeftCapWidth:kPMActionButtonCaps.width 
																										  topCapHeight:kPMActionButtonCaps.height];

        _imageButtonActionActive = [[self imageNamed:kPMImageButtonActionActive] stretchableImageWithLeftCapWidth:kPMActionButtonCaps.width 
																									  topCapHeight:kPMActionButtonCaps.height];

        _imageEditorInput = [[self imageNamed:kPMImageEditorInput] stretchableImageWithLeftCapWidth:kPMImageEditorInputCaps.width
																						topCapHeight:kPMImageEditorInputCaps.height];
        
        _imageTabMiddle = [[self imageNamed:kPMImageTabMiddle] stretchableImageWithLeftCapWidth:kPMTabMiddleCaps.width
																					topCapHeight:kPMTabMiddleCaps.height];

        _imageTabMiddleActive = [[self imageNamed:kPMImageTabMiddleActive] stretchableImageWithLeftCapWidth:kPMTabMiddleCaps.width
                                                                                                topCapHeight:kPMTabMiddleCaps.height];

        _imageTabLeft = [[self imageNamed:kPMImageTabLeft] stretchableImageWithLeftCapWidth:kPMTabLeftCaps.width
																				topCapHeight:kPMTabLeftCaps.height];
		
        _imageTabLeftActive = [[self imageNamed:kPMImageTabLeftActive] stretchableImageWithLeftCapWidth:kPMTabLeftCaps.width
																							topCapHeight:kPMTabLeftCaps.height];

        _imageTabRight = [[self imageNamed:kPMImageTabRight] stretchableImageWithLeftCapWidth:kPMTabRightCaps.width
																				topCapHeight:kPMTabRightCaps.height];
		
        _imageTabRightActive = [[self imageNamed:kPMImageTabRightActive] stretchableImageWithLeftCapWidth:kPMTabRightCaps.width
																							topCapHeight:kPMTabRightCaps.height];

    }
}

#pragma mark Other

+(UIImage *) imageNamed:(NSString *)imageName
{
	UIImage *result = [UIImage imageNamed:imageName];
	
	if (!result) {
		DLog(@"WARNING: image '%@' not found", imageName);
	}
	
	return result;
}


+(UIImage *) correctImage:(UIImage *)image 
{
	CGSize drawSize = image.size;
	
	float koef = 1;

	float maxSide = MAX(image.size.width, image.size.height);
	float minSide = MIN(image.size.width, image.size.height);
	
	// Adjusting koef if image size is out of min/max bounds
	if (maxSide > kPMMaximumImageSize) {
		koef = kPMMaximumImageSize / maxSide;
	} else if (minSide < kPMMinimumImageSize) {
		koef = kPMMinimumImageSize / minSide;
	}

	// Divide by 2 because we are setting scale to 2. Size must be twice smaller.
	koef *= 0.5;
	
	drawSize.width *= koef;
	drawSize.height *= koef;
	
    UIGraphicsBeginImageContextWithOptions(drawSize, NO, 2);
    [image drawInRect:(CGRect){0, 0, drawSize}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return normalizedImage;
}

#pragma mark - Buttons

+(UIImage *) buttonBlack { return _imageButtonBlack; }

+(UIImage *) buttonBlackHighlited { return _imageButtonBlackHighlited; }

+(UIImage *) buttonBlue { return _imageButtonBlue; }

+(UIImage *) buttonBlueHighlited { return _imageButtonBlueHighlited; }

+(UIImage *) buttonTransparent { return [self imageNamed:kPMImageButtonTransparent]; }

+(UIImage *) buttonTransparentHighlited { return [self imageNamed:kPMImageButtonTransparentPressed]; }

+(UIImage *) buttonAction { return _imageButtonAction; }

+(UIImage *) buttonActionHighlited { return _imageButtonActionHighlited; }

+(UIImage *) buttonActionActive { return _imageButtonActionActive; }

+(UIImage *) buttonBlur { return [self imageNamed:kPMImageButtonBlur]; }

+(UIImage *) buttonFlashlight { return [self imageNamed:kPMImageButtonFlashlight]; }

+(UIImage *) buttonSwitchCamera { return [self imageNamed:kPMImageButtonSwitchCamera]; }

+(UIImage *) tabMiddle { return _imageTabMiddle; }

+(UIImage *) tabMiddleActive { return _imageTabMiddleActive; }

+(UIImage *) tabLeft { return _imageTabLeft; }

+(UIImage *) tabLeftActive { return _imageTabLeftActive; }

+(UIImage *) tabRight { return _imageTabRight; }

+(UIImage *) tabRightActive { return _imageTabRightActive; }


#pragma mark - Image editor

+(UIImage *) imageEditorInput { return _imageEditorInput; }

@end
