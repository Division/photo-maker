//
//  PMImageEditorPresetBase.h
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"

@interface PMImageEditorPresetBase : PMView

@property (nonatomic, strong) IBOutlet UILabel *label;

-(BOOL) updateText:(NSString *)newText;
-(void) updateFontWithIndex:(int)index;
@property (readonly) BOOL captionEnabled;

@end
