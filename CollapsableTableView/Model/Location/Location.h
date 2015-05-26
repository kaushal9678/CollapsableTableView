//
//  Location.h
//  Healthians
//
//  Created by mac on 5/22/15.
//  Copyright (c) 2015 Healthians.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property (readwrite, nonatomic, copy) NSString*city_name;
@property (readwrite, nonatomic, copy) NSArray *cities;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
