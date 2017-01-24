//
//  Report_Month_Item_NeedUpdate+CoreDataProperties.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Report_Month_Item_NeedUpdate+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Report_Month_Item_NeedUpdate (CoreDataProperties)

+ (NSFetchRequest<Report_Month_Item_NeedUpdate *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *year;
@property (nullable, nonatomic, copy) NSString *month;
@property (nullable, nonatomic, copy) NSString *itemID;

@end

NS_ASSUME_NONNULL_END
