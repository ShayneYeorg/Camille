//
//  Item+CoreDataClass.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Item+CoreDataClass.h"

//缓存
//static BOOL needUpdate; //以下这4个容器类对象的内容是否过期，由needUpdate来标识
//static NSMutableDictionary *itemNameMapper; //key为itemID，value为itemName
//static NSMutableDictionary *itemTypeMapper; //key为itemID，value为itemType
//static NSMutableArray *incomeItems; //存放所有的收入item
//static NSMutableArray *costItems; //存放所有的支出item

@implementation Item

#pragma mark - Life Cycle

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        needUpdate = YES;
//        itemNameMapper = [NSMutableDictionary dictionary];
//        itemTypeMapper = [NSMutableDictionary dictionary];
//        incomeItems = [NSMutableArray array];
//        costItems = [NSMutableArray array];
//    });
//}

#pragma mark - Pubilc

//+ (NSString *)itemNameByItemID:(NSString *)itemID {
//    static dispatch_once_t onceToken;
//    static dispatch_semaphore_t lock;
//    dispatch_once(&onceToken, ^{
//        lock = dispatch_semaphore_create(1);
//    });
//    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
//    if ([self _needUpdate]) {
//        [self _update];
//    }
//    dispatch_semaphore_signal(lock);
//    
//    return itemNameMapper[itemID];
//}
//
//+ (NSString *)itemTypeByItemID:(NSString *)itemID {
//    static dispatch_once_t onceToken;
//    static dispatch_semaphore_t lock;
//    dispatch_once(&onceToken, ^{
//        lock = dispatch_semaphore_create(1);
//    });
//    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
//    if ([self _needUpdate]) {
//        [self _update];
//    }
//    dispatch_semaphore_signal(lock);
//    
//    return itemTypeMapper[itemID];
//}
//
//+ (NSMutableArray *)getAllIncomeItems {
//    static dispatch_once_t onceToken;
//    static dispatch_semaphore_t lock;
//    dispatch_once(&onceToken, ^{
//        lock = dispatch_semaphore_create(1);
//    });
//    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
//    if ([self _needUpdate]) {
//        [self _update];
//    }
//    dispatch_semaphore_signal(lock);
//    
//    return incomeItems;
//}
//
//+ (NSMutableArray *)getAllCostItems {
//    static dispatch_once_t onceToken;
//    static dispatch_semaphore_t lock;
//    dispatch_once(&onceToken, ^{
//        lock = dispatch_semaphore_create(1);
//    });
//    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
//    if ([self _needUpdate]) {
//        [self _update];
//    }
//    dispatch_semaphore_signal(lock);
//    
//    return costItems;
//}

+ (void)itemUsed:(Item *)item {
    item.useCount += 1;
    NSError *error = nil;
    if ([kManagedObjectContext save:&error]) {
        CMLLog(@"更新item的useCount成功");
        
    } else {
        CMLLog(@"更新item的useCount失败");
    }
//    [self _setNeedUpdate];
}

#pragma mark - 数据状态管理

//+ (void)_setNeedUpdate {
//    needUpdate = YES;
//}
//
//+ (BOOL)_needUpdate {
//    return needUpdate;
//}

//+ (void)_update {
//    __weak typeof(self) weakSelf = self;
//    
//    [self fetchItemsWithType:Item_Fetch_Income callBack:^(CMLResponse * _Nonnull response) {
//        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
//            if ([response.responseDic[KEY_Items] isKindOfClass:[NSArray class]]) {
//                [incomeItems removeAllObjects];
//                [incomeItems addObjectsFromArray:response.responseDic[KEY_Items]];
//                for (Item *i in incomeItems) {
//                    [weakSelf _updateItemNameMapperWithKey:i.itemID value:i.itemName];
//                    [weakSelf _updateItemTypeMapperWithKey:i.itemID value:i.itemType];
//                }
//            }
//        }
//    }];
//    
//    [self fetchItemsWithType:Item_Fetch_Cost callBack:^(CMLResponse * _Nonnull response) {
//        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
//            if ([response.responseDic[KEY_Items] isKindOfClass:[NSArray class]]) {
//                [costItems removeAllObjects];
//                [costItems addObjectsFromArray:response.responseDic[KEY_Items]];
//                for (Item *i in costItems) {
//                    [weakSelf _updateItemNameMapperWithKey:i.itemID value:i.itemName];
//                    [weakSelf _updateItemTypeMapperWithKey:i.itemID value:i.itemType];
//                }
//            }
//        }
//    }];
//    
//    needUpdate = NO;
//}

//+ (void)_updateItemNameMapperWithKey:(NSString *)key value:(NSString *)value {
//    static dispatch_once_t onceToken;
//    static dispatch_semaphore_t lock;
//    dispatch_once(&onceToken, ^{
//        lock = dispatch_semaphore_create(1);
//    });
//    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
//    [itemNameMapper setValue:value forKey:key];
//    dispatch_semaphore_signal(lock);
//}
//
//+ (void)_updateItemTypeMapperWithKey:(NSString *)key value:(NSString *)value {
//    static dispatch_once_t onceToken;
//    static dispatch_semaphore_t lock;
//    dispatch_once(&onceToken, ^{
//        lock = dispatch_semaphore_create(1);
//    });
//    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
//    [itemTypeMapper setValue:value forKey:key];
//    dispatch_semaphore_signal(lock);
//}

#pragma mark - 添加item

+ (void)addItemWithName:(NSString *)itemName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
    @synchronized (self) {
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
                    CMLLog(@"添加的item已存在并且是有效的");
                    cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:theExistItem.itemID, KEY_ItemID, theExistItem, KEY_Item,  nil];
                    cmlResponse.code = RESPONSE_CODE_FAILD;
                    cmlResponse.desc = kTipExist;
                    callBack(cmlResponse);
                    
                } else {
                    //查询对象之前被删除过，将它复原即可
                    CMLLog(@"添加的item被删除过，只需复原即可");
                    [self restoreItem:theExistItem callBack:^(CMLResponse *response) {
                        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
                            cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:theExistItem.itemID, KEY_ItemID, theExistItem, KEY_Item,  nil];
                            cmlResponse.code = RESPONSE_CODE_SUCCEED;
                            cmlResponse.desc = kTipRestore;
                            //                        [self _setNeedUpdate];
                            callBack(cmlResponse);
                            
                        } else {
                            //                        [self _setNeedUpdate];
                            callBack(nil);
                        }
                    }];
                }
                
            } else {
                callBack(nil);
            }
            
        } else {
            //5、查询发现item不存在，需要添加
            NSString *newID = [self createNewItemID];
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
                item.useCount = 0;
                
                //保存
                NSError *error = nil;
                if ([kManagedObjectContext save:&error]) {
                    if (error) {
                        CMLLog(@"添加item时发生错误:%@,%@",error,[error userInfo]);
                        //                    [self _setNeedUpdate];
                        callBack(nil);
                        
                    } else {
                        cmlResponse.code = RESPONSE_CODE_SUCCEED;
                        cmlResponse.desc = kTipSaveSuccess;
                        CMLLog(@"新增item(%@)成功", itemName);
                        cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:item, KEY_Item, nil];
                        //                    [self _setNeedUpdate];
                        callBack(cmlResponse);
                    }
                    
                } else {
                    //                [self _setNeedUpdate];
                    callBack(nil);
                }
            }
        }
    }
}

//复原item
+ (void)restoreItem:(Item *)item callBack:(void(^)(CMLResponse *response))callBack {
    @synchronized (self) {
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
}

//为新item创建ID
+ (NSString *)createNewItemID {
    //分配一个ID并检查新分配ID在当前一级科目下是否有重名，有则返回nil
    NSString *newID = [self createANewItemID];
    if (![self verifyItemID:newID]) {
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

+ (void)deleteItem:(Item *)item callBack:(void(^)(CMLResponse *response))callBack {
    @synchronized (self) {
        item.isAvailable = Record_Unavailable;
        CMLResponse *response = [[CMLResponse alloc]init];
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) {
            CMLLog(@"删除item成功");
            response.code = RESPONSE_CODE_SUCCEED;
            //        [self _setNeedUpdate];
            callBack(response);
            
        } else {
            CMLLog(@"删除item失败");
            //        [self _setNeedUpdate];
            callBack(nil);
        }
    }
}

#pragma mark - 查询item

+ (void)fetchItemsWithType:(Item_Fetch_Type)itemFetchType callBack:(void(^)(CMLResponse *response))callBack {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //Response
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
    
    //设置排序规则
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"useCount" ascending:NO];
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置查询条件
    switch (itemFetchType) {
        case Item_Fetch_Cost: {
            NSString *str = [NSString stringWithFormat:@"itemType == '%@'", Item_Type_Cost];
            NSPredicate *pre = [NSPredicate predicateWithFormat:str];
            [request setPredicate:pre];
        }
            break;
            
        case Item_Fetch_Income: {
            NSString *str = [NSString stringWithFormat:@"itemType == '%@'", Item_Type_Income];
            NSPredicate *pre = [NSPredicate predicateWithFormat:str];
            [request setPredicate:pre];
        }
            break;
            
        case Item_Fetch_All:
        default:
            break;
    }
    
    //查询
    NSError *error = nil;
    NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    //取数据
    if (items == nil) {
        CMLLog(@"查询items时发生错误:%@,%@", error, [error userInfo]);
        callBack(nil);
        
    } else {
        cmlResponse.code = RESPONSE_CODE_SUCCEED;
        cmlResponse.desc = kTipFetchSuccess;
        if (itemFetchType == Item_Fetch_All) {
            NSMutableArray *incomItems = [NSMutableArray array];
            NSMutableArray *costItems = [NSMutableArray array];
            for (Item *i in items) {
                if ([i.itemType isEqualToString:Item_Type_Cost]) {
                    [costItems addObject:i];
                    
                } else {
                    [incomItems addObject:i];
                }
            }
            cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:incomItems, KEY_Income_Items, costItems, KEY_Cost_Items, nil];
            
        } else {
            cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:items, KEY_Items, nil];
        }
        callBack(cmlResponse);
    }
}

#pragma mark - 修改item

+ (void)alterItem:(Item * _Nonnull)item itemName:(NSString * _Nullable)itemName itemType:(NSString * _Nullable)itemType callback:(void(^_Nullable)(CMLResponse * _Nullable response))callBack {
    @synchronized (self) {
        //此处不做item重名的判断了，因为不排除有将某个item的账务归并到另一个item名下的可能性出现
        //但是在添加item的方法里还是必须要判断重名的，因为如果item已存在就没必要添加了
        if (itemName.length) {
            item.itemName = itemName;
        }
        
        if (itemType.length) {
            item.itemType = itemType;
        }
        
        CMLResponse *response = [[CMLResponse alloc]init];
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) {
            CMLLog(@"修改item成功");
            response.code = RESPONSE_CODE_SUCCEED;
            //        [self _setNeedUpdate];
            callBack(response);
            
        } else {
            CMLLog(@"修改item失败");
            //        [self _setNeedUpdate];
            callBack(nil);
        }
    }
    
}

@end
