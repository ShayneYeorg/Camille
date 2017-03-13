//
//  CMLDataManager.h
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainDataModel.h"

typedef NS_ENUM (NSInteger, Load_Type) {
    Load_Type_Refresh = 0,
    Load_Type_LoadMore,
};

typedef NS_ENUM (NSInteger, Accounting_Arrange_Type) {
    Accounting_Arrange_All = 0, //整理所有的Accounting数据
    Accounting_Arrange_New_Page, //只整理新的一页Accounting数据
};

@interface CMLDataManager : NSObject

#pragma mark - Item

/**
 添加item
 
 @param itemName 要添加的item的名字
 @param type     要添加的item的类型
 @param callBack 回调
 */
+ (void)addItemWithName:(NSString *)itemName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack;


+ (void)getItemsWithItemType:(NSString *)itemType callback:(void(^)(CMLResponse *response))callBack;


/**
 根据某个itemID获得它的itemName，查询的是缓存的数据
 
 @param itemID item的ID
 @return       itemName
 */
+ (NSString *)itemNameByItemID:(NSString *)itemID;


/**
 根据某个itemID获得它的itemType，查询的是缓存的数据
 
 @param itemID item的ID
 @return       itemType
 */
+ (NSString *)itemTypeByItemID:(NSString *)itemID;

#pragma mark - Accounting

/**
 *  新增账务记录
 *
 *  @param itemID               记账项目ID
 *  @param amount               金额
 *  @param happenTime           发生时间
 *  @param desc                 备注
 *  @param callBack             回调
 */
+ (void)addAccountingWithItemID:(NSString *)itemID amount:(NSNumber *)amount happneTime:(NSDate *)happenTime desc:(NSString *)desc callBack:(void(^)(CMLResponse *response))callBack;

//数据缓存在本层，调用的那层不管分页情况
+ (void)fetchAllAccountingsWithLoadType:(Load_Type)loadType callBack:(void(^)(BOOL isFetchSuccess, NSMutableArray *accountings, NSInteger newSectionCount, NSInteger newAccountingCount))callBack;

@end
