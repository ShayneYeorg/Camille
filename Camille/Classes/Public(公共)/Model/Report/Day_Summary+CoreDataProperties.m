//
//  Day_Summary+CoreDataProperties.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Day_Summary+CoreDataProperties.h"

@implementation Day_Summary (CoreDataProperties)

+ (NSFetchRequest<Day_Summary *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Day_Summary"];
}

@dynamic year;
@dynamic month;
@dynamic day;
@dynamic income;
@dynamic cost;

@end
