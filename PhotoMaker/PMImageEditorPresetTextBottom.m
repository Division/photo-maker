//
//  PMImageEditorPresetTextBottom.m
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMImageEditorPresetTextBottom.h"

@implementation PMImageEditorPresetTextBottom


-(void) awakeFromNib
{
	[super awakeFromNib];
	self.maskImageView.hidden = YES;
}


-(BOOL) updateText:(NSString *)newText
{
	BOOL result = [super updateText:newText];
	
	self.maskImageView.hidden = self.label.text.length == 0;
	return result;
}



@end
