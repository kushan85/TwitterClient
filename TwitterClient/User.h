//
//  User.h
//  TwitterClient
//
//  Created by Kushan Shah on 2/1/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : RestObject

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

@end
