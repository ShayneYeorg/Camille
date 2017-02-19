//
//  MainDataModel.m
//  Camille
//
//  Created by 杨淳引 on 2017/2/7.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "MainDataModel.h"

@implementation MainCellModel

+ (instancetype)mainCellModelWithAccounting:(Accounting *)accounting {
    MainCellModel *cellModel = [MainCellModel new];
    
    cellModel.itemName = [Item itemNameByItemID:accounting.itemID];
    NSString *symbol = @"-";
    NSString *itemType = [Item itemTypeByItemID:accounting.itemID];
    if ([itemType isEqualToString:Item_Type_Income]) {
        symbol = @"+";
    }
    cellModel.amount = [NSString stringWithFormat:@"%@%.2f", symbol, accounting.amount.floatValue];
    
    return cellModel;
}

@end

@implementation MainSectionModel

+ (instancetype)mainSectionModelWithAccounting:(Accounting *)accounting {
    MainSectionModel *sectionModel = [MainSectionModel new];
    
    sectionModel.happenDate = accounting.happenTime;
    sectionModel.date = [CMLTool transDateToString:accounting.happenTime];
    sectionModel.cellModels = [NSMutableArray array];
    
    return sectionModel;
}

- (void)addCell:(MainCellModel *)cellModel {
    [self.cellModels addObject:cellModel];
    
    
}

@end
