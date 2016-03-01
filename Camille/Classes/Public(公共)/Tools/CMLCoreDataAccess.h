//
//  CMLCoreDataAccess.h
//  Camille
//
//  Created by 杨淳引 on 16/2/28.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLAccounting.h"
#import "CMLItemCategory.h"
#import "CMLItem.h"
#import "CMLResponse.h"

@interface CMLCoreDataAccess : NSObject

/**
 *  取出所有记账科目(并排序)
 *
 *  @param callBack             回调
 */
+ (void)fetchAllItems:(void(^)(CMLResponse *response))callBack;

/**
 *  取出所有一级记账科目(并排序)
 *
 *  @param callBack             回调
 */
+ (void)fetchAllItemCategories:(void(^)(CMLResponse *response))callBack;

/**
 *  新增一级记账科目
 *
 *  @param ItemCategoryName     科目名称
 *  @param callBack             回调
 */
+ (void)addItemCategory:(NSString *)itemCategoryName callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  新增二级记账科目
 *
 *  @param ItemCategoryName     科目名称
 *  @param categoryID           一级科目ID
 *  @param callBack             回调
 */
+ (void)addItem:(NSString *)itemName categoryID:(NSString *)categoryID callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  新增账务记录
 *
 *  @param item                 项目名称
 *  @param amount               项目金额
 *  @param happenTime           发生时间
 *  @param callBack             回调
 */
+ (void)addAccountingWithItem:(NSString *)itemID amount:(NSNumber *)amount happneTime:(NSDate *)happenTime callBack:(void(^)(CMLResponse *response))callBack;

@end
