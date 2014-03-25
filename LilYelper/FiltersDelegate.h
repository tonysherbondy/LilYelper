//
//  FiltersDelegate.h
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/23/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FiltersDelegate <NSObject>
- (void)hideFilters;
@property (nonatomic) BOOL isFiltersChanged;
@property (nonatomic, strong) NSDictionary *filters;
@end
