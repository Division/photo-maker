//
//  PMFontDefinition.h
//  PhotoMaker
//
//  Created by Nikita on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMFontDefinition : NSObject

+(UIFont *) fontWithIndex:(int)index forSize:(float)size;


@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, readonly) float scale;

@end
