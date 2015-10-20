//
//  PMTabBar.m
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMTabBar.h"
#import "PMButton.h"

@interface PMTabBar()

@property (nonatomic, strong) NSArray *allButtons;
@property (nonatomic, assign) CGSize leftSize;
@property (nonatomic, assign) CGSize rightSize;
@property (nonatomic, assign) int buttonCount;
@property (nonatomic, strong) PMButton *selectedButton;

@end

@implementation PMTabBar

-(void) commonInit
{
	[super commonInit];
	self.backgroundColor = [UIColor clearColor];
}




-(void) configureWithButtonCount:(int)buttonCount
                 backgroundImage:(UIImage *)backgroundImage
                       leftImage:(UIImage *)leftImage
                 leftImageActive:(UIImage *)leftImageActive
                     middleImage:(UIImage *)middleImage
               middleImageActive:(UIImage *)middleImageActive
                      rightImage:(UIImage *)rightImage
                rightImageActive:(UIImage *)rightImageActive
{
    DAssert(buttonCount > 2, @"Supported only 3+ button count");
    
    self.buttonCount = buttonCount;
    NSMutableArray *buttons = [NSMutableArray array];
    self.leftSize = leftImage.size;
    self.rightSize = rightImage.size;
    
    for (int i = 0; i < buttonCount; i++) {
        PMButton *button = [PMButton buttonWithPMType:PMButtonTypeTab];
        
        UIImage *backgroundImage = middleImage;
        UIImage *backgroundImageActive = middleImageActive;
        
        if (i == 0) {
            backgroundImage = leftImage;
            backgroundImageActive = leftImageActive;
        } else
        if (i == buttonCount - 1) {
            backgroundImage = rightImage;
            backgroundImageActive = rightImageActive;
        }
        
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:backgroundImageActive forState:UIControlStateHighlighted];
        [button setBackgroundImage:backgroundImageActive forState:UIControlStateSelected];
        [button setBackgroundImage:backgroundImageActive forState:UIControlStateHighlighted | UIControlStateSelected];
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonDidTap:) forControlEvents:UIControlEventTouchUpInside];
        
		button.adjustsImageWhenHighlighted = NO;
		
        [buttons addObject:button];
        [self addSubview:button];
    }
    
    self.allButtons = [NSArray arrayWithArray:buttons];

    [self setNeedsLayout];
}


-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize currentSize = CGSizeMake((int)(self.frame.size.width / self.buttonCount), self.leftSize.height);
    
    float currentLeftOffset = 0;
    for (int i = 0; i < self.buttonCount; i++) {
        PMButton *button = (self.allButtons)[i];
        
        button.frame = CGRectIntegral( CGRectMake(currentLeftOffset, 0, currentSize.width, currentSize.height) );
        currentLeftOffset += currentSize.width;
    }
}


-(void) setButtonSelectedWithIndex:(int)index
{
    self.selectedButton.selected = NO;
    self.selectedButton = (self.allButtons)[index];
    self.selectedButton.selected = YES;
}


-(void) buttonDidTap:(PMButton *)button
{
	int index = button.tag;
	
	if (self.selectedButton && self.selectedButton.tag == index) {
		return;
	}
	
    [self setButtonSelectedWithIndex:index];
	
	[self.delegate tabBar:self didSelectItemWithIndex:index];
}

@end
