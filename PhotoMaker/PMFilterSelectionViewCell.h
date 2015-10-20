//
//  PMFilterSelectionViewCell.h
//  PhotoMaker
//
//  Created by Nikita on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PMCellView.h"

@interface PMFilterSelectionViewCell : PMCellView

@property (nonatomic, strong) IBOutlet UIImageView *outlineImageView;
@property (nonatomic, strong) IBOutlet UIImageView *contentImageView;

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIImage *contentImage;

@end
