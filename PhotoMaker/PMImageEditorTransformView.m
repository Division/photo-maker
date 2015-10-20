//
//  PMImageEditorTransformView.m
//  PhotoMaker
//
//  Created by Nikita on 10/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMImageEditorTransformView.h"
#import "PMImageProcessingView.h"
#import "PMView.h"

@interface PMImageEditorTransformView()

@property (nonatomic, strong) PMImageProcessingView *imageProcessingView;

@end

@implementation PMImageEditorTransformView

@synthesize imageProcessingView = _imageProcessingView;

-(instancetype) initWithFrame:(CGRect)frame andImageProcessingView:(PMImageProcessingView *)imageProcessingView
{
	if (self = [super initWithFrame:frame]) {
		imageProcessingView.frame = frame;
		self.imageProcessingView = imageProcessingView;
		self.imageProcessingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		[self addSubview:imageProcessingView];
		self.delegate = self;
		self.decelerationRate = UIScrollViewDecelerationRateFast;

		self.scrollEnabled = YES;
		
		self.bounces = NO;
		self.bouncesZoom = NO;
		
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
	}
	
	return self;
}



#pragma mark - Configuration

-(void) configure
{
	CGSize sourceImageSize = self.imageProcessingView.sourceImage.size;
	self.imageProcessingView.frame = CGRectMake(0, 0, sourceImageSize.width, sourceImageSize.height);
	self.contentSize = sourceImageSize;
	
	float scaleWidth = self.frame.size.width / sourceImageSize.width;
	float scaleHeight = self.frame.size.height / sourceImageSize.height;
	float minScale = MAX(scaleWidth, scaleHeight);
	
	self.minimumZoomScale = minScale;
	self.maximumZoomScale = 1;
	self.zoomScale = minScale;
}

#pragma mark - Scroll View Delegate

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageProcessingView;
}

@end
