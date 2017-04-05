//
//  Pollution_Item+CoreDataClass.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Pollution_Item : NSManagedObject

+ (void)setItemPolluted:(NSString *)itemID atDate:(NSDate *)date;

+ (void)deleteItemPollutionInfo:(NSString *)itemID year:(NSString *)year month:(NSString *)month day:(NSString *)day;

+ (void)deletePollutionItem:(Pollution_Item *)pollutionItem;

+ (void)getPollutedItemsByItemID:(NSString *)itemID year:(NSString *)year month:(NSString *)month day:(NSString *)day callback:(void(^)(CMLResponse *response))callBack;

@end


#import "Pollution_Item+CoreDataProperties.h"



//    [CMLReportManager setItemPolluted:@"123" atDate:[CMLTool getFirstDateInMonth:[NSDate date]]];
//    [CMLReportManager setItemPolluted:@"123" atDate:[CMLTool getLastDateInMonth:[NSDate date]]];

//    [CMLReportManager _deleteItemPollutionInfo:@"123" year:@"2017" month:@"4" day:nil];

//[Pollution_Item getPollutedItemsByItemID:nil year:nil month:nil day:nil callback:^(CMLResponse * _Nonnull response) {
//    
//}];
