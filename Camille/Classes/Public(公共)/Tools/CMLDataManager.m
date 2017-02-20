//
//  CMLDataManager.m
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLDataManager.h"

//缓存
static NSInteger accountingsPageCount = 20;
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
    if (loadType == Load_Type_Refresh) {
        //刷新(取消日期查询 或者 添加了新的accounting)
        if (![self _accountingsNeedUpdate]) {
            //缓存数据未被污染，直接返回当前缓存的allAccountingsArrangeByDay
            //(取消日期查询)
            callBack(allAccountingsArrangeByDay);
            
        } else {
            //缓存数据已被污染，重新update一页数据，然后返回当前缓存的allAccountingsArrangeByDay
            //(添加了新的accounting)
            [self _accountingsUpdateFromIndex:0 count:accountingsPageCount callback:^(BOOL isUpdateSuccess) {
                if (isUpdateSuccess) {
                    callBack(allAccountingsArrangeByDay);
                    
                } else {
                    callBack(nil);
                }
            }];
        }
        
    } else {
        //获取更多数据（下拉加载更多）
        if (![self _accountingsNeedUpdate]) {
            //缓存数据未被污染，可以直接在当前基础上取下一页数据
            [self _accountingsUpdateFromIndex:allAccountings.count count:accountingsPageCount callback:^(BOOL isUpdateSuccess) {
                if (isUpdateSuccess) {
                    callBack(allAccountingsArrangeByDay);
                    
                } else {
                    callBack(nil);
                }
            }];
            
        } else {
            //缓存数据已被污染，所有数据都要全部重新拿
            [self _accountingsUpdateFromIndex:0 count:allAccountings.count + accountingsPageCount callback:^(BOOL isUpdateSuccess) {
                if (isUpdateSuccess) {
                    callBack(allAccountingsArrangeByDay);
                    
                } else {
                    callBack(nil);
                }
            }];
        }
    }
}

+ (void)_setAccountingsNeedUpdate {
    accountingsNeedUpdate = YES;
}

+ (BOOL)_accountingsNeedUpdate {
    return accountingsNeedUpdate;
}

//要update几条accounting数据
+ (void)_accountingsUpdateFromIndex:(NSInteger)starIndex count:(NSInteger)pageCount callback:(void(^)(BOOL isUpdateSuccess))callback {
    DECLARE_WEAK_SELF
    [Accounting fetchAccountingsFrom:starIndex count:pageCount callBack:^(CMLResponse * _Nonnull response) {
        if (PHRASE_ResponseSuccess) {
            if (starIndex == 0) {
                //清空allAccountings，重新整理allAccountingsArrangeByDay
                allAccountings = response.responseDic[KEY_Accountings];
                if (allAccountings) {
                    [weakSelf _arrangeAccountingsByDayWithType:Accounting_Arrange_All];
                    
                } else {
                    callback(NO);
                }
                
            } else {
                //在当前缓存基础上继续添加
                NSArray *newPageData = response.responseDic[KEY_Accountings];
                if (newPageData) {
                    [allAccountings addObjectsFromArray:response.responseDic[KEY_Accountings]];
                    [weakSelf _arrangeAccountingsByDayWithType:Accounting_Arrange_New_Page];
                    
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

+ (void)_arrangeAccountingsByDayWithType:(Accounting_Arrange_Type)accountingArrangeType {
    if (accountingArrangeType == Accounting_Arrange_All) {
        //全部Accounting重新整理进allAccountingsArrangeByDay
        [allAccountingsArrangeByDay removeAllObjects];
    }
    
    MainSectionModel *currentSection;
    for (Accounting *accounting in allAccountings) {
        if (currentSection && [currentSection.diaplayDate isEqualToString:accounting.happenDay]) {
            //建立一个cell
            MainCellModel *cellModel = [MainCellModel mainCellModelWithAccounting:accounting];
            
            //添加cell
            [currentSection addCell:cellModel];
            
        } else {
            //重新在allAccountingsArrangeByDay中找出这条accounting对应的MainSectionModel
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"diaplayDate=%@", accounting.happenDay];
            MainSectionModel *mainSectionModel = (MainSectionModel *)[[allAccountingsArrangeByDay filteredArrayUsingPredicate:predicate] lastObject];
            
            //遍历第一个accounting的时候，currentSection会为nil
            //allAccountingsArrangeByDay中没有对应日期的数据的时候，mainSectionModel会为nil
            //这两种情况下都需要新建MainSectionModel
            if (!currentSection || !mainSectionModel) {
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
                currentSection = mainSectionModel;
                MainCellModel *cellModel = [MainCellModel mainCellModelWithAccounting:accounting];
                [currentSection addCell:cellModel];
            }
        }
    }
}

@end
