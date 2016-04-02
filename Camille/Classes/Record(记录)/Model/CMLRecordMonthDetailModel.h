//
//  CMLRecordMonthDetailModel.h
//  Camille
//
//  Created by 杨淳引 on 16/4/1.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface CMLRecordMonthDetailCellModel : NSObject

/**
 *  科目名称
 */
@property (nonatomic, strong) NSString *itemName;

/**
 *  收支属性（1为支出，2为收入）
 */
@property (nonatomic, strong) NSString *itemType;

/**
 *  金额
 */
@property (nonatomic, assign) CGFloat amount;

@end


@interface CMLRecordMonthDetailSectionModel : NSObject

/**
 *  当日日期
 */
@property (nonatomic, strong) NSString *day;

/**
 *  总收入
 */
@property (nonatomic, assign) CGFloat income;

/**
 *  总支出
 */
@property (nonatomic, assign) CGFloat cost;

/**
 *  账务详情
 */
@property (nonatomic, strong) NSMutableArray *detailCells;

@end


@interface CMLRecordMonthDetailModel : NSObject

/**
 *  当月总支出
 */
@property (nonatomic, assign) CGFloat totalCost;

/**
 *  当月总收入
 */
@property (nonatomic, assign) CGFloat totalIncome;

/**
 *  账务数组
 */
@property (nonatomic, strong) NSMutableArray *detailSections;

@end

