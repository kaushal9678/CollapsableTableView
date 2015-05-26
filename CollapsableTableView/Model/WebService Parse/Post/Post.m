//
//  Post.m
//  Healthians
//
//  Created by mac on 5/22/15.
//  Copyright (c) 2015 Healthians.com. All rights reserved.
//

#import "Post.h"
#import "SVProgressHUD.h"
#import "HealthiansAPI.h"

static NSMutableDictionary *dictParam;
@implementation Post
@synthesize location;
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    if ([[dictParam valueForKey:@"webserviceType"]isEqualToString:@"location"]) {
        location=[[Location alloc]initWithAttributes:attributes];
    }
    
    return self;
}
#pragma mark -

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    
    [SVProgressHUD showSuccessWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
    return [[HealthiansAPI sharedClient]POST:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            NSMutableArray *arraySubCities=[attributes valueForKey:@"cities"];
            Post *post = [[Post alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }
        [SVProgressHUD dismiss];
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        if (block) {
            block([NSArray array], error);
        }
    }];
    
    
}

+(NSURLSessionTask *)globalTimeLinePost:(NSMutableDictionary *)dict relativeURl:(NSString *)relativeURL withBlock:(void (^)(NSMutableArray *, NSError *))block{
    dictParam=[NSMutableDictionary dictionaryWithDictionary:dict];
    
    
   return [[HealthiansAPI sharedClient]POST:relativeURL parameters:dict success:^(NSURLSessionDataTask *__unused task, id JSON) {
       NSMutableArray *postsFromResponse=[[NSMutableArray alloc]init];
     //  NSMutableArray *postsFromResponse = [JSON objectAtIndex:0];
       for (id value in JSON) {
           [postsFromResponse addObject:value];
      }
     
       NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
      
       for (NSDictionary *attributes in postsFromResponse) {
           //NSMutableArray *arraySubCities=[attributes valueForKey:@"cities"];
          // Post *post = [[Post alloc] initWithAttributes:attributes];
           [mutablePosts addObject:attributes];
       }
       if (block) {
           block([NSMutableArray arrayWithArray:mutablePosts], nil);
       }
       

   } failure:^(NSURLSessionDataTask *task, NSError *error) {
       if (block) {
           block([NSMutableArray array], error);
       }
   }];
    
    
   
}

+(NSURLSessionTask *)globalTimeLineGetMethod:(NSMutableDictionary *)dict relativeURl:(NSString *)relativeURL withBlock:(void (^)(NSMutableArray *, NSError *))block{
    dictParam=[NSMutableDictionary dictionaryWithDictionary:dict];
    
    
    return [[HealthiansAPI sharedClient]GET:relativeURL parameters:dict success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSMutableArray *postsFromResponse = [JSON valueForKeyPath:@"result"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        // NSString *flag=[JSON valueForKeyPath:@"flag"];
        //[postsFromResponse addObject:flag];
        for (NSDictionary *attributes in postsFromResponse) {
           NSMutableArray *arraySubCities=[attributes valueForKey:@"cities"];
            Post *post = [[Post alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }
        
        
        if (block) {
            block([NSMutableArray arrayWithArray:mutablePosts], nil);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSMutableArray array], error);
        }
    }];
}

@end
