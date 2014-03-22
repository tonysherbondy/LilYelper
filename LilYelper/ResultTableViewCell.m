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

-(void)setResultText:(NSString *)resultText
{
    self.resultTitleLabel.text = resultText;
}

//+ (CGFloat)heightWithPrototype:(ResultTableViewCell *)prototype result:(Result *)result
//{
//    CGFloat prototypeWidth = prototype.resultTitleLabel.bounds.size.width;
//    CGRect bounds = [result.title boundingRectWithSize:CGSizeMake(prototypeWidth, CGFLOAT_MAX)
//                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                            attributes: @{} context:nil];
//    NSLog(@"protoWidth: %f, height: %f", prototypeWidth, bounds.size.height);
//    return bounds.size.height;
//}

@end
