//
//  Report_Month_Item+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Report_Month_Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Report_Month_Item (CoreDataProperties)

+ (NSFetchRequest<Report_Month_Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *itemID;
@property (nullable, nonatomic, copy) NSNumber *amount;
@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, copy) NSString *month;

@end

NS_ASSUME_NONNULL_END
