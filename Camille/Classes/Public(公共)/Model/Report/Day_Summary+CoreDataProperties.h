//
//  Day_Summary+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Day_Summary+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Day_Summary (CoreDataProperties)

+ (NSFetchRequest<Day_Summary *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, copy) NSString *month;
@property (nullable, nonatomic, copy) NSString *day;
@property (nullable, nonatomic, copy) NSNumber *income;
@property (nullable, nonatomic, copy) NSNumber *cost;

@end

NS_ASSUME_NONNULL_END
