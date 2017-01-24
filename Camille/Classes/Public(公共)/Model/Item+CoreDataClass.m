//
//  Item+CoreDataClass.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Item+CoreDataClass.h"

static NSDictionary *itemsDictionary;

@implementation Item

#pragma mark - 添加item

+ (void)addItem:(NSString *)itemName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
    //1、先判断itemName是否存在
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"itemName == '%@' AND itemType == '%@'", itemName, type];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    //Response
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
    
    //2、查询
    NSError *error = nil;
    NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (items == nil) {
        //3、查询过程中出错
        CMLLog(@"查询item出错:%@,%@",error,[error userInfo]);
        callBack(nil);
        
    } else if (items.count) {
        //4、查询发现item已存在
        Item *theExistItem = items[0];
        
        if (theExistItem) {
            if ([theExistItem.isAvailable isEqualToString:Record_Available]) {
                //查询对象是有效的
                cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:theExistItem.itemID, KEY_ItemID, theExistItem, KEY_Item,  nil];
                cmlResponse.code = RESPONSE_CODE_FAILD;
                cmlResponse.desc = kTipExist;
                callBack(cmlResponse);
                
            } else {
                //查询对象之前被删除过，将它复原即可
                [self restoreItem:theExistItem callBack:^(CMLResponse *response) {
                    if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
                        cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:theExistItem.itemID, KEY_ItemID, theExistItem, KEY_Item,  nil];
                        cmlResponse.code = RESPONSE_CODE_SUCCEED;
                        cmlResponse.desc = kTipRestore;
                        callBack(cmlResponse);
                        
                    } else {
                        callBack(nil);
                    }
                }];
            }
            
        } else {
            callBack(nil);
        }
        
    } else {
        //5、查询发现item不存在，需要添加
        NSString *newID = [self createNewItemIDWithItemType:type];
        if (newID == nil) {
            CMLLog(@"分配itemID时出错");
            callBack(nil);
            
        } else {
            //Entity
            Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:kManagedObjectContext];
            item.itemName = itemName;
            item.itemID = newID;
            item.itemType = type;
            item.isAvailable = Record_Available;
            
            //保存
            NSError *error = nil;
            if ([kManagedObjectContext save:&error]) {
                if (error) {
                    CMLLog(@"添加item时发生错误:%@,%@",error,[error userInfo]);
                    callBack(nil);
                    
                } else {
                    cmlResponse.code = RESPONSE_CODE_SUCCEED;
                    cmlResponse.desc = kTipSaveSuccess;
                    CMLLog(@"新增item成功");
                    cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:item, KEY_Item, nil];
                    callBack(cmlResponse);
                }
                
            } else {
                callBack(nil);
            }
        }
    }
}

//复原item
+ (void)restoreItem:(Item *)item callBack:(void(^)(CMLResponse *response))callBack {
    item.isAvailable = Record_Available;
    CMLResponse *response = [[CMLResponse alloc]init];
    NSError *error = nil;
    if ([kManagedObjectContext save:&error]) {
        CMLLog(@"复原item成功");
        response.code = RESPONSE_CODE_SUCCEED;
        callBack(response);
        
    } else {
        CMLLog(@"复原item失败");
        callBack(nil);
    }
}

//为新item创建ID
+ (NSString *)createNewItemIDWithItemType:(NSString *)itemType {
    //为二级记账科目分配一个ID（使用当前时间的年月日时分秒组成）
    NSString *newID;
    
    //检查新分配ID在当前一级科目下是否有重名，有则重新分配，直到没有重名为止
    @try {
        do {
            newID = [self createANewItemID];
            
        } while (![self verifyItemID:newID]);
        
    } @catch (NSException *exception) {
        return nil;
    }
    
    //返回新分配的二级科目ID
    return newID;
}

//为新item创建ID
+ (NSString *)createANewItemID {
    //用当前时间做ID
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"YYYYMMddHHmmss"];
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [fmt setTimeZone:timeZone];
    NSString *newID = [fmt stringFromDate:now];
    return newID;
}

//校验新ID
+ (BOOL)verifyItemID:(NSString *)newID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    NSString *str = [NSString stringWithFormat:@"itemID == '%@'", newID];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    NSError *error = nil;
    NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!error && !items.count) {
        return YES;
        
    } else {
        return NO;
    }
}

#pragma mark - 删除item



@end
