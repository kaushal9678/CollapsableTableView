//
//  Post.h
//  Healthians
//
//  Created by mac on 5/22/15.
//  Copyright (c) 2015 Healthians.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Post : NSObject

@property (nonatomic, strong) Location *location;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;
+(NSURLSessionTask*)globalTimeLinePost:(NSMutableDictionary *)dict relativeURl:(NSString*)relativeURL  withBlock:(void(^)(NSMutableArray *posts,NSError* error))block;
+(NSURLSessionTask*)globalTimeLinePostGetMethod:(NSMutableDictionary *)dict relativeURl:(NSString*)relativeURL  withBlock:(void(^)(NSMutableArray *posts,NSError* error))block;
@end
