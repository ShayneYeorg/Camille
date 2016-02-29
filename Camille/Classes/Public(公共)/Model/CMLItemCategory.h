//
//  CMLItemCategory.h
//  Camille
//
//  Created by 杨淳引 on 16/2/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMLItemCategory : NSManagedObject

+ (NSMutableArray *)sortItemCategories:(NSMutableArray *)itemCategories;

@end

NS_ASSUME_NONNULL_END

#import "CMLItemCategory+CoreDataProperties.h"
