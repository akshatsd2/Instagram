//
//  Utility.m
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"

static UIAlertView *alert;
static UIAlertController *alertController;

@implementation Utility

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message withController:(UIViewController*)viewController
{
    if ([UIAlertController class]){
        if(![alertController.title isEqualToString:title] || ![alertController.message isEqualToString:message]){
            alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [viewController presentViewController:alertController animated:YES completion:nil];
        }
    }
    else if (![alert isVisible] || ![alert.title isEqualToString:title] || ![alert.message isEqualToString:message]) {
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}

+(BOOL)isInternetWorking{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

@end
