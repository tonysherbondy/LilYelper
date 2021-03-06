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
@property (weak, nonatomic) IBOutlet UILabel *dropdownLabel;
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

- (void)setText:(NSString *)text
{
    self.label.text = text;
}

- (void)hideDropdownLabel
{
    self.dropdownLabel.alpha = 0;
}

- (void)flipDropdownLabel
{
    self.dropdownLabel.text = @"︿";
}

@end
