//
//  PMImageEditorTransformView.h
//  PhotoMaker
//
//  Created by Nikita on 10/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMImageProcessingView;

@interface PMImageEditorTransformView : UIScrollView <UIScrollViewDelegate>

-(instancetype) initWithFrame:(CGRect)frame andImageProcessingView:(PMImageProcessingView *)imageProcessingView;

/**
 Must be called after imageProcessingView is configured
 */
-(void) configure;

@property (nonatomic, strong, readonly) PMImageProcessingView *imageProcessingView;

@end
