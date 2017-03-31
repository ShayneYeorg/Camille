//
//  Month_Summary_By_Item+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Month_Summary_By_Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Month_Summary_By_Item (CoreDataProperties)

+ (NSFetchRequest<Month_Summary_By_Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, copy) NSString *month;
@property (nullable, nonatomic, copy) NSString *itemID;
@property (nullable, nonatomic, copy) NSNumber *amount;

@end

NS_ASSUME_NONNULL_END
