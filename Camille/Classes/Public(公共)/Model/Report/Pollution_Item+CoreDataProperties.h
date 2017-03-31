//
//  Pollution_Item+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Pollution_Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Pollution_Item (CoreDataProperties)

+ (NSFetchRequest<Pollution_Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, copy) NSString *month;
@property (nullable, nonatomic, copy) NSString *day;
@property (nullable, nonatomic, copy) NSString *itemID;

@end

NS_ASSUME_NONNULL_END
