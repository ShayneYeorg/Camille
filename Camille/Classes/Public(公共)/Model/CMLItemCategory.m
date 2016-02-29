//
//  CMLItemCategory.m
//  Camille
//
//  Created by 杨淳引 on 16/2/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLItemCategory.h"

@implementation CMLItemCategory

+ (NSMutableArray *)sortItemCategories:(NSMutableArray *)itemCategories {
    //传空值的滚蛋
    if (!itemCategories.count) return itemCategories;
    
    //建立返回数组
    NSMutableArray *returnArr = [NSMutableArray array];
    
    //取出第一条一级记账科目
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryID==0"];
    NSArray *filteredCategories = [itemCategories filteredArrayUsingPredicate:predicate];
    if (filteredCategories.count) { //正常情况下肯定有值
        CMLItemCategory *firstCategory = filteredCategories[0];
        [returnArr addObject:firstCategory];
        
        //把itemCategories转成字典，用categoriesID做key
        NSMutableDictionary *categoriesDic = [NSMutableDictionary dictionary];
        for (CMLItemCategory *c in itemCategories) {
            [categoriesDic setValue:c forKey:c.categoryID];
        }
        
        //如果还有数据，继续添加
        CMLItemCategory *cursor = firstCategory;
        while (cursor.nextCategoryID && cursor.nextCategoryID.length != 0) {
            [returnArr addObject:categoriesDic[cursor.nextCategoryID]];
            cursor = categoriesDic[cursor.nextCategoryID];
        }
    }
    
    return returnArr;
}

@end
