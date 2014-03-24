//
//  ImageOnlyCell.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/23/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "ImageOnlyCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ImageOnlyCell ()
@end

@implementation ImageOnlyCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setResult:(Result *)result
{
    [self.onlyImageView setImageWithURL:[NSURL URLWithString:result.imageURL]];
    
    CALayer *layer = [self.onlyImageView layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = 10.0;
}

@end
