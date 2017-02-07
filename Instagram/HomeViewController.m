//
//  HomeViewController.m
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import "HomeViewController.h"
#import "Utility.h"
#import "ImageTableViewCell.h"
#import "VideoTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRequesting = NO;
    self.firstLaunch = YES;
    self.tableView.hidden = YES;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(loadDummyData) forControlEvents:UIControlEventValueChanged];
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:@"VideoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellReuseIdentifier:@"ImageCell"];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.firstLaunch){
        self.firstLaunch = NO;
       // [self loadDummyData];
        [self callAPi:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadDummyData{
    
    NSString* filepath = [[NSBundle mainBundle]pathForResource:@"Fake" ofType:@"json"];
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filepath];
    
    NSError *jsonParsingError = nil;
    
    id receivedResponse;
    
    if (data != nil) {
        
        receivedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers error:&jsonParsingError];
        self.usersArray  = [[NSMutableArray alloc]init];
        [self GETResponseReceived:receivedResponse];
    }
    
}

-(void)callAPi:(BOOL)HUD{
    if(!self.isRequesting){
        if([Utility isInternetWorking]){
            self.usersArray  = [[NSMutableArray alloc]init];
            self.isRequesting = YES;
            ApiRequest *request = [[ApiRequest alloc]init];
            [request setDelegate:self];
            [request sendGETRequestWithURL:kloadSampleData displayHUD:HUD];
        }
        else{
            [self.refreshControl endRefreshing];
            [Utility showAlertWithTitle:@"No Internet" message:@"Please connect to some working internet" withController:self];
        }
    }
}

#pragma mark APIResponse delegate

-(void)GETResponseReceived:(id)response{
    if([response objectForKey:@"success"] && [[response objectForKey:@"success"] intValue] == 1){
        if([response objectForKey:@"data"]) {
            NSMutableArray *users = [response objectForKey:@"data"];
            for(NSDictionary *user in users){
                User *u1 = [[User alloc]init];
                u1.user_id = [user objectForKey:@"user_id"];
                u1.user_name = [user objectForKey:@"user_name"];
                u1.user_profile_pic = [user objectForKey:@"user_profile_pic"];
                u1.is_video = [[user objectForKey:@"is_video"]boolValue];
                u1.image_url = [user objectForKey:@"image_url"];
                u1.video_url = [user objectForKey:@"video_url"];
                [self.usersArray addObject:u1];
            }
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
    }
}


#pragma mark Table View delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.usersArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userSelected:)];
    [tap setNumberOfTapsRequired:1];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
    view.tag = section;
    [view setBackgroundColor:[UIColor whiteColor]];
    
    User *u =[self.usersArray objectAtIndex:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 16)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label setText:u.user_name];
    [label setTextColor:[UIColor blackColor]];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.cornerRadius = 5;
    [view addSubview:label];
    [view addSubview:imageView];
    UIImage *image = [[CacheClass sharedInstance] getCachedImageForKey:u.user_profile_pic];
    if(image)
        imageView.image = image;
    else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^(void) {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:u.user_profile_pic]];
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            if (image) {
                [[CacheClass sharedInstance] cacheImage:image forKey:u.user_profile_pic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (view.tag == section) {
                        imageView.image = image;
                        [view setNeedsLayout];
                    }
                });
            }
        });
    }
    return view;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    User *u = [self.usersArray objectAtIndex:indexPath.section];
    static NSString *CellIdentifier1 = @"ImageCell";
    static NSString *CellIdentifier2 = @"VideoCell";
    if(u.is_video && u.video_url){
        VideoTableViewCell *cell = (VideoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.tag = indexPath.row;
        cell.videoItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:u.video_url]];
        cell.videoPlayer = [AVPlayer playerWithPlayerItem:cell.videoItem];
        cell.avLayer = [AVPlayerLayer playerLayerWithPlayer:cell.videoPlayer];
        
        [cell.avLayer setBackgroundColor:[UIColor whiteColor].CGColor];
        [cell.avLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [cell.contentView.layer addSublayer:cell.avLayer];
        [cell.videoPlayer play];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if(u.image_url){
        ImageTableViewCell *cell = (ImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.tag = indexPath.row;
        UIImage *image = [[CacheClass sharedInstance] getCachedImageForKey:u.image_url];
        if(image)
            cell.imageViewShow.image = image;
        else{
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^(void) {
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:u.image_url]];
                UIImage* image = [[UIImage alloc] initWithData:imageData];
                if (image) {
                    [[CacheClass sharedInstance] cacheImage:image forKey:u.image_url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (cell.tag == indexPath.row) {
                            cell.imageViewShow.image = image;
                            [cell setNeedsLayout];
                        }
                    });
                }
            });
        }
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[VideoTableViewCell class]]) {
        VideoTableViewCell *videoCell = (VideoTableViewCell*)cell;
        [videoCell.videoPlayer pause];
    }
}
-(void)userSelected:(UIView *)sender{
    
   //Handle according to sender.tag
}

// UIGestureRecognizerDelegate methods

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.tableView]) {
        
        return NO;
    }
    
    return YES;
}
@end
