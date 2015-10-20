//
//  PMStartupPhotosDataProvider.h
//  PhotoMaker
//
//  Created by NSidorenko on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMStartupPhotosDataProviderDelegate <NSObject>

// Called when images loaded and ready to display. 
// cameraRollFailed set to YES if user denied location access.
// In this case predefined example images are shown
-(void) imageDataDidUpdate:(BOOL)cameraRollFailed;

// Called when assets changed and need to be reloaded
-(void) assetsChanged;

@end

/**
 * Used to get camera roll photos.
 * If have no access to the camera roll - predefined images are loaded
 */
@interface PMStartupPhotosDataProvider : NSObject

-(void) loadCameraRoll;

@property (readonly) NSInteger countOfImages;
-(UIImage *) thumbnailAtIndex:(NSInteger)imageIndex;
-(UIImage *) imageAtIndex:(NSInteger)imageIndex;

@property (nonatomic, unsafe_unretained) id<PMStartupPhotosDataProviderDelegate>delegate;
@property (nonatomic, readonly) BOOL dataLoaded;
@property (nonatomic, readonly) BOOL usingCameraRoll;

@end
