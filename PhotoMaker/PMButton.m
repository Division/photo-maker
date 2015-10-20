//
//  PMButton.m
//  PhotoMaker
//
//  Created by Nikita on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMButton.h"
#import "PMConst.h"
#import "PMImageUtils.h"
#import <QuartzCore/QuartzCore.h>

@interface PMButton()

@property (nonatomic, assign) BOOL commonInitCalled;

@end

@implementation PMButton

@synthesize pmButtonType = _pmButtonType;
@synthesize commonInitCalled = _commonInitCalled;
@synthesize blurEnabled = _blurEnabled;

#pragma mark - Static methods

+(PMButton *)buttonWithPMType:(PMButtonType)type
{
    PMButton *result = [self buttonWithType:UIButtonTypeCustom];
    result.pmButtonType = type;
    return result;
}

#pragma mark - Properties

-(void) setPmButtonType:(PMButtonType)buttonType
{
    _pmButtonType = buttonType;
    [self setupButton];
}


-(void) setBlurEnabled:(BOOL)blurEnabled
{
	_blurEnabled = blurEnabled;

	if (blurEnabled) {
		self.layer.shadowColor = [UIColor whiteColor].CGColor;
		self.layer.shadowRadius = 6;
		self.layer.shadowOpacity = 2;
		self.layer.shadowOffset = CGSizeZero;
	} else {
		self.layer.shadowRadius = 0;
		self.layer.shadowOpacity = 0;		
	}
}

#pragma mark - init/dealloc

-(instancetype) init 
{
    if (self = [super init]) {
        if (!self.commonInitCalled) {
            [self commonInit];
            self.commonInitCalled = YES;
        }
    }

    return self;
}


-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (!self.commonInitCalled) {
            [self commonInit];
            self.commonInitCalled = YES;
        }
    }
    
    return self;
}


-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        if (!self.commonInitCalled) {
            [self commonInit];
            self.commonInitCalled = YES;
        }
    }
    
    return self;
}


-(void) commonInit
{
    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}



#pragma mark - Setup

-(void) setupButton
{
    [self setupBackground];
    [self setupFont];
	[self setupImage];
}


-(void) setupBackground
{
    switch (self.pmButtonType) {
        case PMButtonTypeBlack:
            [self setBackgroundImage:[PMImageUtils buttonBlack] forState:UIControlStateNormal];
            [self setBackgroundImage:[PMImageUtils buttonBlackHighlited] forState:UIControlStateHighlighted];
            break;

        case PMButtonTypeBlue:
            [self setBackgroundImage:[PMImageUtils buttonBlue] forState:UIControlStateNormal];
            [self setBackgroundImage:[PMImageUtils buttonBlueHighlited] forState:UIControlStateHighlighted];
            break;
			
        case PMButtonTypeTransparent:
            [self setBackgroundImage:[PMImageUtils buttonTransparent] forState:UIControlStateNormal];
            [self setBackgroundImage:[PMImageUtils buttonTransparentHighlited] forState:UIControlStateHighlighted];
            [self setBackgroundImage:[PMImageUtils buttonTransparentHighlited] forState:UIControlStateSelected];
            break;
			
		case PMButtonTypeAction:
            [self setBackgroundImage:[PMImageUtils buttonAction] forState:UIControlStateNormal];			
            [self setBackgroundImage:[PMImageUtils buttonActionHighlited] forState:UIControlStateHighlighted];
            [self setBackgroundImage:[PMImageUtils buttonActionActive] forState:UIControlStateSelected];
			break;
			
        default:
            break;
    }
}


-(void) setupFont
{
    switch (self.pmButtonType) {
        case PMButtonTypeBlack:
            self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            break;

        case PMButtonTypeBlue:
            self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [self setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
            break;
            
		case PMButtonTypeTransparent:
			[self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
			[self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
			break;
			
		case PMButtonTypeAction:
            self.titleLabel.font = [UIFont boldSystemFontOfSize:13];			
			self.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
			break;
			
		case PMButtonTypeBlur:
			self.titleEdgeInsets = UIEdgeInsetsMake(0, -37, 0, 0);
			self.imageEdgeInsets = UIEdgeInsetsMake(0, 37, 0, 0);
			break;
			
        default:
            self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            break;
    }
}


-(void) setupImage
{
	switch (self.pmButtonType) {
		case PMButtonTypeFlashlight:
			[self setImage:[PMImageUtils buttonFlashlight] forState:UIControlStateNormal];
			break;

		case PMButtonTypeBlur:
			[self setImage:[PMImageUtils buttonBlur] forState:UIControlStateNormal];
			break;
			
		case PMButtonTypeSwitchCamera:
			[self setImage:[PMImageUtils buttonSwitchCamera] forState:UIControlStateNormal];
			break;

		default:
			break;
	}
}

@end
