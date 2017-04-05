//
//  CMLReportManager.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLReportManager.h"
#import "CMLTool+NSDate.h"
#import "Pollution_Item+CoreDataClass.h"
#import "Day_Summary+CoreDataClass.h"

@implementation CMLReportManager

#pragma mark - Month Item Summary

+ (void)fetchMonthItemSummaryInYear:(NSString *)year month:(NSString *)month callback:(void(^)(CMLResponse *response))callBack {
    
}

+ (void)fetchMonthItemSummaryWithDate:(NSDate *)date callback:(void(^)(CMLResponse *response))callBack {
    NSString *year = [CMLTool getYearFromDate:date];
    NSString *month = [CMLTool getMonthFromDate:date];
    [self fetchMonthItemSummaryInYear:year month:month callback:callBack];
}


#pragma mark - Month Summary

+ (void)_fetchMonthSummaryInYear:(NSString *)year month:(NSString *)month callback:(void(^)(CMLResponse *response))callBack {
    
}

+ (void)_fetchMonthSummaryWithDate:(NSDate *)date callback:(void(^)(CMLResponse *response))callBack {
    NSString *year = [CMLTool getYearFromDate:date];
    NSString *month = [CMLTool getMonthFromDate:date];
    [self _fetchMonthSummaryInYear:year month:month callback:callBack];
}


#pragma mark - Day Summary

+ (void)fetchDaySummaryInYear:(NSString *)year month:(NSString *)month day:(NSString *)day callback:(void(^)(CMLResponse *response))callBack {
    //1、判断当日内有没有污染item
    [self _getPollutedItemsByItemID:nil year:year month:month day:day callback:^(CMLResponse *response) {
        if (PHRASE_ResponseNoRecord) {
            //2、无污染item则直接取当日的数据返回
            [Day_Summary getDaySummaryInYear:year month:month day:day autoUpdateIfNoRecord:YES callback:callBack];
            
        } else if (PHRASE_ResponseSuccess) {
            //3、有污染item则先更新当日的数据，再查询返回
            [self _updateDaySummaryInYear:year month:month day:day callback:callBack];
            
        } else {
            //4、出错则返回nil
            callBack(nil);
        }
    }];
}

+ (void)fetchDaySummaryWithDate:(NSDate *)date callback:(void(^)(CMLResponse *response))callBack {
    NSString *year = [CMLTool getYearFromDate:date];
    NSString *month = [CMLTool getMonthFromDate:date];
    NSString *day = [CMLTool getDayFromDate:date];
    [self fetchDaySummaryInYear:year month:month day:day callback:callBack];
}

#pragma mark - Item Pollution

+ (void)setItemPolluted:(NSString *)itemID atDate:(NSDate *)date {
    [Pollution_Item setItemPolluted:itemID atDate:date];
}

+ (void)_deleteItemPollutionInfo:(NSString *)itemID year:(NSString *)year month:(NSString *)month day:(NSString *)day {
    [Pollution_Item deleteItemPollutionInfo:itemID year:year month:month day:day];
}






//+ (void)_updateWithCallback:(void(^)(CMLResponse *response))callBack {
//    
//    
//    
//}

+ (void)_updateMonthItemSummaryOnItem:(NSString *)itemID inYear:(NSString *)year month:(NSString *)month callback:(void(^)(CMLResponse *response))callBack {
    //先update本月的MonthSummary，再update本月的MonthItemSummary
    
    
}

+ (void)_updateMonthSummaryInYear:(NSString *)year month:(NSString *)month callback:(void(^)(CMLResponse *response))callBack {
    //先update本月内的所有DaySummary，然后在update本月的MonthSummary
    
    
}

+ (void)_updateDaySummaryInYear:(NSString *)year month:(NSString *)month day:(NSString *)day callback:(void(^)(CMLResponse *response))callBack {
    [Day_Summary updateDaySummaryInYear:year month:month day:day callback:callBack];
}




+ (void)_getPollutedItemsByItemID:(NSString *)itemID year:(NSString *)year month:(NSString *)month day:(NSString *)day callback:(void(^)(CMLResponse *response))callBack {
    [Pollution_Item getPollutedItemsByItemID:itemID year:year month:month day:day callback:callBack];
}

+ (void)_getPollutedItemsByItemID:(NSString *)itemID year:(NSString *)year month:(NSString *)month callback:(void(^)(CMLResponse *response))callBack {
    [self _getPollutedItemsByItemID:itemID year:year month:month day:nil callback:callBack];
}

+ (void)_getPollutedItemsByItemID:(NSString *)itemID year:(NSString *)year callback:(void(^)(CMLResponse *response))callBack {
    [self _getPollutedItemsByItemID:itemID year:year month:nil callback:callBack];
}

@end
