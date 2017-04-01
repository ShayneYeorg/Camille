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






+ (void)_updateWithCallback:(void(^)(CMLResponse *response))callBack {
    
    
    
}

+ (void)_updateMonthItemSummaryOnItem:(NSString *)itemID inYear:(NSString *)year month:(NSString *)month callback:(void(^)(CMLResponse *response))callBack {
    
    
    
}

+ (void)_updateMonthSummaryInYear:(NSString *)year month:(NSString *)month callback:(void(^)(CMLResponse *response))callBack {
    
    
    
}

+ (void)_updateDaySummaryInYear:(NSString *)year month:(NSString *)month day:(NSString *)day callback:(void(^)(CMLResponse *response))callBack {
    
    
    
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
