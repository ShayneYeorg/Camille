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
    //获取整个月的账务数据，按照日期进行排序处理
    
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
            recordMonthDetailSectionModel.setionDay = account.happenDay;
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
    
    [recordMonthDetailModel.detailSections sortUsingComparator:^NSComparisonResult(CMLRecordMonthDetailSectionModel *m1, CMLRecordMonthDetailSectionModel *m2) {
        return [@([m1.setionDay integerValue])compare:@([m2.setionDay integerValue])];
    }];
    
    return recordMonthDetailModel;
}

+ (CMLRecordItemDetailModel *)sortAccountingsByItem:(NSArray *)accountings {
    //获取整个月的账务数据，按照科目类型进行分类排序处理
    
    //传空值的滚蛋
    if (!accountings) return nil;
    
    //将所有账务按照科目分组
    CMLRecordItemDetailModel *recordItemDetailModel = [CMLRecordItemDetailModel new];
    recordItemDetailModel.totalCost = 0;
    recordItemDetailModel.totalIncome = 0;
    
    NSMutableDictionary *sectionDetailDic = [NSMutableDictionary dictionary];
    
    for (int n = 0; n < accountings.count; n++) {
        CMLAccounting *account = (CMLAccounting *)accountings[n];
        if (![sectionDetailDic.allKeys containsObject:account.itemID]) {
            CMLRecordItemDetailSectionModel *recordItemDetailSectionModel = [CMLRecordItemDetailSectionModel new];
            recordItemDetailSectionModel.setionItemID = account.itemID;
            recordItemDetailSectionModel.type = account.type;
            recordItemDetailSectionModel.amount += [account.amount floatValue];
            [recordItemDetailSectionModel.detailCells addObject:account];
            [sectionDetailDic setObject:recordItemDetailSectionModel forKey:account.itemID];
            
        } else {
            CMLRecordItemDetailSectionModel *recordItemDetailSectionModel = sectionDetailDic[account.itemID];
            recordItemDetailSectionModel.amount += [account.amount floatValue];
            [recordItemDetailSectionModel.detailCells addObject:account];
        }
    }
    
    for (NSString *key in sectionDetailDic.allKeys) {
        CMLRecordItemDetailSectionModel *recordItemDetailSectionModel = sectionDetailDic[key];
        [recordItemDetailSectionModel.detailCells sortUsingComparator:^NSComparisonResult(CMLAccounting *a1, CMLAccounting *a2) {
            return [@([a1.happenDay integerValue])compare:@([a2.happenDay integerValue])];
        }];
        [recordItemDetailModel.detailSections addObject:recordItemDetailSectionModel];
        if ([recordItemDetailSectionModel.type isEqualToString:Item_Type_Cost]) {
            recordItemDetailModel.totalCost += recordItemDetailSectionModel.amount;
            
        } else {
            recordItemDetailModel.totalIncome += recordItemDetailSectionModel.amount;
        }
    }
    
    [recordItemDetailModel.detailSections sortUsingComparator:^NSComparisonResult(CMLRecordItemDetailSectionModel *m1, CMLRecordItemDetailSectionModel *m2) {
        return [@([m1.type integerValue])compare:@([m2.type integerValue])];
    }];
    
    return recordItemDetailModel;
}

@end
