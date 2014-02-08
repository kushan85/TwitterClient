//
//  RestObject.h
//  TwitterClient
//
//  Created by Kushan Shah on 2/1/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestObject : NSObject

- (id)initWithDictionary:(NSDictionary *)data;

@property (nonatomic, strong) NSDictionary *data;

@end

@interface RestObject (ForwardedMethods)

- (id)objectForKey:(id)key;
- (id)valueOrNilForKeyPath:(NSString *)keyPath;

@end
