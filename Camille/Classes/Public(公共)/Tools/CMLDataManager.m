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
            callBack(allAccountingsArrangeByDay);
            
        } else {
            //缓存数据已被污染，重新update一页数据，然后返回当前缓存的allAccountingsArrangeByDay
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
                //清空allAccountings和allAccountingsArrangeByDay，重新来
                [allAccountings removeAllObjects];
                [allAccountingsArrangeByDay removeAllObjects];
                allAccountings = response.responseDic[KEY_Accountings];
                if (allAccountings) {
                    [weakSelf _arrangeAccountingsByDayWithLoadType:Load_Type_Refresh];
                    
                } else {
                    callback(NO);
                }
                
            } else {
                //在当前缓存基础上继续添加
                NSArray *newPageData = response.responseDic[KEY_Accountings];
                if (newPageData) {
                    [allAccountings addObjectsFromArray:response.responseDic[KEY_Accountings]];
                    [weakSelf _arrangeAccountingsByDayWithLoadType:Load_Type_LoadMore];
                    
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

+ (void)_arrangeAccountingsByDayWithLoadType:(Load_Type)loadType {
    //为了提高性能，不同的loadType方式，处理方式不同
    switch (loadType) {
        case Load_Type_Refresh: {
            MainSectionModel *currentSection;
            for (Accounting *accounting in allAccountings) {
                if (currentSection) {
                    if ([CMLTool isDate:accounting.happenTime equalsToDate:currentSection.happenDate]) {
                        //建立一个cell
                        MainCellModel *cellModel = [MainCellModel mainCellModelWithAccounting:accounting];
                        
                        //添加cell
                        [currentSection.cellModels addObject:cellModel];
                        
                    } else {
                        
                    }
                    
                } else {
                    //新建一个section
                    MainSectionModel *sectionModel = [MainSectionModel mainSectionModelWithAccounting:accounting];
                    [allAccountingsArrangeByDay addObject:sectionModel];
                    currentSection = sectionModel;
                    
                    //建立第一个cell
                    MainCellModel *cellModel = [MainCellModel mainCellModelWithAccounting:accounting];
                    
                    //添加第一个cell
                    [sectionModel.cellModels addObject:cellModel];
                }
            }
        }
            break;
            
        case Load_Type_LoadMore: {
            
        }
            break;
            
        default:
            break;
    }
}

@end
