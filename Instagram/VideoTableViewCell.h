//
//  VideoTableViewCell.h
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) AVPlayerItem* videoItem;

@property (strong, nonatomic) AVPlayer* videoPlayer;

@property (strong, nonatomic) AVPlayerLayer* avLayer;
@end
