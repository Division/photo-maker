//
//  PMImageEditorPresetManagerView.h
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"

@class PMImageEditorPresetBase;

@protocol PMImageEditorPresetManagerViewDelegate <NSObject>

-(void) presetDidChanged:(PMImageEditorPresetBase *)currentPreset;

@end


@interface PMImageEditorPresetManagerView : PMView

-(void) handleSwipe:(BOOL) isLeft;

@property (readonly, nonatomic, strong) PMImageEditorPresetBase *currentPreset;
@property (nonatomic, unsafe_unretained) id<PMImageEditorPresetManagerViewDelegate> delegate;

@end
