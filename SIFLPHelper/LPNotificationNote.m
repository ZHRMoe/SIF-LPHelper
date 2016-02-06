//
//  LPNotificationNote.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/6.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "LPNotificationNote.h"

@implementation LPNotificationNote

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)noteWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

@end
