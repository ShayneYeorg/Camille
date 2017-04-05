//
//  Day_Summary+CoreDataClass.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Day_Summary : NSManagedObject

+ (void)getDaySummaryInYear:(NSString *)year month:(NSString *)month day:(NSString *)day autoUpdateIfNoRecord:(BOOL)autoUpdate callback:(void(^)(CMLResponse *response))callBack;

+ (void)updateDaySummaryInYear:(NSString *)year month:(NSString *)month day:(NSString *)day callback:(void(^)(CMLResponse *response))callBack;

@end

NS_ASSUME_NONNULL_END

#import "Day_Summary+CoreDataProperties.h"
