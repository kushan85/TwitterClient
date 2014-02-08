//
//  TwitterAPIClient.h
//  TwitterClient
//
//  Created by Kushan Shah on 1/30/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import "AFOAuth1Client.h"

@interface TwitterAPIClient : AFOAuth1Client

+ (TwitterAPIClient *)instance;

// Users API

- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl success:(void (^)(AFOAuth1Token *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure;

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// Statuses API

- (void)homeTimelineWithCount:(int)count sinceId:(int)sinceId maxId:(int)maxId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)retweetWithStringId:(NSString*)idString  success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)favoriteWithStringId:(NSString*)idString  success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)tweetWithUserText:(NSString*)tweetText idString:(NSString*) idString success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
