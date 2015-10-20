//
//  PMImageFilter.h
//  PhotoMaker
//
//  Created by Nikita on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

typedef enum
{
	PMFilterTypeNone = 0,
	PMFilterTypeAmatorika,
	PMFilterTypeSoftElegance,
	PMFilterTypeMissEtikate,
	PMFilterTypeHaze,
	PMFilterTypeToneCurve,
	PMFilterTypeSepia,
	PMFilterTypeMonochrome,
	PMFilterTypeGrayscale,
	PMFilterTypeBlur // This filter is not show in the filter list

} PMFilterType;


@interface PMImageFilter : NSObject

// Includes none filter
+(NSInteger) filterCount;

+(UIImage *) imageForFilterType:(PMFilterType)filterType;

+(GPUImageCropFilter *) cameraCropFilter;


+(GPUImageFilter *) configureCameraForCapture:(GPUImageStillCamera *)camera 
										input:(id<GPUImageInput>)input 
								   filterType:(PMFilterType)filterType 
								  blurEnabled:(BOOL)blurEnabled ;

/**
 Returns last filter in the chain
 */
+(GPUImageOutput *) configureFilterWithOutput:(GPUImageOutput *)output 
										input:(id<GPUImageInput>)input 
								   filterType:(PMFilterType)filterType 
								  blurEnabled:(BOOL)blurEnabled 
								   cropCamera:(BOOL)cropCamera;

/**
 Returns last filter in the chain
 */

+(GPUImageOutput *) configureFilterWithOutput:(GPUImageOutput *)output 
										input:(id<GPUImageInput>)input 
								   filterType:(PMFilterType)filterType 
								  blurEnabled:(BOOL)blurEnabled 
								   cropCamera:(BOOL)cropCamera
						 addPlaceholderFilter:(BOOL)addPlaceholder;


+(UIImage *) filteredImage:(UIImage *)image withFilterType:(PMFilterType)filterType;

+(void) assertFilterTypeIsCorrect:(PMFilterType)filterType;

@end
