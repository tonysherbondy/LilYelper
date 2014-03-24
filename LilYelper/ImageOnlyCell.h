//
//  ImageOnlyCell.h
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/23/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Result.h"

@interface ImageOnlyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *onlyImageView;
@property (nonatomic, strong) Result *result;
@end
