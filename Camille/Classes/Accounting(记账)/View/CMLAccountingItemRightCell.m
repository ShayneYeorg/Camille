//
//  CMLAccountingItemRightCell.m
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingItemRightCell.h"

@implementation CMLAccountingItemRightCell

+ (instancetype)loadFromNib {
    CMLAccountingItemRightCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CMLAccountingItemRightCell" owner:self options:nil][0];
    cell.backgroundColor = kItemRightTableViewColor;
    return cell;
}

@end
