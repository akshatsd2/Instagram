//
//  CacheClass.h
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CacheClass : NSObject

@property (nonatomic, strong) NSCache *imageCache;
+ (CacheClass*)sharedInstance;
- (void)cacheImage:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)getCachedImageForKey:(NSString*)key;
@end
