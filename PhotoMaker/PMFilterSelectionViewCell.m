//
//  PMFilterSelectionViewCell.m
//  PhotoMaker
//
//  Created by Nikita on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMFilterSelectionViewCell.h"
#import "PMConst.h"
#import "PMImageUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation PMFilterSelectionViewCell

#pragma mark - Properties

-(void) setSelected:(BOOL)selected
{
	_selected = selected;
	UIImage *currentImage;
	
	if (selected) {
		currentImage = [PMImageUtils imageNamed:kPMImageFilterSelectionCellActive];
	} else {
		currentImage = [PMImageUtils imageNamed:kPMImageFilterSelectionCell];
	}
	
	self.outlineImageView.image = currentImage;
}


-(UIImage *) contentImage
{
	return self.contentImageView.image;
}


-(void) setContentImage:(UIImage *)contentImage
{
	self.contentImageView.image = contentImage;
}

#pragma mark - View lifecycle

-(void) awakeFromNib
{
	self.selected = NO;
	self.contentImageView.layer.masksToBounds = YES;
	self.contentImageView.layer.cornerRadius = 6;
}

#pragma mark - init/dealloc


@end
