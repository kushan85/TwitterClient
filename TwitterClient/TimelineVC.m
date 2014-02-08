//
//  TimelineVC.m
//  TwitterClient
//
//  Created by Kushan Shah on 2/1/14.
//  Copyright (c) 2014 Kushan Shah. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "TweetViewController.h"
#import "ComposeTweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onSignOutButton;
- (void)reload;

@end

@implementation TimelineVC
BOOL isInitialLoading;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Home";
        isInitialLoading = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TweetCell"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(111.0/255.0) green:(183.0/255.0) blue:(231.0/255.0) alpha:1.0]];
 //   [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target: self action: @selector(onCompose)];
    
    UINib *customNibTweetView = [UINib nibWithNibName:@"TweetViewController" bundle:nil];
    [self.tableView registerNib:customNibTweetView forCellReuseIdentifier:@"TweetViewController"];
    
    UINib *customNibComposeView = [UINib nibWithNibName:@"ComposeTweetViewController" bundle:nil];
    [self.tableView registerNib:customNibComposeView forCellReuseIdentifier:@"ComposeTweetViewController"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self reload];
}

- (void)stopRefresh {
    [self.refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    if(isInitialLoading != TRUE) {
        [super viewWillAppear:animated];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [self reload];
        });
    }
    isInitialLoading = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tweetCellIndentifier = @"TweetCell";
    
    TweetCell *cell = (TweetCell *)[tableView dequeueReusableCellWithIdentifier:tweetCellIndentifier];
    if (cell == nil || (![cell isKindOfClass:TweetCell.class]))
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Tweet *tweet = self.tweets[indexPath.row];
    //cell.textLabel.text = tweet.text;
    
    //Setting the tweet label
    cell.tweetLabel.numberOfLines = 0;
    cell.tweetLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.tweetLabel.text = tweet.text;
    
    
    //Setting the profile image
    [self performSelectorInBackground:@selector(requestProfileImageURL:) withObject:indexPath];
    
    //Setting the user name
    cell.userName.text = tweet.userName;
    [cell.userName sizeToFit];
    
    //Setting the timestamp
    
    NSString* dateString = [self dateDiff:tweet.timeStamp];
    
    cell.timeStamp.text = dateString;
    
    //Setting the user screen name
    
    cell.userScreenName.text =   [NSString stringWithFormat:@"@%@",tweet.userTwitterName];
    
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150.0;
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewController *tvc = [[TweetViewController alloc]initWithNibName:@"TweetViewController" bundle:Nil];
    
    tvc.tweetObject = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tvc animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

-(void)onCompose {
    NSLog(@"Compose called");
    ComposeTweetViewController *composeTweet = [[ComposeTweetViewController alloc]initWithNibName:@"ComposeTweetViewController"bundle:Nil];
    
    
    composeTweet.replyToID = nil;
    composeTweet.replyToUser = nil;
    [self.navigationController pushViewController:composeTweet animated:YES];
    
}

- (void)reload {
    [[TwitterAPIClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
}

#pragma mark - Image URL methods
-(void) requestProfileImageURL: (NSIndexPath *) indexPath{
    
    //NSLog (@"In request profile method");
    
    Tweet *currTweet = [self.tweets objectAtIndex:indexPath.row];
    NSURL *imageURL =  [NSURL URLWithString:currTweet.imageUrl];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:indexPath,image,nil] forKeys:[NSArray arrayWithObjects:@"indexPath",@"image", nil]];
    
    [self performSelectorOnMainThread:@selector(putProfileImage:) withObject:params waitUntilDone:NO];
    
}

-(void) putProfileImage:(NSDictionary * )params {
    NSIndexPath *indexPath = [params valueForKeyPath:@"indexPath"];
    UIImage *image = [params valueForKeyPath:@"image"];
    UITableViewCell *fromcell =  [self.tableView cellForRowAtIndexPath:indexPath];
    TweetCell *cell = (TweetCell *) fromcell;
    cell.userImage.layer.cornerRadius = 12;
    cell.userImage.layer.masksToBounds = YES;
    [cell.userImage setImage:image];
}


// stack overflow

-(NSString *)dateDiff:(NSString *)origDate {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz yyyy"];
    
    NSDate *tweetdate = [dateFormat dateFromString:origDate];
    
    
    NSDate *todayDate = [NSDate date];
    double ti = [tweetdate timeIntervalSinceDate:todayDate];
    
    ti = ti * -1;
    if(ti < 1) {
    	return @"--";
    } else 	if (ti < 60) {
    	return @"1min";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%dmin", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return[NSString stringWithFormat:@"%dh", diff];
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%dd", diff];
    } else {
    	return @"+1 ago";
    }
}

@end
