//
//  CMLAccounting.m
//  Camille
//
//  Created by 杨淳引 on 16/2/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccounting.h"

@implementation CMLAccounting

#pragma mark - Public

+ (NSDictionary *)sortAccountingsByDay:(NSArray *)accountings {
    //获取整个月的账务数据，进行排序处理
    
    //传空值的滚蛋
    if (!accountings) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"happenTime < %@", [NSDate date]];
    NSArray *filteredArr = [accountings filteredArrayUsingPredicate:predicate];
    CMLLog(@"%@", filteredArr);
    
    NSDictionary *retDic = [NSDictionary dictionary];
    return retDic;
}

@end
