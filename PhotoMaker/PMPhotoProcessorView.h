//
//  PMPhotoProcessorView.h
//  PhotoMaker
//
//  Created by Nikita on 9/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"

@class PMButton;
@class PMImageProcessingView;
@class PMFilterSelectionView;
@class PMImageEditorView;

@interface PMPhotoProcessorView : PMView

@property (nonatomic, strong) IBOutlet PMButton *retakeButton;
@property (nonatomic, strong) IBOutlet PMButton *saveButton;
@property (nonatomic, strong) IBOutlet PMButton *captionButton;
@property (nonatomic, strong) IBOutlet PMImageEditorView *imageEditorView;
@property (nonatomic, strong) IBOutlet PMFilterSelectionView *filterSelectionView;
@property (nonatomic, strong) IBOutlet PMView *containerView;

-(void) toggleCaption;
-(void) handleKeyboardAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve andOffset:(int)offset;
-(void) applySourceIsCameraRoll:(BOOL)sourceIsCameraRoll;
-(void) disableInput;

@end
