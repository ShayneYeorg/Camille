//
//  CMLAccounting+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 16/2/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//
//  账务

#import "CMLAccounting.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLAccounting (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount; //金额
@property (nullable, nonatomic, retain) NSDate *createTime; //创建时间
@property (nullable, nonatomic, retain) NSDate *happenTime;  //发生时间
@property (nullable, nonatomic, retain) NSString *happenDay; //发生时间的day
@property (nullable, nonatomic, retain) NSString *itemID; //科目ID
@property (nullable, nonatomic, retain) NSString *type; //科目类型

//不存进数据库
@property (nullable, nonatomic, retain) NSString *name; //科目名称

@end

NS_ASSUME_NONNULL_END
