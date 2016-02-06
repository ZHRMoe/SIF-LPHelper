//
//  LPNotificationNote.h
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/6.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPNotificationNote : NSObject

@property (nonatomic, copy) NSDate *estimatedTime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)noteWithDictionary:(NSDictionary *)dict;

@end
