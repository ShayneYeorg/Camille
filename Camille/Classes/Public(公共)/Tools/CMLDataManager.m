//
//  CMLDataManager.m
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLDataManager.h"

@implementation CMLDataManager

+ (NSArray *)getItemsWithItemType:(NSString *)itemType {
    if ([itemType isEqualToString:Item_Type_Cost]) {
        return [Item getAllCostItems];
    }
    
    return [Item getAllIncomeItems];
}

+ (NSString *)confirmItemWithItemName:(NSString *)itemName {
    //1、先检查itemName是否已存在
    
    //2、存在则返回对应itemID
    
    //3、不存在则新建item
    
    return nil;
}

@end
