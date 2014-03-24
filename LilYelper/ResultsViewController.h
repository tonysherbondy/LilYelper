//
//  ResultsViewController.h
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/20/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltersDelegate.h"

@interface ResultsViewController : UIViewController <FiltersDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@end
