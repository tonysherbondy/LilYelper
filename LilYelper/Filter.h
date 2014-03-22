//
//  Filter.h
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/22/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject
@property (nonatomic, strong) NSString *text;
// options is really only used for the select filter
@property (nonatomic, strong) NSArray *options;
// on/off : 0 or 1, select : index of option
@property (nonatomic, assign) NSInteger value;
- (id)initWithText:(NSString *)text;
@end
