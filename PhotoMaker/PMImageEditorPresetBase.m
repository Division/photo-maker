//
//  PMImageEditorPresetBase.m
//  PhotoMaker
//
//  Created by Nikita on 9/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMImageEditorPresetBase.h"
#import "PMStringDefines.h"
#import "PMFontDefinition.h"

@implementation PMImageEditorPresetBase

-(void) awakeFromNib
{
	[super awakeFromNib];
	self.label.text = @"";
}




-(BOOL) updateText:(NSString *)newText
{
	BOOL success = [self validateString:newText];
	if (success) {
		self.label.text = newText;
	}
	
	return success;
}


-(void) updateFontWithIndex:(int)index
{
	self.label.font = [PMFontDefinition fontWithIndex:index forSize:[self defaultFontSize]];
}

#pragma mark - Other

-(BOOL) validateString:(NSString *)text
{
	__block int count = 0;
	[text enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
		count++;
	}];
	
	if (count > [self maximumLines]) return NO;
	if (count == [self maximumLines] && [text characterAtIndex:(text.length - 1)] == '\n') return NO;
	
	return YES;
}


-(int) maximumLines
{
	return 2;
}


-(NSString *) placeholderText
{
	return string_enter_text_placeholder;
}


-(float) defaultFontSize 
{
	return 16;
}


-(BOOL) captionEnabled
{
	return YES;
}

@end
