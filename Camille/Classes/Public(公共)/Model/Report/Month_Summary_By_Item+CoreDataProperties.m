//
//  Month_Summary_By_Item+CoreDataProperties.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Month_Summary_By_Item+CoreDataProperties.h"

@implementation Month_Summary_By_Item (CoreDataProperties)

+ (NSFetchRequest<Month_Summary_By_Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Month_Summary_By_Item"];
}

@dynamic year;
@dynamic month;
@dynamic itemID;
@dynamic amount;

@end
