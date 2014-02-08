//
//  Tweet.h
//  TwitterClient
//
//  Created by Kushan Shah on 2/1/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *imageUrl;
@property (nonatomic, strong, readonly) NSString *userName;
@property (nonatomic, strong, readonly) NSString *timeStamp;
@property (nonatomic, strong, readonly) NSString *idNo;
@property (nonatomic, strong, readonly) NSString *userTwitterName;
@property (nonatomic, strong, readonly) NSString *favCount;
@property (nonatomic, strong, readonly) NSString *retweetCount;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
