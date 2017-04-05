//
//  CMLTool+NSDate.h
//  Camille
//
//  Created by 杨淳引 on 16/3/22.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLTool.h"

@interface CMLTool (NSDate)

+ (NSDate *)dateWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

+ (NSDate *)transStringToDate:(NSString *)dateStr;
+ (NSString *)transDateToString:(NSDate *)date;
+ (NSString *)transDateToYMString:(NSDate *)date;

+ (NSDate *)getFirstDateInMonth:(NSDate *)date;
+ (NSDate *)getLastDateInMonth:(NSDate *)date;
+ (NSDate *)getFirstDateInNextMonth:(NSDate *)date;

+ (NSDate *)getStartTimeAtDate:(NSDate *)date;
+ (NSDate *)getEndTimeAtDate:(NSDate *)date;
+ (NSDate *)getNextDateStartTimeAtDate:(NSDate *)date;

+ (NSString *)getYearFromDate:(NSDate *)date;
+ (NSString *)getMonthFromDate:(NSDate *)date;
+ (NSString *)getDayFromDate:(NSDate *)date;

+ (BOOL)isDate:(NSDate *)date1 equalsToDate:(NSDate *)date2;

@end
