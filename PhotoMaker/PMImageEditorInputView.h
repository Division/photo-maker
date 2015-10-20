//
//  PMImageEditorInputView.h
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"
#import "PMTabBar.h"

@protocol PMImageEditorInputViewDelegate <UITextViewDelegate>

-(void) fontDidChange:(int)newFontIndex;

@end

@interface PMImageEditorInputView : PMView <PMTabBarDelegate>

@property (strong, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong, nonatomic) IBOutlet PMTabBar *fontTabBar;
@property (strong, nonatomic) IBOutlet UIImageView *inputBackgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, unsafe_unretained) id<PMImageEditorInputViewDelegate> delegate;

-(void) inpuStateChanged:(BOOL)isEnabled;

@end
