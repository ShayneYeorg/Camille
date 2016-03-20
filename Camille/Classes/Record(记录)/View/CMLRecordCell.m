//
//  CMLRecordCell.m
//  Camille
//
//  Created by 杨淳引 on 16/3/20.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordCell.h"

@implementation CMLRecordCell

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLRecordCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CMLRecordCell" owner:self options:nil][0];
    return cell;
}

#pragma mark - Setter

- (void)setModel:(CMLRecordCellModel *)model {
    _model = model;
    
    
}

@end
