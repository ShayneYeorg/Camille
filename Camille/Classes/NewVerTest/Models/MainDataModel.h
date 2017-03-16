//
//  MainDataModel.h
//  Camille
//
//  Created by 杨淳引 on 2017/2/7.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLTool+NSDate.h"
#import "CoreDataModels.h"

@interface MainCellModel : NSObject

//展示的内容

/**
 *  项目名称
 */
@property (nonatomic, copy) NSString *displayItemName;

/**
 *  金额
 */
@property (nonatomic, copy) NSString *displayAmount;

/**
 *  备注
 */
@property (nonatomic, copy) NSString *displayDesc;

//其他属性

/**
 *  账务类型
 */
@property (nonatomic, copy) NSString *itemType;

/**
 *  金额
 */
@property (nonatomic, assign) CGFloat amount;


/**
 初始化方法

 @param accounting 初始化使用的Accounting
 @return 初始化完成的MainCellModel对象
 */
+ (instancetype)mainCellModelWithAccounting:(Accounting *)accounting;

@end

@interface MainSectionModel : NSObject

//展示的内容

/**
 *  日期（string）
 */
@property (nonatomic, copy) NSString *diaplayDate;


#warning - 总支出和总收入似乎没用，如果某一天只取了一部分的话，这个数据就是不对的
/**
 *  支出总额
 */
@property (nonatomic, assign) CGFloat totalCost;

/**
 *  收入总额
 */
@property (nonatomic, assign) CGFloat totalIncome;

//其他属性

/**
 *  cell内容
 */
@property (nonatomic, strong) NSMutableArray *cellModels;

/**
 *  日期（date）
 */
@property (nonatomic, strong) NSDate *happenDate;


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
