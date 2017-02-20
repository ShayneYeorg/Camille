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
    
    NSString *symbol = @"-";
    cellModel.itemType = [Item itemTypeByItemID:accounting.itemID];
    cellModel.amount = accounting.amount.floatValue;
    if ([cellModel.itemType isEqualToString:Item_Type_Income]) {
        symbol = @"+";
    }
    
    cellModel.displayItemName = [Item itemNameByItemID:accounting.itemID];
    cellModel.displayAmount = [NSString stringWithFormat:@"%@%.2f", symbol, accounting.amount.floatValue];
    cellModel.displayDesc = accounting.desc;
    
    return cellModel;
}

@end

@implementation MainSectionModel

+ (instancetype)mainSectionModelWithAccounting:(Accounting *)accounting {
    MainSectionModel *sectionModel = [MainSectionModel new];
    
    sectionModel.happenDate = accounting.happenTime;
    sectionModel.diaplayDate = [CMLTool transDateToString:accounting.happenTime];
    sectionModel.cellModels = [NSMutableArray array];
    
    return sectionModel;
}

- (void)addCell:(MainCellModel *)cellModel {
    [self.cellModels addObject:cellModel];
    
    if ([cellModel.itemType isEqualToString:Item_Type_Income]) {
        self.totalIncome += cellModel.amount;
        
    } else {
        self.totalCost += cellModel.amount;
    }
}

@end
