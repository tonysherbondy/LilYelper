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
@property (nonatomic, strong) NSString *key;
// filter is on or off
@property (nonatomic, assign) BOOL on;
- (id)initWithText:(NSString *)text on:(BOOL)on;
- (id)initWithText:(NSString *)text key:(NSString *)key;
@end
