//
//  TweetCell.h
//  TwitterClient
//
//  Created by Kushan Shah on 2/1/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;

@end
