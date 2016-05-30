//
//  CMLItemCategorySettingHeaderView.m
//  Camille
//
//  Created by 杨淳引 on 16/5/30.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLItemCategorySettingHeaderView.h"

@implementation CMLItemCategorySettingHeaderView

+ (instancetype)loadFromNib {
    CMLItemCategorySettingHeaderView *itemCategorySettingHeaderView = [[NSBundle mainBundle]loadNibNamed:@"CMLItemCategorySettingHeaderView" owner:self options:nil][0];
    itemCategorySettingHeaderView.backgroundColor = kItemRightTableViewColor;
    return itemCategorySettingHeaderView;
}

@end
