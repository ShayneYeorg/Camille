//
//  CMLDataManager.h
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item+CoreDataClass.h"

@interface CMLDataManager : NSObject

+ (NSArray *)getItemsWithItemType:(NSString *)itemType;

+ (NSString *)confirmItemWithItemName:(NSString *)itemName;

@end
