//
//  PMOperationQueue.h
//  PhotoMaker
//
//  Created by NSidorenko on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMOperationQueue : NSOperationQueue

/**
 * Default queue to execute async operations
 */
+(PMOperationQueue *) backgroundQueue;

/**
 * Adds operation to execute. completionBlock is executed on the main thread.
 */
-(NSOperation *) addOperationWithBlock:(void (^)(void))block completionBlock:(void (^)(void))completionBlock;

@end
