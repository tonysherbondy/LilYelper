//
//  Filter.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/22/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "Filter.h"

@implementation Filter
- (id)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        self.text = text;
    }
    return self;
}
@end
