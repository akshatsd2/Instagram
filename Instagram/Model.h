//
//  Model.h
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@end

@interface User : NSObject

@property (strong,nonatomic) NSString *user_id;
@property (strong,nonatomic) NSString *user_name;
@property (strong,nonatomic) NSString *user_profile_pic;
@property (assign,nonatomic) BOOL is_video;
@property (strong,nonatomic) NSString *image_url;
@property (strong,nonatomic) NSString *video_url;

@end
