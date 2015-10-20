//
//  PMStartupPhotosDataProvider.m
//  PhotoMaker
//
//  Created by NSidorenko on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMStartupPhotosDataProvider.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PMCellView.h"
#import "PMOperationQueue.h"
#import "PMImageUtils.h"

static NSString *const kPMPredefinedThumbnailFormat = @"leaf_%02d_thumb.jpg";
static NSString *const kPMPredefinedImageFormat = @"leaf_%02d.jpg";
static const int kPMPredefinedImagesCount = 10;
static const int kPMNumberImagesInGallery = 40;

@interface PMStartupPhotosDataProvider()

@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSArray *exampleThumbnails;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, assign) BOOL usingCameraRoll;
@property (nonatomic, assign) BOOL dataLoaded;

@end

@implementation PMStartupPhotosDataProvider

#pragma mark - init/dealloc

-(instancetype) init
{
    if (self = [super init]) {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(assetsLibraryChanged) 
													 name: ALAssetsLibraryChangedNotification 
												   object:self.assetsLibrary];
        self.usingCameraRoll = YES;
        self.dataLoaded = NO;
    }
    return self;
}


-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Photos data provider

-(NSInteger) countOfImages
{
    NSInteger result;
    
    if (self.usingCameraRoll) {
        result = self.assets.count;
    } else {
        result = self.exampleThumbnails.count;
    }
    
    return result;
}


-(UIImage *) thumbnailAtIndex:(NSInteger)imageIndex
{
    UIImage *image;
    
    if (self.usingCameraRoll) {
        ALAsset *asset = (self.assets)[imageIndex];
        CGImageRef thumbnailImageRef = [asset thumbnail];
		image = [[UIImage alloc] initWithCGImage:thumbnailImageRef];
    } else {
        image = (self.exampleThumbnails)[imageIndex];
    }
    
    return image;
}


-(UIImage *) imageAtIndex:(NSInteger)imageIndex
{
    UIImage *image;
    
    if (self.usingCameraRoll) {
        ALAsset *asset = (self.assets)[imageIndex];
		ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef thumbnailImageRef = [representation fullResolutionImage];
		image = [UIImage imageWithCGImage:thumbnailImageRef scale:representation.scale orientation:representation.orientation];
    } else {
        image = [self predefinedImageWithIndex:imageIndex];
    }
    
    return image;
}

#pragma mark - Getting camera roll

-(void) loadCameraRoll
{
	NSMutableArray *tempAssets = [NSMutableArray array];
	
    self.dataLoaded = NO;
    
    // Block to iterate through assets within group
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [tempAssets addObject:result];
        }
    };
	
	// Block to iterate through groups (we actually need only one group for Camera Roll)
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
		if (group) {
			NSNumber *type = (NSNumber *)[group valueForProperty:ALAssetsGroupPropertyType];
			// Check if group is Camera Roll
			if ([type intValue] == ALAssetsGroupSavedPhotos) {
				ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
				[group setAssetsFilter:onlyPhotosFilter];
				[group enumerateAssetsUsingBlock:assetsEnumerationBlock];
			}
		} else {
            
            if (tempAssets.count > 0) {
                // Finished, have photos in camera roll, callback on the main thread
				
				// Sort to have last photos first
				NSArray *sorted = [tempAssets sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
					NSDate *date1 = [obj1 valueForProperty:ALAssetPropertyDate];
					NSDate *date2 = [obj1 valueForProperty:ALAssetPropertyDate];
					return [date1 compare:date2];
				}];
				
				// We need limited count of last photos - getting subarray
				int needCount = MIN(kPMNumberImagesInGallery, sorted.count);
				NSArray *result = [sorted subarrayWithRange:NSMakeRange(sorted.count - needCount, needCount)];
				
				// Notify delegate on the main thread
                [[PMOperationQueue mainQueue] addOperationWithBlock:^{
                    self.assets = [NSArray arrayWithArray:result];
                    self.dataLoaded = YES;
                    self.usingCameraRoll = YES;
                    BOOL cameraRollFailed = !self.usingCameraRoll;
                    DLog(@"Camera roll loaded. Count: %d", self.assets.count);
                    [self.delegate imageDataDidUpdate:cameraRollFailed];
                }];
            } else {
                // Have no photos, load and display predefined
                [self loadPredefinesImages];
            }
		}
    };
    
	 ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
		 NSString *errorMessage = nil;

		 switch ([error code]) {
			 case ALAssetsLibraryAccessUserDeniedError:
			 case ALAssetsLibraryAccessGloballyDeniedError:
			 errorMessage = @"The user has declined access to it.";
			 break;
			 default:
			 errorMessage = @"Reason unknown.";
			 break;
		 }
		 
		 DLog(@"Error getting camera roll. Reason: %@", errorMessage);
		 
		 // In case of error we must load predefined images
		 [self loadPredefinesImages];
	 };
    
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
	
}

#pragma mark - Predefined images

-(void) loadPredefinesImages
{
    DLog(@"Loading predefined images...");
    
	NSMutableArray *images = [NSMutableArray array];
    [[PMOperationQueue backgroundQueue] addOperationWithBlock:^{
        for (int i = 0; i < kPMPredefinedImagesCount; i++) {
			[images addObject:[self predefinedThumbnailWithIndex:i]];
		}
    } completionBlock:^{
        self.dataLoaded = YES;
        self.usingCameraRoll = NO;
		self.exampleThumbnails = [NSArray arrayWithArray:images];
        BOOL cameraRollFailed = !self.usingCameraRoll;
        [self.delegate imageDataDidUpdate:cameraRollFailed];
    }];
}


-(UIImage *) predefinedThumbnailWithIndex:(int)index
{
	NSString *imageName = [NSString stringWithFormat:kPMPredefinedThumbnailFormat, index + 1];
	return [PMImageUtils imageNamed:imageName];
}


-(UIImage *) predefinedImageWithIndex:(int)index
{
	NSString *imageName = [NSString stringWithFormat:kPMPredefinedImageFormat, index + 1];
	return [PMImageUtils imageNamed:imageName];	
}

#pragma mark - Asset Library Notifications

-(void) assetsLibraryChanged
{
	if (self.dataLoaded && self.usingCameraRoll) {
		[self.delegate assetsChanged];
		self.dataLoaded = NO;
		self.assets = nil;
		[self loadCameraRoll];
	}
	
}

@end
