//
//  CMLItemCategorySettingCell.m
//  Camille
//
//  Created by 杨淳引 on 16/5/30.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLItemCategorySettingCell.h"

@implementation CMLItemCategorySettingCell

#pragma mark - Public

+ (instancetype)loadFromNibWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CMLItemCategorySettingCell";
    CMLItemCategorySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = kAppViewColor;
    return cell;
}

@end
