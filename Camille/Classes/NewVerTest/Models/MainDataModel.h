//
//  MainDataModel.h
//  Camille
//
//  Created by 杨淳引 on 2017/2/7.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainCellModel : NSObject

/**
 *  项目名称
 */
@property (nonatomic, copy) NSString *itemName;

/**
 *  金额
 */
@property (nonatomic, copy) NSString *amount;

/**
 *  备注
 */
@property (nonatomic, copy) NSString *desc;

@end

@interface MainSectionModel : NSObject

/**
 *  日期
 */
@property (nonatomic, copy) NSString *date;

/**
 *  支出总额
 */
@property (nonatomic, copy) NSString *totalCost;

/**
 *  收入总额
 */
@property (nonatomic, copy) NSString *totalIncome;

/**
 *  cell内容
 */
@property (nonatomic, strong) NSMutableArray *cellModels;

@end
