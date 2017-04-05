//
//  CMLTool+NSDate.m
//  Camille
//
//  Created by 杨淳引 on 16/3/22.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLTool+NSDate.h"

@implementation CMLTool (NSDate)

+ (NSDate *)dateWithYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@", year, month.length == 2? month: [NSString stringWithFormat:@"0%@", month], day.length == 2? day: [NSString stringWithFormat:@"0%@", day]];
    NSDate *date = [self transStringToDate:dateStr];
    return date;
}

+ (NSDate *)transStringToDate:(NSString *)dateStr {
    NSDateFormatter *fmt = [CMLTool formatterInit];
    NSDate *date = [fmt dateFromString:dateStr];
    return date;
}

//将NSDate转化为短日期格式的日期NSString对象
+ (NSString *)transDateToString:(NSDate *)date {
    NSDateFormatter *fmt = [CMLTool formatterInit];
    NSString *dateStr = [fmt stringFromDate:date];
    return dateStr;
}

//短日期的格式，只有年月日
+ (NSDateFormatter *)formatterInit {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterMediumStyle];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    [fmt setDateFormat:@"YYYY-MM-dd"];
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [fmt setTimeZone:timeZone];
    return fmt;
}

//将NSDate转化为只有年月的短日期格式的日期NSString对象
+ (NSString *)transDateToYMString:(NSDate *)date {
    NSDateFormatter *fmt = [CMLTool formatterYMInit];
    NSString *dateStr = [fmt stringFromDate:date];
    return dateStr;
}

//短日期的格式，只有年月
+ (NSDateFormatter *)formatterYMInit {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateStyle:NSDateFormatterMediumStyle];
    [fmt setTimeStyle:NSDateFormatterShortStyle];
    [fmt setDateFormat:@"YYYY年M月"];
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [fmt setTimeZone:timeZone];
    return fmt;
}

//获取当月开始时间
+ (NSDate *)getFirstDateInMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    [cmp setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:cmp];
    
    return firstDate;
}

//获取本月结束时间(只有年月日，具体时间不准)
+ (NSDate *)getLastDateInMonth:(NSDate *)date {
    NSDate *nextMonFirstDate = [self getFirstDateInNextMonth:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit fromDate:nextMonFirstDate];
    [cmp setDay:[cmp day] - 1];
    NSDate *lastDate = [calendar dateFromComponents:cmp];
    
    return lastDate;
}

//获取下月开始时间
+ (NSDate *)getFirstDateInNextMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    [cmp setMonth:[cmp month] + 1];
    NSDate *nextMonFirstDate = [calendar dateFromComponents:cmp];
    
    return nextMonFirstDate;
}

+ (NSDate *)getStartTimeAtDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    [cmp setHour:0];
    [cmp setMinute:0];
    [cmp setSecond:0];
    NSDate *startTime = [calendar dateFromComponents:cmp];
    
    return startTime;
}

+ (NSDate *)getEndTimeAtDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    [cmp setHour:23];
    [cmp setMinute:59];
    [cmp setSecond:59];
    NSDate *endTime = [calendar dateFromComponents:cmp];
    
    return endTime;
}

+ (NSDate *)getNextDateStartTimeAtDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    [cmp setDay:[cmp day] + 1];
    [cmp setHour:0];
    [cmp setMinute:0];
    [cmp setSecond:0];
    NSDate *nextDayStartTime = [calendar dateFromComponents:cmp];
    
    return nextDayStartTime;
}

+ (NSString *)getYearFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitYear fromDate:date];
    NSString *year = [NSString stringWithFormat:@"%zd", cmp.year];
    return year;
}

+ (NSString *)getMonthFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitMonth fromDate:date];
    NSString *month = [NSString stringWithFormat:@"%zd", cmp.month];
    return month;
}

//取出一个NSDate里的day
+ (NSString *)getDayFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSCalendarUnitDay fromDate:date];
    NSString *day = [NSString stringWithFormat:@"%zd", cmp.day];
    return day;
}

//判断两个日期是否是同一天
+ (BOOL)isDate:(NSDate *)date1 equalsToDate:(NSDate *)date2 {
    NSString *strDate1 = [self transDateToString:date1];
    NSString *strDate2 = [self transDateToString:date2];
    
    if ([strDate1 isEqualToString:strDate2]) {
        return YES;
    }
    
    return NO;
}

@end
