//
//  LPNetworkCenter.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/6.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "LPNetworkCenter.h"
#import <UIKit/UIKit.h>

@interface LPNetworkCenter()

+ (LPNetworkCenter *)networkCenter;

- (void)addNetworkingAction;
- (void)removeNetworkingAction;

@property (nonatomic) NSUInteger networkingCount;

@end

@implementation LPNetworkCenter

+ (void)add {
    [[LPNetworkCenter networkCenter] addNetworkingAction];
}

+ (void)del {
    [[LPNetworkCenter networkCenter] removeNetworkingAction];
}

+ (LPNetworkCenter *)networkCenter {
    static LPNetworkCenter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LPNetworkCenter alloc] init];
    });
    return sharedInstance;
}

- (void)addNetworkingAction {
    self.networkingCount++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)removeNetworkingAction {
    self.networkingCount--;
    if (self.networkingCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

@end
