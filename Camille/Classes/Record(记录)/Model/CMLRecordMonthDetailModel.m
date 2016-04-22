//
//  CMLRecordMonthDetailModel.m
//  Camille
//
//  Created by 杨淳引 on 16/4/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordMonthDetailModel.h"
#import "CMLAccounting.h"

//@implementation CMLRecordMonthDetailCellModel
//
//@end

@implementation CMLRecordMonthDetailSectionModel

//+ (void)load {
//    [CMLRecordMonthDetailSectionModel mj_setupObjectClassInArray:^NSDictionary *{
//        return @{@"detailCells": @"CMLAccounting"};
//    }];
//}

- (NSMutableArray *)detailCells {
    if (!_detailCells) {
        _detailCells = [NSMutableArray array];
    }
    return _detailCells;
}

@end

@implementation CMLRecordMonthDetailModel

//+ (void)load {
//    [CMLRecordMonthDetailModel mj_setupObjectClassInArray:^NSDictionary *{
//        return @{@"detailSections": @"CMLRecordMonthDetailSectionModel"};
//    }];
//}

- (NSMutableArray *)detailSections {
    if (!_detailSections) {
        _detailSections = [NSMutableArray array];
    }
    return _detailSections;
}

@end
