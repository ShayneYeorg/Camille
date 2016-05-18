//
//  CMLRecordItemDetailModel.m
//  Camille
//
//  Created by 杨淳引 on 16/5/18.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordItemDetailModel.h"

@implementation CMLRecordItemDetailSectionModel

- (NSMutableArray *)detailCells {
    if (!_detailCells) {
        _detailCells = [NSMutableArray array];
    }
    return _detailCells;
}

@end

@implementation CMLRecordItemDetailModel

- (NSMutableArray *)detailSections {
    if (!_detailSections) {
        _detailSections = [NSMutableArray array];
    }
    return _detailSections;
}

@end
