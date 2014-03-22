//
//  SelectCell.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/22/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "SelectCell.h"

@interface SelectCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation SelectCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFilter:(Filter *)filter
{
    self.label.text = filter.options[filter.value];
}

@end
