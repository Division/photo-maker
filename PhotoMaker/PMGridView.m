//
//  PMGridView.m
//  PhotoMaker
//
//  Created by Nikita on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMGridView.h"
#import "GMGridView.h"
#import "PMCellView.h"
#import "GMGridViewLayoutStrategies.h"

const int kPMGridViewInitialSpacing = 10;
const UIEdgeInsets kPMGridViewInitialContentInsets = {0, 0, 0, 0};

@interface PMGridView() <GMGridViewDataSource, GMGridViewActionDelegate> 

@property (nonatomic, strong) GMGridView *gmGridView;
@property (nonatomic, strong) PMCellView *currentReusableCell;

@end


@implementation PMGridView

@synthesize gmGridView = _gmGridView;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize currentReusableCell = _currentReusableCell;
@synthesize layoutType = _layoutType;
@synthesize showScrollIndicators = _showScrollIndicators;
@dynamic contentInsets;
@dynamic itemSpacing;

#pragma mark - Properties

-(void) setLayoutType:(PMGridViewLayoutType)layoutType
{
	_layoutType = layoutType;
	switch (layoutType) {
		case PMGridViewLayoutTypeVertical:
			self.gmGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
			break;
			
		case PMGridViewLayoutTypeHorizontal:
			self.gmGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
			break;
			
		default:
			DLog(@"Incorrect layout type: %d", layoutType);
			break;
	}
}


-(void) setContentInsets:(UIEdgeInsets)contentInsets
{
	self.gmGridView.contentInset = contentInsets;
}


-(UIEdgeInsets) contentInsets
{
	return self.gmGridView.contentInset;
}


-(void) setItemSpacing:(int)itemSpacing
{
	self.gmGridView.itemSpacing = itemSpacing;
	[self.gmGridView setNeedsLayout];
}


-(int) itemSpacing
{
	return self.gmGridView.itemSpacing;
}


-(void) setShowScrollIndicators:(BOOL)showScrollIndicators
{
	_showScrollIndicators = showScrollIndicators;
	self.gmGridView.showsHorizontalScrollIndicator = showScrollIndicators;
	self.gmGridView.showsVerticalScrollIndicator = showScrollIndicators;
}

#pragma mark - init/dealloc

-(void) commonInit
{
	[super commonInit];
	// Creating GMGridView instance used to display all grid stuff
	self.gmGridView = [[GMGridView alloc] initWithFrame:self.bounds];
	self.gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.gmGridView.centerGrid = YES;
	self.gmGridView.itemSpacing = kPMGridViewInitialSpacing;
	self.gmGridView.dataSource = self;
	self.gmGridView.actionDelegate = self;
	[self addSubview:self.gmGridView];
	self.backgroundColor = [UIColor clearColor];
	self.layoutType = PMGridViewLayoutTypeVertical;
	
	self.gmGridView.contentInset = kPMGridViewInitialContentInsets;
}




#pragma mark - internal work

-(PMCellView *) dequeueReusableCell
{
	PMCellView *result = self.currentReusableCell;
	self.currentReusableCell = nil;
	return result;
}


-(PMCellView *) cellFotItemAtIndex:(NSInteger)index
{
	PMCellView *result = nil;
	
	GMGridViewCell *cell = [self.gmGridView cellForItemAtIndex:index];
	if (cell) {
		result = (PMCellView*)cell.contentView;
	}
	
	return result;
}


-(void) reloadData
{
	[self.gmGridView reloadData];
	[self.gmGridView setNeedsLayout];
	[self.gmGridView setNeedsDisplay];
}

#pragma mark - GM Grid View Data Source

-(NSInteger) numberOfItemsInGMGridView:(GMGridView *)gridView
{
	return [self.dataSource numberOfItemsInGridView:self];
}


-(CGSize) GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	return [self.dataSource sizeForCellsInGridView:self];
}


-(GMGridViewCell *) GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
	GMGridViewCell *cell = [gridView dequeueReusableCell];
	if (cell) {
		// If we have reusable GMGridViewCell - we should save it's contentView
		// to make dataSource being able to ask us for reusable cell
		self.currentReusableCell = (PMCellView*)cell.contentView;
	} else {
		cell = [[GMGridViewCell alloc] init];
	}
	PMCellView *pmCellView = [self.dataSource gridView:self cellForItemAtIndex:index];
	// Making cell resizing correctly
	pmCellView.frame = cell.bounds;
	pmCellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	cell.contentView = pmCellView;
	self.currentReusableCell = nil;
	
	return cell;
}

#pragma mark - GM Grid View Action Delegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
	[self.delegate gridView:self didTapOnItemAtIndex:position];
}

@end
