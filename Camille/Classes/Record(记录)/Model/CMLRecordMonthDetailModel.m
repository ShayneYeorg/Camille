//
//  CMLRecordMonthDetailModel.m
//  Camille
//
//  Created by 杨淳引 on 16/4/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordMonthDetailModel.h"
#import "CMLAccounting.h"

@implementation CMLRecordMonthDetailSectionModel

- (NSMutableArray *)detailCells {
    if (!_detailCells) {
        _detailCells = [NSMutableArray array];
    }
    return _detailCells;
}

@end

@implementation CMLRecordMonthDetailModel

- (NSMutableArray *)detailSections {
    if (!_detailSections) {
        _detailSections = [NSMutableArray array];
    }
    return _detailSections;
}

@end
