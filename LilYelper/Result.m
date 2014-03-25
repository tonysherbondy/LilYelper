//
//  Result.m
//  LilYelper
//
//  Created by Anthony Sherbondy on 3/20/14.
//  Copyright (c) 2014 Anthony Sherbondy. All rights reserved.
//

#import "Result.h"

@implementation Result
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        self.title = dictionary[@"name"];
        self.imageURL = dictionary[@"image_url"];
        self.ratingURL = dictionary[@"rating_img_url"];
        self.categories = dictionary[@"categories"];
        self.rating = [dictionary[@"rating"] floatValue];
        // This is just the street address
        self.address = dictionary[@"location.address"][0];
    }
    
    return self;
}

+(NSArray *)resultsFromArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        Result *result = [[Result alloc] initWithDictionary:dictionary];
        [results addObject:result];
    }
    return results;
}
@end
