//
//  Pollution_Item+CoreDataClass.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/31.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Pollution_Item+CoreDataClass.h"
#import "CMLTool+NSDate.h"

@implementation Pollution_Item

#pragma mark - Public

+ (void)setItemPolluted:(NSString *)itemID atDate:(NSDate *)date {
    @synchronized (self) {
        NSString *year = [CMLTool getYearFromDate:date];
        NSString *month = [CMLTool getMonthFromDate:date];
        NSString *day = [CMLTool getDayFromDate:date];
        
        //1、先判断Pollution_Item是否已存在
        //request和entity
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pollution_Item" inManagedObjectContext:kManagedObjectContext];
        [request setEntity:entity];
        
        //设置查询条件
        NSString *str = [NSString stringWithFormat:@"itemID == '%@' AND year == '%@' AND month == '%@' AND day == '%@'", itemID, year, month, day];
        NSPredicate *pre = [NSPredicate predicateWithFormat:str];
        [request setPredicate:pre];
        
        //2、查询
        NSError *error = nil;
        NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (items == nil) {
            //3、查询过程中出错
            CMLLog(@"查询Pollution_Item出错:%@,%@",error,[error userInfo]);
            
        } else if (items.count) {
            //4、查询发现Pollution_Item已存在
            //不需再做任何操作
            CMLLog(@"Pollution_Item已存在");
            
        } else {
            //5、查询发现Pollution_Item不存在，需要添加
            Pollution_Item *pollutionItem = [NSEntityDescription insertNewObjectForEntityForName:@"Pollution_Item" inManagedObjectContext:kManagedObjectContext];
            pollutionItem.itemID = itemID;
            pollutionItem.year = year;
            pollutionItem.month = month;
            pollutionItem.day = day;
            
            //保存
            NSError *error = nil;
            if ([kManagedObjectContext save:&error]) {
                if (error) {
                    CMLLog(@"添加Pollution_Item时发生错误:%@,%@",error,[error userInfo]);
                }
            }
        }
    }
}

+ (void)deleteItemPollutionInfo:(NSString *)itemID year:(NSString *)year month:(NSString *)month day:(NSString *)day {
    @synchronized (self) {
        [self getPollutedItemsByItemID:itemID year:year month:month day:day callback:^(CMLResponse * _Nonnull response) {
            if (PHRASE_ResponseSuccess) {
                NSArray *pollutionItems = response.responseDic[KEY_Pollution_Items];
                if (pollutionItems.count) {
                    for (Pollution_Item *pi in pollutionItems) {
                        [self deletePollutionItem:pi];
                    }
                }
            }
        }];
    }
}

+ (void)deletePollutionItem:(Pollution_Item *)pollutionItem {
    @synchronized (self) {
        [kManagedObjectContext deleteObject:pollutionItem];
        NSError *error = nil;
        if([kManagedObjectContext save:&error]) {
            CMLLog(@"删除Pollution_Item成功");
            
        } else {
            CMLLog(@"删除Pollution_Item失败");
        }
    }
}

+ (void)getPollutedItemsByItemID:(NSString *)itemID year:(NSString *)year month:(NSString *)month day:(NSString *)day callback:(void(^)(CMLResponse *response))callBack {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pollution_Item" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置查询条件
    NSMutableString *strM = [NSMutableString stringWithString:@"1 == 1"];
    if (itemID.length) {
        [strM appendFormat:@" AND itemID == '%@'", itemID];
    }
    if (year.length) {
        [strM appendFormat:@" AND year == '%@'", year];
    }
    if (month.length) {
        [strM appendFormat:@" AND month == '%@'", month];
    }
    if (day.length) {
        [strM appendFormat:@" AND day == '%@'", day];
    }
    CMLLog(@"%@", strM);
    NSPredicate *pre = [NSPredicate predicateWithFormat:strM];
    [request setPredicate:pre];
    
    //查询
    NSError *error = nil;
    NSMutableArray *pollutionItems = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (pollutionItems == nil) {
        //查询过程中出错
        CMLLog(@"查询Pollution_Item出错:%@,%@",error,[error userInfo]);
        CMLLog(@"当做Pollution_Item查询无记录处理");
        CMLResponse *response = [CMLResponse new];
        response.code = RESPONSE_CODE_NO_RECORD;
        response.desc = kTipFetchNoRecord;
        response.responseDic = nil;
        callBack(response);
        
    } else if (pollutionItems.count) {
        CMLLog(@"Pollution_Item的个数是：%zd", pollutionItems.count);
        CMLResponse *response = [CMLResponse new];
        response.code = RESPONSE_CODE_SUCCEED;
        response.desc = kTipFetchSuccess;
        response.responseDic = @{KEY_Pollution_Items: pollutionItems};
        callBack(response);
        
    } else {
        CMLLog(@"Pollution_Item查询无记录");
        CMLResponse *response = [CMLResponse new];
        response.code = RESPONSE_CODE_NO_RECORD;
        response.desc = kTipFetchNoRecord;
        response.responseDic = nil;
        callBack(response);
    }
}

@end
