#import "GPUImageOutput.h"

@interface GPUImageUIElement : GPUImageOutput

// Initialization and teardown
- (instancetype)initWithView:(UIView *)inputView;
- (instancetype)initWithLayer:(CALayer *)inputLayer;

// Layer management
@property (readonly) CGSize layerSizeInPixels;
- (void)update;

@end
