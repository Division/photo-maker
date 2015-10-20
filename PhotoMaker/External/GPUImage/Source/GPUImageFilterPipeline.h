#import <Foundation/Foundation.h>
#import "GPUImageFilter.h"

@interface GPUImageFilterPipeline : NSObject

@property (strong) NSMutableArray *filters;

@property (strong) GPUImageOutput *input;
@property (strong) id <GPUImageInput> output;

- (instancetype) initWithOrderedFilters:(NSArray*) filters input:(GPUImageOutput*)input output:(id <GPUImageInput>)output;
- (instancetype) initWithConfiguration:(NSDictionary*) configuration input:(GPUImageOutput*)input output:(id <GPUImageInput>)output;
- (instancetype) initWithConfigurationFile:(NSURL*) configuration input:(GPUImageOutput*)input output:(id <GPUImageInput>)output;

- (void) addFilter:(GPUImageFilter*)filter;
- (void) addFilter:(GPUImageFilter*)filter atIndex:(NSUInteger)insertIndex;
- (void) replaceFilterAtIndex:(NSUInteger)index withFilter:(GPUImageFilter*)filter;
- (void) replaceAllFilters:(NSArray*) newFilters;
- (void) removeFilterAtIndex:(NSUInteger)index;
- (void) removeAllFilters;

@property (readonly, strong) UIImage *currentFilteredFrame;
@property (readonly) CGImageRef newCGImageFromCurrentFilteredFrame CF_RETURNS_RETAINED;

@end
