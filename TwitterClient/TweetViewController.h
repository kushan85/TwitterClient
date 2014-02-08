//
//  TweetViewController.h
//  TwitterClient
//
//  Created by Kushan Shah on 2/7/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetViewController : UIViewController

@property (weak,nonatomic) Tweet *tweetObject;
@property (weak, nonatomic) IBOutlet UILabel *tweetViewtext;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
- (IBAction)onRetweet:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
- (IBAction)onFavorite:(id)sender;
- (IBAction)onReply:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;

@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;

@property (weak, nonatomic) IBOutlet UILabel *favLabel;

@end
