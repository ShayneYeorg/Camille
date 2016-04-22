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

+ (CMLRecordMonthDetailModel *)sortAccountingsByDay:(NSArray *)accountings {
    //获取整个月的账务数据，进行排序处理
    
    //传空值的滚蛋
    if (!accountings) return nil;
    
    //将所有账务按照日期分组
    CMLRecordMonthDetailModel *recordMonthDetailModel = [CMLRecordMonthDetailModel new];
    recordMonthDetailModel.totalCost = 0;
    recordMonthDetailModel.totalIncome = 0;
    
    NSMutableDictionary *sectionDetailDic = [NSMutableDictionary dictionary];
    
    for (int n = 0; n < accountings.count; n++) {
        CMLAccounting *account = (CMLAccounting *)accountings[n];
        if (![sectionDetailDic.allKeys containsObject:account.happenDay]) {
            CMLRecordMonthDetailSectionModel *recordMonthDetailSectionModel = [CMLRecordMonthDetailSectionModel new];
            recordMonthDetailSectionModel.day = account.happenDay;
            if ([account.type isEqualToString:Item_Type_Cost]) {
                recordMonthDetailSectionModel.cost += [account.amount floatValue];
                recordMonthDetailSectionModel.income = 0;
                
            } else {
                recordMonthDetailSectionModel.cost = 0;
                recordMonthDetailSectionModel.income += [account.amount floatValue];
            }
            [recordMonthDetailSectionModel.detailCells addObject:account];
            [sectionDetailDic setObject:recordMonthDetailSectionModel forKey:account.happenDay];
            
        } else {
            CMLRecordMonthDetailSectionModel *recordMonthDetailSectionModel = sectionDetailDic[account.happenDay];
            if ([account.type isEqualToString:Item_Type_Cost]) {
                recordMonthDetailSectionModel.cost += [account.amount floatValue];
                
            } else {
                recordMonthDetailSectionModel.income += [account.amount floatValue];
            }
            [recordMonthDetailSectionModel.detailCells addObject:account];
        }
    }
    
    for (NSString *key in sectionDetailDic.allKeys) {
        CMLRecordMonthDetailSectionModel *recordMonthDetailSectionModel = sectionDetailDic[key];
        [recordMonthDetailModel.detailSections addObject:recordMonthDetailSectionModel];
        recordMonthDetailModel.totalIncome += recordMonthDetailSectionModel.income;
        recordMonthDetailModel.totalCost += recordMonthDetailSectionModel.cost;
    }
    
    return recordMonthDetailModel;
}

@end
