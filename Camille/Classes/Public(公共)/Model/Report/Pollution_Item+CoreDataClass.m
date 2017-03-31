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

@end
