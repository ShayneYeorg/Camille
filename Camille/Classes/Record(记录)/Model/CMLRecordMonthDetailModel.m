//
//  CMLRecordMonthDetailModel.m
//  Camille
//
//  Created by 杨淳引 on 16/4/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordMonthDetailModel.h"

@implementation CMLRecordMonthDetailCellModel

@end

@implementation CMLRecordMonthDetailSectionModel

+ (void)load {
    [CMLRecordMonthDetailSectionModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"detailCells": @"CMLRecordMonthDetailCellModel"};
    }];
}

@end

@implementation CMLRecordMonthDetailModel

+ (void)load {
    [CMLRecordMonthDetailModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"detailSections": @"CMLRecordMonthDetailSectionModel"};
    }];
}

@end
