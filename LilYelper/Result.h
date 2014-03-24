//
//  Result.h
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/20/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *ratingURL;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) float rating;

- (id) initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)resultsFromArray:(NSArray *)array;
@end
