//
//  ComposeTweetViewController.h
//  TwitterClient
//
//  Created by Kushan Shah on 2/7/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *composeText;
@property (weak, nonatomic) NSString *replyToID;
@property (weak, nonatomic) NSString *replyToUser;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end
