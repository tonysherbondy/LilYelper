//
//  SwitchFilterCell.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/22/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "SwitchFilterCell.h"

@interface SwitchFilterCell ()
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation SwitchFilterCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setFilter:(Filter *)filter
//{
//    self.label.text = filter.text;
//    self.switchView.on = filter.value;
//}

- (void)setOn:(BOOL)on
{
    self.switchView.on = on;
}

- (void)setText:(NSString *)text
{
    self.label.text = text;
}

@end
