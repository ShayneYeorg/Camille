//
//  Month_Summary_By_Item+CoreDataClass.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Month_Summary_By_Item+CoreDataClass.h"
#import "Accounting+CoreDataClass.h"
#import "CMLDataManager.h"
#import "CMLTool+NSDate.h"

@implementation Month_Summary_By_Item

+ (void)getMonthItemSummaryInYear:(NSString *)year month:(NSString *)month autoUpdateIfNoRecord:(BOOL)autoUpdate callback:(void(^)(CMLResponse *response))callBack {
    if (!year.length || !month.length ) {
        CMLLog(@"查询MonthItemSummary时条件不足");
        callBack(nil);
        return;
    }
    
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Month_Summary_By_Item" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"year == '%@' AND month == '%@'", year, month];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    //查询
    NSError *error = nil;
    NSMutableArray *monthItemSummmaries = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (monthItemSummmaries == nil) {
        //查询过程中出错
        CMLLog(@"查询Month_Summary_By_Item出错:%@,%@",error,[error userInfo]);
        callBack(nil);
        
    } else if (monthItemSummmaries.count) {
        if (monthItemSummmaries.count == 1) {
            //正常
            CMLResponse *response = [CMLResponse new];
            response.code = RESPONSE_CODE_SUCCEED;
            response.desc = kTipFetchSuccess;
            response.responseDic = @{KEY_Month_Item_Summaries: monthItemSummmaries};
            callBack(response);
            
        } else {
            //数据重复，出问题了
            CMLLog(@"查询Month_Summary_By_Item数据重复，肯定有问题");
            callBack(nil);
        }
        
    } else {
        CMLLog(@"Month_Summary_By_Item查询无记录");
        if (autoUpdate) {
            [self updateMonthItemSummaryInYear:year month:month callback:callBack];
            
        } else {
            CMLResponse *response = [CMLResponse new];
            response.code = RESPONSE_CODE_NO_RECORD;
            response.desc = kTipFetchNoRecord;
            response.responseDic = nil;
            callBack(response);
        }
    }
}

//+ (void)_setDaySummaryInYear:(NSString *)year month:(NSString *)month income:(NSNumber *)income cost:(NSNumber *)cost callback:(void(^)(CMLResponse *response))callBack {
//    [self getDaySummaryInYear:year month:month day:day autoUpdateIfNoRecord:NO callback:^(CMLResponse * _Nonnull response) {
//        if (PHRASE_ResponseSuccess) {
//            NSArray *daySummaries = response.responseDic[KEY_Day_Summaries];
//            if (daySummaries.count) {
//                Day_Summary *ds = daySummaries.firstObject;
//                ds.income = income;
//                ds.cost = cost;
//                
//                CMLResponse *cmlResponse = [[CMLResponse alloc]init];
//                NSError *error = nil;
//                if ([kManagedObjectContext save:&error]) {
//                    CMLLog(@"保存Day_Summary成功：%@ %@ %@ cost %.2f income %.2f", year, month, day, cost.floatValue, income.floatValue);
//                    cmlResponse.code = RESPONSE_CODE_SUCCEED;
//                    cmlResponse.responseDic = @{KEY_Day_Summaries: @[ds]};
//                    callBack(cmlResponse);
//                    
//                } else {
//                    CMLLog(@"修改Day_Summary失败");
//                    callBack(nil);
//                }
//                
//            } else {
//                callBack(nil);
//            }
//            
//        } else if (PHRASE_ResponseNoRecord) {
//            //Entity
//            Day_Summary *ds = [NSEntityDescription insertNewObjectForEntityForName:@"Day_Summary" inManagedObjectContext:kManagedObjectContext];
//            ds.year = year;
//            ds.month = month;
//            ds.day = day;
//            ds.income = income;
//            ds.cost = cost;
//            
//            //保存
//            CMLResponse *cmlResponse = [[CMLResponse alloc]init];
//            NSError *error = nil;
//            if ([kManagedObjectContext save:&error]) {
//                cmlResponse.code = RESPONSE_CODE_SUCCEED;
//                cmlResponse.desc = kTipSaveSuccess;
//                cmlResponse.responseDic = @{KEY_Day_Summaries: @[ds]};
//                CMLLog(@"保存Day_Summary成功：%@ %@ %@ cost %.2f income %.2f", year, month, day, cost.floatValue, income.floatValue);
//                
//            } else {
//                CMLLog(@"保存Day_Summary发生错误:%@,%@", error, [error userInfo]);
//                cmlResponse.code = RESPONSE_CODE_FAILD;
//                cmlResponse.desc = kTipSaveFail;
//                cmlResponse.responseDic = nil;
//            }
//            
//            callBack(cmlResponse);
//            
//        } else {
//            callBack(nil);
//        }
//    }];
//}

+ (void)updateMonthItemSummaryInYear:(NSString *)year month:(NSString *)month callback:(void(^)(CMLResponse *response))callBack {
    NSDate *beginDate = [CMLTool getStartTimeInYear:year month:month];
    NSDate *endDate = [CMLTool getEndTimeInYear:year month:month];
    [Accounting fetchAccountingsFromDate:beginDate to:endDate callBack:^(CMLResponse * _Nonnull response) {
        if (PHRASE_ResponseSuccess) {
            NSArray *accountings = response.responseDic[KEY_Accountings];
            __block CGFloat income = 0;
            __block CGFloat cost = 0;
            if (accountings.count) {
                for (Accounting *a in accountings) {
                    [CMLDataManager itemTypeByItemID:a.itemID callback:^(NSString *itemType) {
                        if (itemType && [itemType isEqualToString:Item_Type_Cost]) {
                            cost += a.amount.floatValue;
                            
                        } else if (itemType && [itemType isEqualToString:Item_Type_Income]) {
                            income += a.amount.floatValue;
                        }
                    }];
                }
            }
//            [self _setDaySummaryInYear:year month:month income:[NSNumber numberWithFloat:income] cost:[NSNumber numberWithFloat:cost] callback:callBack];
            
        } else {
            callBack(nil);
        }
    }];
}

@end
