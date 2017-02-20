//
//  AccountingCell.h
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainDataModel.h"

@interface AccountingCell : UITableViewCell

@property (nonatomic, strong) MainCellModel *model;

+ (instancetype)loadFromNib;

@end
