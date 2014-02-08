//
//  TwitterAPIClient.m
//  TwitterClient
//
//  Created by Kushan Shah on 1/30/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import "TwitterAPIClient.h"
#import "AFNetworking.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"autBLlbqxauaw0O2ITWlGw"
#define TWITTER_CONSUMER_SECRET @"TNKXK91g9nnvDgafHgFTA269A2Q6HzkeeNzNgL737g"

static NSString * const kAccessTokenKey = @"kAccessTokenKey";

@implementation TwitterAPIClient

+ (TwitterAPIClient *)instance {
    static dispatch_once_t once;
    static TwitterAPIClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[TwitterAPIClient alloc] initWithBaseURL:TWITTER_BASE_URL key:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    });
    
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url key:(NSString *)key secret:(NSString *)secret {
    self = [super initWithBaseURL:TWITTER_BASE_URL key:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kAccessTokenKey];
        if (data) {
            self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return self;
}

#pragma mark - Users API

- (void)authorizeWithCallbackUrl:(NSURL *)callbackUrl success:(void (^)(AFOAuth1Token *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure {
    self.accessToken = nil;
    [super authorizeUsingOAuthWithRequestTokenPath:@"oauth/request_token" userAuthorizationPath:@"oauth/authorize" callbackURL:callbackUrl accessTokenPath:@"oauth/access_token" accessMethod:@"POST" scope:nil success:success failure:failure];
}

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getPath:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

#pragma mark - Statuses API

- (void)homeTimelineWithCount:(int)count sinceId:(int)sinceId maxId:(int)maxId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"count": @(count)}];
    if (sinceId > 0) {
        [params setObject:@(sinceId) forKey:@"since_id"];
    }
    if (maxId > 0) {
        [params setObject:@(maxId) forKey:@"max_id"];
    }
    [self getPath:@"1.1/statuses/home_timeline.json" parameters:params success:success failure:failure];
}

-(void)retweetWithStringId:(NSString*)idString success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *postString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json" ,idString];
    
    [self postPath:postString parameters:nil success:success failure:failure];
}

- (void)favoriteWithStringId:(NSString*)idString  success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": idString}];
    
    [self postPath:@"1.1/favorites/create.json" parameters:params success:success failure:failure];
}

#pragma mark - Private methods

- (void)setAccessToken:(AFOAuth1Token *)accessToken {
    [super setAccessToken:accessToken];
    
    if (accessToken) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAccessTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tweetWithUserText:(NSString*)tweetText idString:(NSString*) idString success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"status": tweetText}];
    if(idString != nil){
        NSLog (@"Set to %@",idString);
        [params setObject:idString forKey:@"in_reply_to_status_id"];
    }
    [self postPath:@"1.1/statuses/update.json" parameters:params success:success failure:failure];
}

@end
