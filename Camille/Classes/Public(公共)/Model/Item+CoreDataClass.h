//
//  Item+CoreDataClass.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, Item_Fetch_Type) {
    Item_Fetch_All = 0,
    Item_Fetch_Income,
    Item_Fetch_Cost,
};

@interface Item : NSManagedObject


/**
 添加item

 @param itemName 要添加的item的名字
 @param type     要添加的item的类型
 @param callBack 回调
 */
+ (void)addItemWithName:(NSString *)itemName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack;


/**
 删除item

 @param item     要删除的item
 @param callBack 回调
 */
+ (void)deleteItem:(Item *)item callBack:(void(^)(CMLResponse *response))callBack;


/**
 查询item

 @param itemFetchType item类型
 @param callBack 回调
 */
+ (void)fetchItemsWithType:(Item_Fetch_Type)itemFetchType callBack:(void(^)(CMLResponse *response))callBack;



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


/**
 获得所有的收入item，数组已根据item的使用次数进行了排序

 @return 所有的收入item
 */
+ (NSMutableArray *)getAllIncomeItems;


/**
 获得所有的支出item，数组已根据item的使用次数进行了排序
 
 @return 所有的支出item
 */
+ (NSMutableArray *)getAllCostItems;


/**
 标识使用了某个item，会让item的使用次数加1

 @param itemID item的ID
 */
+ (void)itemUsed:(Item *)item;

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"



//测试数据
//    [Item addItemWithName:@"二" type:Item_Type_Cost callBack:^(CMLResponse * _Nonnull response) {
////        Item *i = response.responseDic[KEY_Item];
////        [Item deleteItem:i callBack:^(CMLResponse * _Nonnull response) {
////
////        }];
//    }];


