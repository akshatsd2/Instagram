//
//  Utility.h
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : UIViewController

+(BOOL)isInternetWorking;
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message withController:(UIViewController*)viewController;
@end
