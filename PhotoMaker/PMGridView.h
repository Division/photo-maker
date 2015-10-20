//
//  PMGridView.h
//  PhotoMaker
//
//  Created by Nikita on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMView.h"

@class PMGridView, PMCellView;

typedef enum
{
	PMGridViewLayoutTypeVertical,
	PMGridViewLayoutTypeHorizontal
	
} PMGridViewLayoutType;


@protocol PMGridViewDataSource <NSObject>

-(PMCellView *) gridView:(PMGridView *)gridView cellForItemAtIndex:(NSInteger)cellIndex;
-(CGSize) sizeForCellsInGridView:(PMGridView *)gridView;
-(NSInteger) numberOfItemsInGridView:(PMGridView *)gridView;

@end


@protocol PMGridViewDelegate <NSObject>

-(void) gridView:(PMGridView *)gridView didTapOnItemAtIndex:(NSInteger)index;

@end

/**
 * View for displaying grids, horisontal scrolls etc
 * It is working as a wrapper of the external GMGridView component
 */
@interface PMGridView : PMView 

// Must be called only from gridView:cellForItemAtIndex: method
@property (readonly, strong) PMCellView *dequeueReusableCell;

// May return nil
-(PMCellView *) cellFotItemAtIndex:(NSInteger)index;

-(void) reloadData;

@property (nonatomic, assign) PMGridViewLayoutType layoutType;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) int itemSpacing;
@property (nonatomic, assign) BOOL showScrollIndicators;

@property (nonatomic, unsafe_unretained) id<PMGridViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id<PMGridViewDelegate> delegate;

@end
