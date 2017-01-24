//
//  Item+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *itemID;
@property (nullable, nonatomic, copy) NSString *itemName;
@property (nullable, nonatomic, copy) NSString *itemType;
@property (nullable, nonatomic, copy) NSString *isAvailable;
@property (nonatomic, assign) int64_t useCount;

@end

NS_ASSUME_NONNULL_END
