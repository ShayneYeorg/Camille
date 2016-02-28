//
//  CMLAccounting+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 16/2/28.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CMLAccounting.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLAccounting (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *happenTime;
@property (nullable, nonatomic, retain) NSDate *createTime;
@property (nullable, nonatomic, retain) NSString *item;
@property (nullable, nonatomic, retain) NSNumber *amount;

@end

NS_ASSUME_NONNULL_END
