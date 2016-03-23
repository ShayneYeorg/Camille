//
//  CMLTool+NSDate.m
//  Camille
//
//  Created by 杨淳引 on 16/3/22.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLTool+NSDate.h"

@implementation CMLTool (NSDate)

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

//获取当月结束时间
+ (NSDate *)getLastDateInMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmp = [calendar components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    [cmp setMonth:[cmp month] + 1];
    NSDate *nextMonFirstDate = [calendar dateFromComponents:cmp];
    
    return nextMonFirstDate;
}

@end
