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
 *  检查两类记账科目中，“设置 —— 新建分类”这个科目是否存在，不存在则新建
 */
+ (void)checkInitialItem:(NSString *)type;

/**
 *  取出所有一级记账科目(并排序)
 *
 *  @param callBack             回调
 */
+ (void)fetchAllItemCategories:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  取出所有二级记账科目(分组并排序)
 *
 *  @param type                 类型
 *  @param callBack             回调
 */
+ (void)fetchAllItems:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  取出所有二级记账科目(消费结算全要)
 *
 *  @param callBack             回调
 */
+ (void)fetchAllItems:(void(^)(CMLResponse *response))callBack;

/**
 *  取出某个分类下的所有二级记账科目
 *
 *  @param callBack             回调
 */
+ (void)fetchAllItemsInCategory:(NSString *)categoryID callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  新增完整记账科目
 *
 *  @param ItemName             二级科目名称
 *  @param ItemCategoryName     一级科目名称
 *  @param type                 账务类型
 *  @param callBack             回调
 */
+ (void)addItem:(NSString *)itemName inCategory:(NSString *)categoryName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  新增一级记账科目
 *
 *  @param ItemCategoryName     一级科目名称
 *  @param type                 账务类型
 *  @param callBack             回调
 */
+ (void)addItemCategory:(NSString *)itemCategoryName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  在一级科目下下新增二级科目
 *
 *  @param ItemName             二级科目名称
 *  @param categoryID           一级科目ID
 *  @param type                 账务类型
 *  @param callBack             回调
 */
+ (void)saveItem:(NSString *)itemName inCategory:(NSString *)categoryID type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  新增账务记录
 *
 *  @param item                 项目名称
 *  @param amount               项目金额
 *  @param happenTime           发生时间
 *  @param callBack             回调
 */
+ (void)addAccountingWithItem:(NSString *)itemID amount:(NSNumber *)amount type:(NSString *)type happneTime:(NSDate *)happenTime callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  删除账务记录
 *
 *  @param item                 账务
 *  @param callBack             回调
 */
+ (void)deleteAccounting:(CMLAccounting *)accounting callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  按日期分类查询某一月份的收支明细
 */
+ (void)fetchAccountingDetailsOnMonth:(NSDate *)date callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  按科目分类查询某一月份的收支明细
 */
+ (void)fetchAccountingDetailsOnItems:(NSDate *)date callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  根据CMLAccount对象获取账务名称
 */
+ (NSString *)getAccountingName:(CMLAccounting *)accounting;



@end
