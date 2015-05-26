//
//  HealthiansAPI.h
//  Healthians
//
//  Created by mac on 5/22/15.
//  Copyright (c) 2015 Healthians.com. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface HealthiansAPI : AFHTTPSessionManager

+ (instancetype)sharedClient;
@end
