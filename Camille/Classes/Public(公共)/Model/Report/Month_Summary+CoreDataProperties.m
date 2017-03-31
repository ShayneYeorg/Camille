//
//  Month_Summary+CoreDataProperties.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Month_Summary+CoreDataProperties.h"

@implementation Month_Summary (CoreDataProperties)

+ (NSFetchRequest<Month_Summary *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Month_Summary"];
}

@dynamic year;
@dynamic month;
@dynamic income;
@dynamic cost;

@end
