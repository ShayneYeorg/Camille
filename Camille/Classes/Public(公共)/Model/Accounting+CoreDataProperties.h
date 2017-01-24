//
//  Accounting+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Accounting+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Accounting (CoreDataProperties)

+ (NSFetchRequest<Accounting *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *itemID;
@property (nullable, nonatomic, copy) NSDate *createTime;
@property (nullable, nonatomic, copy) NSDate *happenTime;
@property (nullable, nonatomic, copy) NSString *accountingID;
@property (nullable, nonatomic, copy) NSNumber *amount;
@property (nullable, nonatomic, copy) NSString *happenDay;
@property (nullable, nonatomic, copy) NSString *owner;
@property (nullable, nonatomic, copy) NSString *desc;

@end

NS_ASSUME_NONNULL_END
