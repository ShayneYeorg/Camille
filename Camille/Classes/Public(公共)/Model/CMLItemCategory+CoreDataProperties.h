//
//  CMLItemCategory+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 16/2/28.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//
//  记账项目表

#import "CMLItemCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLItemCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *category; //一级记账科目
@property (nullable, nonatomic, retain) NSString *item; //二级记账科目

@end

NS_ASSUME_NONNULL_END
