//
//  PMOperationQueue.m
//  PhotoMaker
//
//  Created by NSidorenko on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMOperationQueue.h"

static const int kPMBackgroundQueueConcurrentCount = 5;


@implementation PMOperationQueue

static PMOperationQueue *_backgroundQueue;

#pragma mark Static methods

+(void) initialize
{
    if (self == [PMOperationQueue class]) {
        _backgroundQueue = [[PMOperationQueue alloc] init];
        _backgroundQueue.maxConcurrentOperationCount = kPMBackgroundQueueConcurrentCount;
    }
}


+(PMOperationQueue *) backgroundQueue
{
    return _backgroundQueue;
}

#pragma mark - Adding operations

-(NSOperation *) addOperationWithBlock:(void (^)(void))block completionBlock:(void (^)(void))completionBlock
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    operation.completionBlock = ^{
        [[PMOperationQueue mainQueue] addOperationWithBlock:completionBlock];
    };
    
    [self addOperation:operation];
    return operation;
}

@end
