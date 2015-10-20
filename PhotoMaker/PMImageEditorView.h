//
//  PMImageEditorView.h
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"
#import "PMImageFilter.h"

@protocol PMImageEditorViewDelegate <NSObject>

-(void) askToggleCaption;
-(void) presetChangedWithCaptionEnabled:(BOOL)captionEnabled;

@end


@interface PMImageEditorView : PMView

-(void) configureWithImage:(UIImage *)image;
-(void) startup;
-(void) shutdown;
-(void) setFilterWithType:(PMFilterType)filterType blurEnabled:(BOOL)blurEnabled;

-(void) toggleCaption;

@property (getter=getEditedImage, readonly, strong) UIImage *editedImage;

@property (nonatomic, readonly) BOOL captionVisible;
@property (nonatomic, weak) id<PMImageEditorViewDelegate> delegate;

@end
