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

@interface Item : NSManagedObject

/**
 判断某个item是否存在，查询的是缓存字典的数据

 @param itemID item的ID
 @return       void
 */
+ (BOOL)isItemIDExist:(NSString *)itemID;

/**
 从缓存字典里取出某个item
 
 @param itemID item的ID
 @return       void
 */
+ (NSString *)itemNameByItemID:(NSString *)itemID;

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
