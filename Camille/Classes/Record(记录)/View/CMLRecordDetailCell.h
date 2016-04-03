//
//  CMLRecordDetailCell.h
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLRecordMonthDetailModel.h"

@interface CMLRecordDetailCell : UITableViewCell

@property (nonatomic, strong) CMLRecordMonthDetailCellModel *model;

+ (instancetype)loadFromNib;

@end
