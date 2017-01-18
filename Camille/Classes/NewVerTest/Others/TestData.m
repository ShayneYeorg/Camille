//
//  TestData.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "TestData.h"

@implementation TestData

static NSMutableArray *allDataArr;

+ (NSArray *)dataArrayFrom:(NSInteger)startIndex to:(NSInteger)endIndex{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allDataArr = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            NSMutableArray *arrM = [NSMutableArray array];
            for (int n = 0; n < 3; n++) {
                TestDataAccounting *accounting = [TestDataAccounting new];
                NSDictionary *accountDic = @{
                                             @"name": [NSString stringWithFormat:@"%zd%zd", i, n],
//                                             @"name": [self randomName],
                                             @"value": @"0",
//                                             @"value": [self randomValue],
                                             @"isOutcome": @1,
                                             @"desc": @"xxx"
                                             };
                [accounting setValuesForKeysWithDictionary:accountDic];
                [arrM addObject:accounting];
            }
            [dicM setValue:arrM forKey:[NSString stringWithFormat:@"%zd", i]];
            [allDataArr addObject:dicM];
        }
    });
    
    /*
     0  / 3 = 0     3 3 3 3 3 3 2
     19 / 3 = 6
     20 / 3 = 6     1 3 3 3 3 3 3 1
     39 / 3 = 13
     40 / 3 = 13    2 3 3 3 3 3 3
     59 / 3 = 19
     */
    
    NSMutableArray *returnArrM = [NSMutableArray array];
    
    if (startIndex == 0) {
        for (int i = 0 ; i < 6; i++) {
            [returnArrM addObject:allDataArr[i]];
        }
        NSMutableArray *arrM = [allDataArr[6][@"6"] mutableCopy];
        [arrM removeLastObject];
        NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:arrM, @"6", nil];
        [returnArrM addObject:dicM];
        
    } else if (startIndex == 6) {
        for (int i = 6 ; i < 13; i++) {
            [returnArrM addObject:allDataArr[i]];
        }
        
        NSMutableArray *arrM2 = [allDataArr[13][@"13"] mutableCopy];
        [arrM2 removeLastObject];
        [arrM2 removeLastObject];
        NSMutableDictionary *dicM2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:arrM2, @"13", nil];
        [returnArrM addObject:dicM2];
        
    } else if (startIndex == 40) {
        for (int i = 13; i < 20; i++) {
            [returnArrM addObject:allDataArr[i]];
        }
    }
    
    return returnArrM;
}

+ (NSString *)randomName {
    NSArray *arr = @[
                     @"买菜",
                     @"买衣服",
                     @"羊城通",
                     @"买鞋",
                     @"买书",
                     @"外出吃饭",
                     @"宵夜",
                     @"饮料",
                     @"买杂物",
                     @"搭电动车"
                    ];
    
    return arr[arc4random()%10];
}


+ (NSString *)randomValue {
    return [NSString stringWithFormat:@"%zd", arc4random()%200];
}

@end
