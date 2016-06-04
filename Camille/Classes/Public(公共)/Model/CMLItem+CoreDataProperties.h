//
//  CMLItem+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 16/2/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//
//  二级科目

#import "CMLItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *itemName; //二级科目名称
@property (nullable, nonatomic, retain) NSString *itemID; //二级科目ID
@property (nullable, nonatomic, retain) NSString *itemType; //二级科目类型
@property (nullable, nonatomic, retain) NSString *nextItemID; //下一个二级科目
@property (nullable, nonatomic, retain) NSString *categoryID; //所属一级科目
@property (nullable, nonatomic, retain) NSString *isAvailable; //科目是否有效

@end

NS_ASSUME_NONNULL_END
