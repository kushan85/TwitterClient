//
//  Tweet.m
//  TwitterClient
//
//  Created by Kushan Shah on 2/1/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)idNo {
    return [self.data valueForKeyPath:@"id"];
}

-(NSString *)imageUrl{
    
    User *tempUser =  [self.data valueForKeyPath:@"user"];
    return [tempUser objectForKey:@"profile_image_url_https"];
    
}
-(NSString*) userName{
    User *tempUser =  [self.data valueForKeyPath:@"user"];
    return [tempUser objectForKey:@"name"];
    
}
-(NSString*) userTwitterName{
    User *tempUser =  [self.data valueForKeyPath:@"user"];
    return [tempUser objectForKey:@"screen_name"];
    
}
-(NSString*) timeStamp{
    return [self.data valueForKeyPath:@"created_at"];
    
}

-(NSString*) favCount{
    return [self.data valueForKeyPath:@"favorite_count"];
    
}
-(NSString*) retweetCount{
    return [self.data valueForKeyPath:@"retweet_count"];
    
}


+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
    
}

@end
