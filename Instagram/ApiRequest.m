//
//  ApiRequest.m
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import "ApiRequest.h"
#import "Utility.h"

@implementation ApiRequest

-(void)sendGETRequestWithURL:(NSString *)requestURL displayHUD:(BOOL)displayHUD{
    
    if (HUD == nil && displayHUD){
        [self setUpHUD];
    }
    if(displayHUD && HUD.alpha !=1){
        [HUD showAnimated:YES];
    }
    NSURL *completeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServerURL, requestURL]];
    NSLog(@"complete url %@",completeURL);
    NSMutableURLRequest *APIRequest = [NSMutableURLRequest requestWithURL:completeURL];
    [APIRequest setHTTPMethod:@"GET"];
    [APIRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *downloadTask = [session
                                          dataTaskWithRequest:APIRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  if (error != nil) {
                                                      NSLog(@"%@", [error localizedDescription]);
                                                  }
                                                  else{
                                                      NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                                      if (HTTPStatusCode != 200) {
                                                          NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                                                      }
                                                      [self parseJsonAndForwardResponse:data];
                                                  }
                                                  if(displayHUD)
                                                      [HUD hideAnimated:YES];
                                              }];
                                          }];
    [downloadTask resume];
}
-(void)setUpHUD{
    
    if([UIApplication sharedApplication].keyWindow.rootViewController.view){
        HUD = [[MBProgressHUD alloc] initWithView: [UIApplication sharedApplication].keyWindow.rootViewController.view];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:HUD];
        HUD.label.text = @"Loading...";
    }
    
}

-(void)parseJsonAndForwardResponse:(NSData*)data
{
    NSError *jsonParsingError = nil;
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strData);
    id receivedResponse;
    if (data != nil) {
        
        receivedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers error:&jsonParsingError];
    }
    [self.delegate GETResponseReceived:receivedResponse];
    
}
@end
