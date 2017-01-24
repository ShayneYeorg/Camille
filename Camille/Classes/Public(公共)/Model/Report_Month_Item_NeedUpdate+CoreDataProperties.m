//
//  Report_Month_Item_NeedUpdate+CoreDataProperties.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Report_Month_Item_NeedUpdate+CoreDataProperties.h"

@implementation Report_Month_Item_NeedUpdate (CoreDataProperties)

+ (NSFetchRequest<Report_Month_Item_NeedUpdate *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Report_Month_Item_NeedUpdate"];
}

@dynamic year;
@dynamic month;
@dynamic itemID;

@end
