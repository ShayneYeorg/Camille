//
//  Report_Month_Item+CoreDataProperties.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Report_Month_Item+CoreDataProperties.h"

@implementation Report_Month_Item (CoreDataProperties)

+ (NSFetchRequest<Report_Month_Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Report_Month_Item"];
}

@dynamic itemID;
@dynamic amount;
@dynamic year;
@dynamic month;

@end
