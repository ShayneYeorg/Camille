//
//  MainDataModel.h
//  Camille
//
//  Created by 杨淳引 on 2017/2/7.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item+CoreDataClass.h"
#import "Accounting+CoreDataClass.h"
#import "CMLTool+NSDate.h"

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


/**
 初始化方法

 @param accounting 初始化使用的Accounting
 @return 初始化完成的MainCellModel对象
 */
+ (instancetype)mainCellModelWithAccounting:(Accounting *)accounting;

@end

@interface MainSectionModel : NSObject

/**
 *  日期（string）
 */
@property (nonatomic, copy) NSString *date;

/**
 *  日期（date）
 */
@property (nonatomic, strong) NSDate *happenDate;

/**
 *  支出总额
 */
@property (nonatomic, assign) CGFloat totalCost;

/**
 *  收入总额
 */
@property (nonatomic, assign) CGFloat *totalIncome;

/**
 *  cell内容
 */
@property (nonatomic, strong) NSMutableArray *cellModels;


/**
 初始化方法

 @param accounting 初始化使用的Accounting
 @return 初始化完成的MainSectionModel对象
 */
+ (instancetype)mainSectionModelWithAccounting:(Accounting *)accounting;



/**
 添加cell的方法

 @param cellModel 要添加的cell
 */
- (void)addCell:(MainCellModel *)cellModel;

@end
