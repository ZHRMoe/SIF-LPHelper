//
//  LPCoreAlgorithm.h
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/7.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPCoreAlgorithm : NSObject

+ (BOOL)isPureInt:(NSString *)string;
+ (double)expFunc:(NSInteger)level;
+ (double)lpFunc:(NSInteger)level;

@end
