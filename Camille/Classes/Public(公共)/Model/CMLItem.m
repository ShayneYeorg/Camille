//
//  CMLItem.m
//  Camille
//
//  Created by 杨淳引 on 16/2/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLItem.h"

@implementation CMLItem

#pragma mark - Public

+ (NSMutableDictionary *)sortItems:(NSMutableArray *)items {
    //返回categoryID为key的字典，value是数组，数组内的items排好了序
    
    //传空值的滚蛋
    if (!items || !items.count) return nil;
    
    //1、建立临时字典和返回字典
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    
    //2、分组
    CMLLog(@"开始对所有记账科目进行分组...");
    //依次取出数组里的每一个item
    for (int i = 0; i < items.count; i++) {
        //判断在tempDic里item所属的category是否存在
        NSString *tempDicKey = ((CMLItem *)items[i]).categoryID;
        if ([tempDic.allKeys containsObject:tempDicKey]) {
            //item所属的category存在则将item添加到对应数组里
            [((NSMutableArray *)tempDic[tempDicKey]) addObject:items[i]];
            
        } else {
            //item所属的category不存在则建立一数组将item存入，并将数组以categoryID为key存入tempDic
            NSMutableArray *tempArr = [NSMutableArray arrayWithObjects:items[i], nil];
            [tempDic setValue:tempArr forKey:tempDicKey];
        }
    }
    CMLLog(@"所有记账科目分组完成...");
    
    //3、排序
    CMLLog(@"开始对每个分组的记账科目进行排序...");
    //将tempDic里每一个value数组进行排序，然后对应key存入returnDic
    NSArray *tempDicAllKeys = tempDic.allKeys;
    for (int i = 0; i < tempDicAllKeys.count; i++) {
        NSString *dicKey = tempDicAllKeys[i];
        [returnDic setValue:[CMLItem sortItemsInACategory:(NSMutableArray *)tempDic[dicKey]] forKey:dicKey];
    }
    CMLLog(@"所有记账科目排序完成...");
    
    //返回
    return returnDic;
    
}

+ (NSDictionary *)buildItemsContrastDic:(NSMutableArray *)items {
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < items.count; i++) {
        CMLItem *item = items[i];
        [returnDic setValue:item.itemName forKey:item.itemID];
    }
    return (NSDictionary *)returnDic;
}

#pragma mark - Private

+ (NSMutableArray *)sortItemsInACategory:(NSMutableArray *)items {
    NSMutableArray *returnArr = [NSMutableArray array];
    
    //取出第一条二级记账科目
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID == '0'"];
    NSArray *filteredItems = [items filteredArrayUsingPredicate:predicate];
    if (filteredItems.count) { //正常情况下肯定有值
        CMLItem *firstItem = filteredItems[0];
        
        //把items转成字典，用itemID做key
        NSMutableDictionary *itemsDic = [NSMutableDictionary dictionary];
        for (CMLItem *i in items) {
            [itemsDic setValue:i forKey:i.itemID];
        }
        
        //如果有数据，依次添加
        CMLItem *cursor = firstItem;
        while (cursor.nextItemID && cursor.nextItemID.length != 0) {
            [returnArr addObject:itemsDic[cursor.nextItemID]];
            cursor = itemsDic[cursor.nextItemID];
        }
    }
    
    return returnArr;
}

@end
