//
//  CMLRecordItemDetailModel.h
//  Camille
//
//  Created by 杨淳引 on 16/5/18.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMLRecordItemDetailSectionModel : NSObject

/**
 *  当前分类账务ID
 */
@property (nonatomic, strong) NSString *setionItemID;

/**
 *  收入或支出
 */
@property (nonatomic, assign) NSString *type;

/**
 *  总额
 */
@property (nonatomic, assign) CGFloat amount;

/**
 *  账务详情
 */
@property (nonatomic, strong) NSMutableArray *detailCells;

@end


@interface CMLRecordItemDetailModel : NSObject

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
