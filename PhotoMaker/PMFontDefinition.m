//
//  PMFontDefinition.m
//  PhotoMaker
//
//  Created by Nikita on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMFontDefinition.h"
#import "PMConst.h"

@interface PMFontDefinition()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float scale;

@end

@implementation PMFontDefinition

@synthesize name = _name;
@synthesize scale = _scale;

static NSArray *_allFontDefinitions;

+(void) initialize
{
	if (self == [PMFontDefinition class]) {
		_allFontDefinitions = @[[[PMFontDefinition alloc] initWithFontName:kPMFontHelvetica		andScale:1],
														  [[PMFontDefinition alloc] initWithFontName:kPMFontCollegiate		andScale:1.1],
														  [[PMFontDefinition alloc] initWithFontName:kPMFontCompleteHim	andScale:1.6],
														  [[PMFontDefinition alloc] initWithFontName:kPMFontLobster		andScale:1.1],
														  [[PMFontDefinition alloc] initWithFontName:kPMFontTT1018M		andScale:1],
														  [[PMFontDefinition alloc] initWithFontName:kPMFontBALLW			andScale:1.2]];
	}
}


-(instancetype) initWithFontName:(NSString *)name andScale:(float)scale
{
	if (self = [super init]) {
		self.name = name;
		self.scale = scale;
	}
	
	return self;
}


+(UIFont *) fontWithIndex:(int)index forSize:(float)size
{
	PMFontDefinition *definition = _allFontDefinitions[index];
	return [UIFont fontWithName:definition.name size:size * definition.scale];
}

@end
