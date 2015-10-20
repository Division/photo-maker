//
//  PMFilterSelectionView.h
//  PhotoMaker
//
//  Created by Nikita on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMGridView.h"
#import "PMImageFilter.h"

@protocol PMFilterSelectionViewDelegate <NSObject>

-(void) filterDidSelect:(PMFilterType)type;

@end

/**
 * Horizontal scroll view with available filters displayed
 */
@interface PMFilterSelectionView : PMGridView<PMGridViewDataSource, PMGridViewDelegate>

@property (nonatomic, weak) id<PMFilterSelectionViewDelegate> filterSelectionDelegate;
@property (nonatomic, assign) int selectedIndex;

@end
