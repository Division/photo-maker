//
//  PMViewController.m
//  PhotoMaker
//
//  Created by Nikita on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMViewController.h"

@interface PMViewController ()

@property (nonatomic, assign) BOOL commonInitCalled;

@end



@implementation PMViewController

@synthesize commonInitCalled = _commonInitCalled;

+(id) loadFromNib 
{
	NSString *className = [self description];
	return [[self alloc] initWithNibName:className bundle:nil];
}


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


-(instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        if (!self.commonInitCalled) {
            [self commonInit];
            self.commonInitCalled = YES;
        }
    }
    
    return self;
}


-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        if (!self.commonInitCalled) {
            [self commonInit];
            self.commonInitCalled = YES;
        }
    }
    
    return self;
}


-(void) commonInit 
{
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}


-(void) dealloc 
{
	// Make sure viewDidUnload called
	[self viewDidUnload];
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
