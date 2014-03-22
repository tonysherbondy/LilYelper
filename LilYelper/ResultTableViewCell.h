//
//  ResultTableViewCell.h
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/20/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Result.h"

@interface ResultTableViewCell : UITableViewCell
@property (nonatomic, strong) Result *result;
+ (CGFloat)heightWithResult:(Result *)result;
//+ (CGFloat)heightWithPrototype:(ResultTableViewCell *)prototype result:(Result *)result;
@end
