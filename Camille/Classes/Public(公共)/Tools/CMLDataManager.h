//
//  CMLDataManager.h
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainDataModel.h"

typedef NS_ENUM (NSInteger, Load_Type) {
    Load_Type_Refresh = 0,
    Load_Type_LoadMore,
};

@interface CMLDataManager : NSObject

+ (NSArray *)getItemsWithItemType:(NSString *)itemType;

//数据缓存在本层，调用的那层不管分页情况
+ (void)fetchAllAccountingsWithLoadType:(Load_Type)loadType callBack:(void(^)(NSMutableArray *accountings))callBack;

@end
