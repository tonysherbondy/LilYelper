//
//  FiltersViewController.h
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/22/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltersDelegate.h"

@interface FiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, weak) id <FiltersDelegate> delegate;
@end
