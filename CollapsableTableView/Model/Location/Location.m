//
//  Location.m
//  Healthians
//
//  Created by mac on 5/22/15.
//  Copyright (c) 2015 Healthians.com. All rights reserved.
//

#import "Location.h"

@implementation Location
@synthesize city_name,cities;
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
  
    city_name=[attributes valueForKey:@"city_name"];
    cities=[attributes valueForKey:@"cities"];
   
    
    
    return self;
}

@end
