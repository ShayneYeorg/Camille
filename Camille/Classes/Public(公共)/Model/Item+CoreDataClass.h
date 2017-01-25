//
//  Item+CoreDataClass.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSInteger, Item_Fetch_Type) {
    Item_Fetch_All = 0,
    Item_Fetch_Income,
    Item_Fetch_Cost,
};

@interface Item : NSManagedObject

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END

//由于这个方法可传nil，所以放在NONULL编译块的外面
/**
 修改某个item，参数传nil则表示此字段不改动
 
 @param item 要修改的item
 @param itemName 修改后的itemName
 @param itemType 修改后的itemType
 @param callBack 回调
 */
+ (void)alterItem:(Item * _Nonnull)item itemName:(NSString * _Nullable)itemName itemType:(NSString * _Nullable)itemType callback:(void(^_Nullable)(CMLResponse * _Nullable response))callBack;

@end

#import "Item+CoreDataProperties.h"



//测试数据
//    [Item addItemWithName:@"二" type:Item_Type_Cost callBack:^(CMLResponse * _Nonnull response) {
////        Item *i = response.responseDic[KEY_Item];
////        [Item deleteItem:i callBack:^(CMLResponse * _Nonnull response) {
////
////        }];
//    }];



//NSString *itemName = [Item itemNameByItemID:@"20170125125913"];
//NSString *itemType = [Item itemTypeByItemID:@"20170125125913"];
//NSArray *arr1 = [Item getAllIncomeItems];
//NSArray *arr2 = [Item getAllCostItems];
//
//Item *i = arr1[1];
//[Item itemUsed:i];
//
//NSArray *arr22 = [Item getAllCostItems];
//NSArray *arr21 = [Item getAllIncomeItems];
//
//CMLLog(@"finish");



//NSArray *arr1 = [Item getAllIncomeItems];
//Item *i = arr1[1];
//CMLLog(@"%@", i.itemName);
//CMLLog(@"%@", i.itemType);
//
//[Item alterItem:i itemName:nil itemType:Item_Type_Cost callback:^(CMLResponse * _Nullable response) {
//    NSArray *arr2 = [Item getAllIncomeItems];
//    Item *i = arr2[1];
//    CMLLog(@"%@", i.itemName);
//    CMLLog(@"%@", i.itemType);
//}];



