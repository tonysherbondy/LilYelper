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
    self.resultTitleLabel.text = @"I'm kind of a long title.";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setResult:(Result *)result
{
//    self.resultTitleLabel.text = result.title;
}

+ (CGFloat)heightWithPrototype:(ResultTableViewCell *)prototype result:(Result *)result
{
    CGFloat prototypeWidth = prototype.resultTitleLabel.bounds.size.width;
    CGRect bounds = [result.title boundingRectWithSize:CGSizeMake(prototypeWidth, CGFLOAT_MAX)
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes: @{} context:nil];
    NSLog(@"protoWidth: %f, height: %f", prototypeWidth, bounds.size.height);
    return bounds.size.height;
}

@end
