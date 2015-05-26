//
//  Cities.m
//  Healthians
//
//  Created by mac on 5/22/15.
//  Copyright (c) 2015 Healthians.com. All rights reserved.
//

#import "Cities.h"

@implementation Cities
@synthesize city_name,city_id;
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
   
    city_name=[attributes valueForKey:@"city_name"];
    city_id= [attributes valueForKey:@"city_id"];
    
    
    
    return self;
}
@end
