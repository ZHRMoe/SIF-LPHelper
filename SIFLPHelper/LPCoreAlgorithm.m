//
//  LPCoreAlgorithm.m
//  SIFLPHelper
//
//  Created by ZHRMoe on 16/2/7.
//  Copyright © 2016年 ZHRMoe. All rights reserved.
//

#import "LPCoreAlgorithm.h"

#define EXPF(x) 0.522 * x * x + 0.522 * x + 10.0005

@implementation LPCoreAlgorithm

+ (BOOL)isPureInt:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    int intVal;
    return [scanner scanInt:&intVal] && [scanner isAtEnd];
}

+ (double)expFunc:(NSInteger)level {
    double exp;
    if (level > 33) {
        NSInteger nlevel = level - 33;
        exp = round((EXPF(level)) - (EXPF(nlevel)));
    } else {
        exp = round(EXPF(level));
    }
    return exp;
}

+ (double)lpFunc:(NSInteger)level {
    return 25 + floor(MIN(level, 300) / 2) + floor(MAX(level - 300, 0) / 3);
}

@end
