//
//  SelectCell.h
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/22/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCell.h"

@interface SelectCell : UITableViewCell
@property (nonatomic, strong) NSString *text;
- (void)hideDropdownLabel;
@end
