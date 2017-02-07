//
//  CacheClass.m
//  Instagram
//
//  Created by Akshat Mittal on 05/02/17.
//  Copyright © 2017 Akshat Mittal. All rights reserved.
//

#import "CacheClass.h"
static CacheClass *sharedInstance;

@implementation CacheClass

+ (CacheClass*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CacheClass alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)cacheImage:(UIImage*)image forKey:(NSString*)key {
    [self.imageCache setObject:image forKey:key];
}

- (UIImage*)getCachedImageForKey:(NSString*)key {
    return [self.imageCache objectForKey:key];
}

@end
