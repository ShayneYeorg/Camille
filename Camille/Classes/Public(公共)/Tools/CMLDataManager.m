//
//  CMLDataManager.m
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLDataManager.h"

//Item缓存
static BOOL itemsNeedUpdate; //以下这4个容器类对象的内容是否过期，由itemsNeedUpdate来标识
static NSMutableArray *allIncomeItems; //存放所有的收入item
static NSMutableArray *allCostItems; //存放所有的支出item
static NSMutableDictionary *itemNameMapper; //key为itemID，value为itemName
static NSMutableDictionary *itemTypeMapper; //key为itemID，value为itemType

//Accounting缓存
static BOOL accountingsNeedUpdate; //以下这2个容器类对象的内容是否过期，由accountingsNeedUpdate来标识
static NSMutableArray *allAccountings; //存放所有的accounting
static NSMutableArray *allAccountingsArrangeByDay; //存放按日期整理过的所有accounting
const NSInteger accountingsPageCount = 10; //每页Accounting条数

@implementation CMLDataManager

#pragma mark - Life Cycle

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        itemsNeedUpdate = YES;
        allIncomeItems = [NSMutableArray array];
        allCostItems = [NSMutableArray array];
        itemNameMapper = [NSMutableDictionary dictionary];
        itemTypeMapper = [NSMutableDictionary dictionary];
        
        accountingsNeedUpdate = YES;
        allAccountings = [NSMutableArray array];
        allAccountingsArrangeByDay = [NSMutableArray array];
    });
}

#pragma mark - Item
#pragma mark -- Pubilc

+ (void)addItemWithName:(NSString *)itemName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
    [Item addItemWithName:itemName type:type callBack:^(CMLResponse * _Nonnull response) {
        if (PHRASE_ResponseSuccess) {
            [self _setItemsNeedUpdate];
        }
        callBack(response);
    }];
}

+ (void)fetchItemsWithItemType:(NSString *)itemType callback:(void(^)(CMLResponse *response))callBack {
    if ([itemType isEqualToString:Item_Type_Cost]) {
        [self fetchAllIncomeItemsWithCallback:callBack];
    }
    
    [self fetchAllCostItemsWithCallback:callBack];
}

+ (void)fetchAllIncomeItemsWithCallback:(void(^)(CMLResponse *response))callBack {
    CMLResponse *response = [CMLResponse new];
    if ([self _itemsNeedUpdate]) {
        [self _updateItemsWithCallback:^(BOOL isUpdateSuccess) {
            if (isUpdateSuccess) {
                response.code = RESPONSE_CODE_SUCCEED;
                response.desc = kTipFetchSuccess;
                response.responseDic = @{KEY_Items: allIncomeItems};
                callBack(response);
                
            } else {
                callBack(nil);
            }
        }];
        
    } else {
        response.code = RESPONSE_CODE_SUCCEED;
        response.desc = kTipFetchSuccess;
        response.responseDic = @{KEY_Items: allIncomeItems};
        callBack(response);
    }
}

+ (void)fetchAllCostItemsWithCallback:(void(^)(CMLResponse *response))callBack {
    CMLResponse *response = [CMLResponse new];
    if ([self _itemsNeedUpdate]) {
        [self _updateItemsWithCallback:^(BOOL isUpdateSuccess) {
            if (isUpdateSuccess) {
                response.code = RESPONSE_CODE_SUCCEED;
                response.desc = kTipFetchSuccess;
                response.responseDic = @{KEY_Items: allCostItems};
                callBack(response);
                
            } else {
                callBack(nil);
            }
        }];
        
    } else {
        response.code = RESPONSE_CODE_SUCCEED;
        response.desc = kTipFetchSuccess;
        response.responseDic = @{KEY_Items: allCostItems};
        callBack(response);
    }
}

+ (void)itemNameByItemID:(NSString *)itemID callback:(void(^)(NSString *itemName))callback {
    if ([self _itemsNeedUpdate]) {
        [self _updateItemsWithCallback:^(BOOL isUpdateSuccess) {
            if (isUpdateSuccess) {
                callback((NSString *)itemNameMapper[itemID]);
                
            } else {
                callback(nil);
            }
        }];
        
    } else {
        callback((NSString *)itemNameMapper[itemID]);
    }
}

+ (void)itemTypeByItemID:(NSString *)itemID callback:(void(^)(NSString *itemType))callback {
    if ([self _itemsNeedUpdate]) {
        [self _updateItemsWithCallback:^(BOOL isUpdateSuccess) {
            if (isUpdateSuccess) {
                callback((NSString *)itemTypeMapper[itemID]);
                
            } else {
                callback(nil);
            }
        }];
        
    } else {
        callback((NSString *)itemTypeMapper[itemID]);
    }
}

+ (void)itemUsed:(Item *)item {
    [Item itemUsed:item];
}

#pragma mark -- Cache

+ (void)_setItemsNeedUpdate {
    itemsNeedUpdate = YES;
}

+ (void)_setItemsDidUpdate {
    itemsNeedUpdate = NO;
}

+ (BOOL)_itemsNeedUpdate {
    return itemsNeedUpdate;
}

+ (void)_updateItemsWithCallback:(void(^)(BOOL isUpdateSuccess))callback {
    DECLARE_WEAK_SELF
    [Item fetchItemsWithType:Item_Fetch_All callBack:^(CMLResponse * _Nonnull response) {
        if (PHRASE_ResponseSuccess) {
            //income items
            if (response.responseDic[KEY_Income_Items] && [response.responseDic[KEY_Income_Items] isKindOfClass:[NSArray class]]) {
                [allIncomeItems removeAllObjects];
                [allIncomeItems addObjectsFromArray:response.responseDic[KEY_Income_Items]];
                for (Item *i in allIncomeItems) {
                    [weakSelf _updateItemNameMapperWithKey:i.itemID value:i.itemName];
                    [weakSelf _updateItemTypeMapperWithKey:i.itemID value:i.itemType];
                }
            }
            
            //cost items
            if (response.responseDic[KEY_Cost_Items] && [response.responseDic[KEY_Cost_Items] isKindOfClass:[NSArray class]]) {
                [allCostItems removeAllObjects];
                [allCostItems addObjectsFromArray:response.responseDic[KEY_Cost_Items]];
                for (Item *i in allCostItems) {
                    [weakSelf _updateItemNameMapperWithKey:i.itemID value:i.itemName];
                    [weakSelf _updateItemTypeMapperWithKey:i.itemID value:i.itemType];
                }
            }
            
            [self _setItemsDidUpdate];
            callback(YES);
            
        } else {
            callback(NO);
        }
    }];
}

#pragma mark -- Private

+ (void)_updateItemNameMapperWithKey:(NSString *)key value:(NSString *)value {
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [itemNameMapper setValue:value forKey:key];
    dispatch_semaphore_signal(lock);
}

+ (void)_updateItemTypeMapperWithKey:(NSString *)key value:(NSString *)value {
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [itemTypeMapper setValue:value forKey:key];
    dispatch_semaphore_signal(lock);
}


#pragma mark - Accounting
#pragma mark -- Public

+ (void)addAccountingWithItemID:(NSString *)itemID amount:(NSNumber *)amount happneTime:(NSDate *)happenTime desc:(NSString *)desc callBack:(void(^)(CMLResponse *response))callBack {
    [Accounting addAccountingWithItemID:itemID amount:amount happneTime:happenTime desc:desc callBack:^(CMLResponse * _Nonnull response) {
        if (PHRASE_ResponseSuccess) {
            [self _setAccountingsNeedUpdate];
        }
        callBack(response);
    }];
}

+ (void)fetchAllAccountingsWithLoadType:(Load_Type)loadType callBack:(void(^)(BOOL isFetchSuccess, NSMutableArray *accountings, NSInteger newSectionCount, NSInteger newCellCount))callBack {
    if (![self _accountingsNeedUpdate]) {
        //一、缓存数据未被污染
        if (loadType == Load_Type_Refresh) {
            //1、(取消日期查询)
            //直接返回当前缓存的allAccountingsArrangeByDay
            callBack(YES, allAccountingsArrangeByDay, 0, 0);
            
        } else {
            //2、(加载新页)
            //直接在当前基础上取下一页数据
            [self _fetchAccountingsFromIndex:allAccountings.count count:accountingsPageCount callback:^(BOOL isFetchSuccess, NSInteger newSectionCount, NSInteger newCellCount) {
                if (isFetchSuccess) {
                    callBack(YES, allAccountingsArrangeByDay, newSectionCount, newCellCount);
                    
                } else {
                    callBack(NO, nil, 0, 0);
                }
            }];
        }
        
    } else {
        //二、缓存数据无数据 或 已被污染
        //重新update数据，然后返回当前缓存的allAccountingsArrangeByDay
        //1、loadType为Load_Type_Refresh表示(初次打开 | 添加了新的accounting)
        //2、loadType为Load_Type_LoadMore表示(加载新页)
        [self _updateAccountingWithLoadType:loadType callback:^(BOOL isUpdateSuccess, NSInteger newSectionCount, NSInteger newCellCount) {
            if (isUpdateSuccess) {
                callBack(YES, allAccountingsArrangeByDay, newSectionCount, newCellCount);
                
            } else {
                callBack(NO, nil, 0, 0);
            }
        }];
    }
}

#pragma mark -- Cache

+ (void)_setAccountingsNeedUpdate {
    accountingsNeedUpdate = YES;
}

+ (void)_setAccountingsDidUpdate {
    accountingsNeedUpdate = NO;
}

+ (BOOL)_accountingsNeedUpdate {
    return accountingsNeedUpdate;
}

+ (void)_updateAccountingWithLoadType:(Load_Type)loadType callback:(void(^)(BOOL isUpdateSuccess, NSInteger newSectionCount, NSInteger newCellCount))callback {
    NSInteger count = accountingsPageCount;
    if (loadType == Load_Type_LoadMore) {
        count += allAccountings.count;
    }
    
    DECLARE_WEAK_SELF
    [self _fetchAccountingsFromIndex:0 count:count callback:^(BOOL isFetchSuccess, NSInteger newSectionCount, NSInteger newCellCount) {
        //这种情况下newSectionCount和newCellCount没有多大意义
#warning - 有了修改Accounting的功能后，要测试一下Accounting被修改导致数据污染后，下拉加载更多要怎么展示
        if (isFetchSuccess) {
            [weakSelf _setAccountingsDidUpdate];
            callback(YES, newSectionCount, newCellCount);
            
        } else {
            callback(NO, 0, 0);
        }
    }];
}

#pragma mark -- Private

//fetch accounting数据
+ (void)_fetchAccountingsFromIndex:(NSInteger)starIndex count:(NSInteger)accountingCount callback:(void(^)(BOOL isFetchSuccess, NSInteger newSectionCount, NSInteger newCellCount))callback {
    DECLARE_WEAK_SELF
    [Accounting fetchAccountingsFrom:starIndex count:accountingCount callBack:^(CMLResponse * _Nonnull response) {
        if (PHRASE_ResponseSuccess) {
            if (starIndex == 0) {
                //1、清空allAccountings，重新整理allAccountingsArrangeByDay
                NSArray *allData = response.responseDic[KEY_Accountings];
                if (allAccountings) {
                    [weakSelf _arrangeAccountingsByDayWithType:Accounting_Arrange_All newAccountings:allData callback:^(NSInteger newSectionCount, NSInteger newCellCount) {
                        callback(YES, newSectionCount, newCellCount);
                    }];
                    
                } else {
                    callback(NO, 0, 0);
                }
                
            } else {
                //2、在当前缓存基础上继续添加
                NSArray *newPageData = response.responseDic[KEY_Accountings];
                if (newPageData) {
                    [weakSelf _arrangeAccountingsByDayWithType:Accounting_Arrange_New_Page newAccountings:newPageData callback:^(NSInteger newSectionCount, NSInteger newCellCount) {
                        callback(YES, newSectionCount, newCellCount);
                    }];
                    
                } else {
                    callback(NO, 0, 0);
                }
            }
            
        } else {
            callback(NO, 0, 0);
        }
    }];
}

+ (void)_arrangeAccountingsByDayWithType:(Accounting_Arrange_Type)accountingArrangeType newAccountings:(NSArray *)newAccountings callback:(void(^)(NSInteger newSectionCount, NSInteger newCellCount))callback {
    NSInteger newSCount = 0;
    
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
                newSCount++;
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
    
    //返回新增的section数和cell数，给首页布局contentOffset使用
    callback(newSCount, newAccountings.count);
}

@end


//Accounting fetch测试数据

//DECLARE_WEAK_SELF
//[CMLDataManager fetchAllAccountingsWithLoadType:loadType callBack:^(NSMutableArray *accountings) {
//    weakSelf.accountingsData = accountings;
//}];
