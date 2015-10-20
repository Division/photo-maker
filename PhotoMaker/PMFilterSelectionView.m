//
//  PMFilterSelectionView.m
//  PhotoMaker
//
//  Created by Nikita on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMFilterSelectionView.h"
#import "PMFilterSelectionViewCell.h"
#import "PMImageUtils.h"
#import "PMConst.h"

static const CGSize kPMFilterSelectionViewCellSize = {65, 66};
static const int kPMFilterSelectionViewCellSpacing = 1;

@implementation PMFilterSelectionView

@synthesize selectedIndex = _selectedIndex;
@synthesize filterSelectionDelegate = _filterSelectionDelegate;

#pragma mark - Properties

-(void) setSelectedIndex:(int)newSelectedIndex
{
	if (_selectedIndex >= 0) {
		PMFilterSelectionViewCell *cell = (PMFilterSelectionViewCell *)[self cellFotItemAtIndex:_selectedIndex];
		cell.selected = NO;
	}
	
	if (newSelectedIndex >= 0) {
		PMFilterSelectionViewCell *cell = (PMFilterSelectionViewCell *)[self cellFotItemAtIndex:newSelectedIndex];
		cell.selected = YES;		
	}
	
	_selectedIndex = newSelectedIndex;
}

#pragma mark - init/dealloc

-(void) awakeFromNib
{
	[super awakeFromNib];
	self.itemSpacing = kPMFilterSelectionViewCellSpacing;
	self.layoutType = PMGridViewLayoutTypeHorizontal;
	self.showScrollIndicators = NO;
	self.dataSource = self;
	self.delegate = self;
	[self reloadData];
}

#pragma mark - Grid View Data Source

-(PMCellView *) gridView:(PMGridView *)gridView cellForItemAtIndex:(NSInteger)cellIndex
{
	PMFilterSelectionViewCell *cell = (PMFilterSelectionViewCell *)[gridView dequeueReusableCell];
	if (!cell) {
		cell = [PMFilterSelectionViewCell loadFromNib];
	}
	
	BOOL cellIsSelected = cellIndex == self.selectedIndex;
	cell.selected = cellIsSelected;
	UIImage *filterImage = [PMImageFilter imageForFilterType:cellIndex];
	cell.contentImage = filterImage;
	
	return cell;
}


-(CGSize) sizeForCellsInGridView:(PMGridView *)gridView
{
	return kPMFilterSelectionViewCellSize;
}


-(NSInteger) numberOfItemsInGridView:(PMGridView *)gridView
{
	return [PMImageFilter filterCount];
}

#pragma mark - Grid View Delegate

-(void) gridView:(PMGridView *)gridView didTapOnItemAtIndex:(NSInteger)index
{
	self.selectedIndex = index;
	[self.filterSelectionDelegate filterDidSelect:index];
}

@end
