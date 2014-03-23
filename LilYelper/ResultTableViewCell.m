//
//  ResultTableViewCell.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/20/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "ResultTableViewCell.h"

@interface ResultTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *resultTitleLabel;
@end

@implementation ResultTableViewCell

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
    self.resultTitleLabel.text = result.title;
}

+ (CGFloat)heightWithResult:(Result *)result
{
    NSString *text = result.title;
    UIFont *fontText = [UIFont systemFontOfSize:17.0];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontText}
                                     context:nil];
    
    // Offset for the UI elements below the title text label
    CGFloat heightOffset = 50;
    return rect.size.height + heightOffset;
}

@end
