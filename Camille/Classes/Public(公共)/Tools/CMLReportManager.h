//
//  CMLReportManager.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMLReportManager : NSObject

+ (void)fetchMonthItemSummaryInYear:(NSString *)year month:(NSString *)month callback:(void(^)(CMLResponse *response))callBack;

+ (void)fetchMonthItemSummaryWithDate:(NSDate *)date callback:(void(^)(CMLResponse *response))callBack;


+ (void)fetchDaySummaryInYear:(NSString *)year month:(NSString *)month day:(NSString *)day callback:(void(^)(CMLResponse *response))callBack;

+ (void)fetchDaySummaryWithDate:(NSDate *)date callback:(void(^)(CMLResponse *response))callBack;


+ (void)setItemPolluted:(NSString *)itemID atDate:(NSDate *)date;

@end
