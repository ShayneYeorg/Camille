//
//  Accounting+CoreDataProperties.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Accounting+CoreDataProperties.h"

@implementation Accounting (CoreDataProperties)

+ (NSFetchRequest<Accounting *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Accounting"];
}

@dynamic itemID;
@dynamic createTime;
@dynamic happenTime;
@dynamic accountingID;
@dynamic amount;
@dynamic happenDay;
@dynamic owner;
@dynamic desc;

@end
