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
 *  检查“未分类 —— 新增”这个科目是否存在，不存在则新建
 */
+ (void)checkInitialItem;

/**
 *  取出所有记账科目(分组并排序)
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
 *  新增记账科目
 *
 *  @param ItemName             二级科目名称
 *  @param ItemCategoryName     一级科目名称
 *  @param callBack             回调
 */
+ (void)addItem:(NSString *)itemName inCategory:(NSString *)categoryName callBack:(void(^)(CMLResponse *response))callBack;

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
