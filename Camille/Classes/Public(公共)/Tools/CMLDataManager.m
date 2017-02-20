//
//  CMLDataManager.m
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLDataManager.h"

//缓存
#warning - accountingsPageCount记得改回20
static NSInteger accountingsPageCount = 5;
static BOOL accountingsNeedUpdate;
static NSMutableArray *allAccountings;
static NSMutableArray *allAccountingsArrangeByDay;

@implementation CMLDataManager

#pragma mark - Life Cycle

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountingsNeedUpdate = YES;
        allAccountings = [NSMutableArray array];
        allAccountingsArrangeByDay = [NSMutableArray array];
    });
}

+ (NSArray *)getItemsWithItemType:(NSString *)itemType {
    if ([itemType isEqualToString:Item_Type_Cost]) {
        return [Item getAllCostItems];
    }
    
    return [Item getAllIncomeItems];
}

+ (void)fetchAllAccountingsWithLoadType:(Load_Type)loadType callBack:(void(^)(NSMutableArray *accountings))callBack {
    if (![self _accountingsNeedUpdate]) {
        //一、缓存数据未被污染
        if (loadType == Load_Type_Refresh) {
            //1、(取消日期查询)
            //直接返回当前缓存的allAccountingsArrangeByDay
            callBack(allAccountingsArrangeByDay);
            
        } else {
            //2、(加载新页)
            //直接在当前基础上取下一页数据
            [self _fetchAccountingsFromIndex:allAccountings.count count:accountingsPageCount callback:^(BOOL isFetchSuccess) {
                if (isFetchSuccess) {
                    callBack(allAccountingsArrangeByDay);
                    
                } else {
                    callBack(nil);
                }
            }];
        }
        
    } else {
        //二、缓存数据已被污染
        //重新update数据，然后返回当前缓存的allAccountingsArrangeByDay
        //1、loadType为Load_Type_Refresh表示(初次打开 | 添加了新的accounting)
        //2、loadType为Load_Type_LoadMore表示(加载新页)
        [self _updateAccountingWithLoadType:loadType callback:^(BOOL isUpdateSuccess) {
            if (isUpdateSuccess) {
                callBack(allAccountingsArrangeByDay);
                
            } else {
                callBack(nil);
            }
        }];
    }
}

+ (void)_setAccountingsNeedUpdate {
    accountingsNeedUpdate = YES;
}

+ (BOOL)_accountingsNeedUpdate {
    return accountingsNeedUpdate;
}

+ (void)_updateAccountingWithLoadType:(Load_Type)loadType callback:(void(^)(BOOL isUpdateSuccess))callback {
    NSInteger count = accountingsPageCount;
    if (loadType == Load_Type_LoadMore) {
        count += allAccountings.count;
    }
    
    [self _fetchAccountingsFromIndex:0 count:count callback:^(BOOL isFetchSuccess) {
        if (isFetchSuccess) {
            accountingsNeedUpdate = NO;
            callback(YES);
            
        } else {
            callback(NO);
        }
    }];
}

//fetch accounting数据
+ (void)_fetchAccountingsFromIndex:(NSInteger)starIndex count:(NSInteger)pageCount callback:(void(^)(BOOL isFetchSuccess))callback {
    DECLARE_WEAK_SELF
    [Accounting fetchAccountingsFrom:starIndex count:pageCount callBack:^(CMLResponse * _Nonnull response) {
        if (PHRASE_ResponseSuccess) {
            if (starIndex == 0) {
                //1、清空allAccountings，重新整理allAccountingsArrangeByDay
                NSArray *allData = response.responseDic[KEY_Accountings];
                if (allAccountings) {
                    [weakSelf _arrangeAccountingsByDayWithType:Accounting_Arrange_All newAccountings:allData];
                    
                } else {
                    callback(NO);
                }
                
            } else {
                //2、在当前缓存基础上继续添加
                NSArray *newPageData = response.responseDic[KEY_Accountings];
                if (newPageData) {
                    [weakSelf _arrangeAccountingsByDayWithType:Accounting_Arrange_New_Page newAccountings:newPageData];
                    
                } else {
                    callback(NO);
                }
            }
            callback(YES);
            
        } else {
            callback(NO);
        }
    }];
}

+ (void)_arrangeAccountingsByDayWithType:(Accounting_Arrange_Type)accountingArrangeType newAccountings:(NSArray *)newAccountings {
    //一、清理数据
    if (accountingArrangeType == Accounting_Arrange_All) {
        //重新赋值allAccountings
        //allAccountingsArrangeByDay清空以便完全重新整理
        allAccountings = newAccountings.mutableCopy;
        [allAccountingsArrangeByDay removeAllObjects];
        
    } else {
        //将新页的Accounting添加到allAccountings里
        [allAccountings addObjectsFromArray:newAccountings];
    }
    
    //二、整理数据
    MainSectionModel *currentSection;
    for (Accounting *accounting in newAccountings) {
        if (currentSection && [currentSection.diaplayDate isEqualToString:accounting.happenDay]) {
            //建立一个cell
            MainCellModel *cellModel = [MainCellModel mainCellModelWithAccounting:accounting];
            
            //添加cell
            [currentSection addCell:cellModel];
            
        } else {
            //重新在allAccountingsArrangeByDay中找出这条accounting对应的MainSectionModel
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"diaplayDate=%@", accounting.happenDay];
            MainSectionModel *existSectionModel = (MainSectionModel *)[[allAccountingsArrangeByDay filteredArrayUsingPredicate:predicate] lastObject];
            
            //①、遍历第一个accounting的时候，existSectionModel肯定为nil
            //②、allAccountingsArrangeByDay中没有对应日期的数据的时候，existSectionModel也会为nil
            //这两种情况下都需要新建MainSectionModel
            if (!existSectionModel) {
                //allAccountingsArrangeByDay中未有这个日期的MainSectionModel
                //新建一个section
                MainSectionModel *sectionModel = [MainSectionModel mainSectionModelWithAccounting:accounting];
                [allAccountingsArrangeByDay addObject:sectionModel];
                currentSection = sectionModel;
                
                //建立第一个cell
                MainCellModel *cellModel = [MainCellModel mainCellModelWithAccounting:accounting];
                
                //添加第一个cell
                [sectionModel addCell:cellModel];
                
            } else {
                //allAccountingsArrangeByDay中已有这个日期的MainSectionModel
                currentSection = existSectionModel;
                MainCellModel *cellModel = [MainCellModel mainCellModelWithAccounting:accounting];
                [currentSection addCell:cellModel];
            }
        }
    }
}

@end
