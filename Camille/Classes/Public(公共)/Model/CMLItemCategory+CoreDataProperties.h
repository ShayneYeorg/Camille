//
//  CMLItemCategory+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 16/2/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//
//  一级科目

#import "CMLItemCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLItemCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *categoryName; //一级科目名称
@property (nullable, nonatomic, retain) NSString *categoryID; //一级科目ID
@property (nullable, nonatomic, retain) NSString *categoryType; //一级科目类型
@property (nullable, nonatomic, retain) NSString *nextCategoryID; //下一个科目的ID

@end

NS_ASSUME_NONNULL_END
