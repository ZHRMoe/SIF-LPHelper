//
//  LPCoreAlgorithm.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/7.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "LPCoreAlgorithm.h"

@implementation LPCoreAlgorithm

+ (BOOL)isPureInt:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    int intVal;
    return [scanner scanInt:&intVal] && [scanner isAtEnd];
}

+ (double)expFunc:(NSInteger)level {
    return 0.522 * level * level + 0.522 * level + 10.0005;
}

@end
