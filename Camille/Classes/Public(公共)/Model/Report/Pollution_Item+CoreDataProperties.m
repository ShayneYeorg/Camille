//
//  Pollution_Item+CoreDataProperties.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Pollution_Item+CoreDataProperties.h"

@implementation Pollution_Item (CoreDataProperties)

+ (NSFetchRequest<Pollution_Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Pollution_Item"];
}

@dynamic year;
@dynamic month;
@dynamic day;
@dynamic itemID;

@end
