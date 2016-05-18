//
//  CMLAccounting.h
//  Camille
//
//  Created by 杨淳引 on 16/2/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CMLRecordMonthDetailModel.h"
#import "CMLRecordItemDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMLAccounting : NSManagedObject

+ (CMLRecordMonthDetailModel *)sortAccountingsByDay:(NSArray *)accountings;
+ (CMLRecordItemDetailModel *)sortAccountingsByItem:(NSArray *)accountings;

@end

NS_ASSUME_NONNULL_END

#import "CMLAccounting+CoreDataProperties.h"
