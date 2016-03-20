//
//  CMLRecordCell.h
//  Camille
//
//  Created by 杨淳引 on 16/3/20.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLRecordCellModel.h"

@interface CMLRecordCell : UITableViewCell

@property (nonatomic, strong) CMLRecordCellModel *model;

+ (instancetype)loadFromNib;

@end
