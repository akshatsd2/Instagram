//
//  ApiRequest.h
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@protocol ApiResponseDelegate <NSObject>
@optional
-(void)GETResponseReceived:(id)response;
@end
@interface ApiRequest : NSObject{
    MBProgressHUD *HUD;
}

@property (nonatomic,weak) id<ApiResponseDelegate> delegate;
-(void)sendGETRequestWithURL:(NSString *)requestURL displayHUD:(BOOL)displayHUD;

@end
