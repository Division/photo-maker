//
//  PMView.m
//  PhotoMaker
//
//  Created by Nikita on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"

@interface PMView()

@property (nonatomic, assign) BOOL commonInitCalled;

@end

@implementation PMView

-(instancetype) init
{
    if (self = [super init]) {
        if (!self.commonInitCalled) {
            [self commonInit];
            self.commonInitCalled = YES;
        }
    }
    
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (!self.commonInitCalled) {
            [self commonInit];
            self.commonInitCalled = YES;
        }
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder 
{
	if (self = [super initWithCoder:aDecoder]) {
        if (!self.commonInitCalled) {
            [self commonInit];
            self.commonInitCalled = YES;
        }
	}
	return self;
}


/**
 * Common initialization method
 */
-(void) commonInit 
{
	// Base class does nothing
}


+(id) loadFromNib 
{
	NSString *className = [self description];
	NSArray *elements = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
	return elements[0];
}

@end
