//
//  HomeViewController.h
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiRequest.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ApiResponseDelegate,UIGestureRecognizerDelegate>

@property BOOL isRequesting;
@property (strong,nonatomic) NSMutableArray *usersArray;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL firstLaunch;
@end
