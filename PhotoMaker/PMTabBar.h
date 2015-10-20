//
//  PMTabBar.h
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"

@class PMTabBar;

@protocol PMTabBarDelegate <NSObject>

-(void) tabBar:(PMTabBar *)tabBar didSelectItemWithIndex:(NSInteger)index;

@end

@interface PMTabBar : PMView

-(void) configureWithButtonCount:(int)buttonCount
                 backgroundImage:(UIImage *)backgroundImage
                       leftImage:(UIImage *)leftImage
                 leftImageActive:(UIImage *)leftImageActive
                     middleImage:(UIImage *)middleImage
               middleImageActive:(UIImage *)middleImageActive
                      rightImage:(UIImage *)rightImage
                rightImageActive:(UIImage *)rightImageActive;


-(void) setButtonSelectedWithIndex:(int)index;

@property (nonatomic, weak) id <PMTabBarDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *allButtons;

@end
