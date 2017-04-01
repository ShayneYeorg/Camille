//
//  CMLTool+NSDate.h
//  Camille
//
//  Created by 杨淳引 on 16/3/22.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLTool.h"

@interface CMLTool (NSDate)

+ (NSString *)transDateToString:(NSDate *)date;
+ (NSString *)transDateToYMString:(NSDate *)date;

+ (NSDate *)getFirstDateInMonth:(NSDate *)date;
+ (NSDate *)getLastDateInMonth:(NSDate *)date;
+ (NSDate *)getFirstDateInNextMonth:(NSDate *)date;

+ (NSString *)getYearFromDate:(NSDate *)date;
+ (NSString *)getMonthFromDate:(NSDate *)date;
+ (NSString *)getDayFromDate:(NSDate *)date;

+ (BOOL)isDate:(NSDate *)date1 equalsToDate:(NSDate *)date2;

@end
