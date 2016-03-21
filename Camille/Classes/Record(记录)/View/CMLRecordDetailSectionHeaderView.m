//
//  CMLRecordDetailSectionHeaderView.m
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordDetailSectionHeaderView.h"

@implementation CMLRecordDetailSectionHeaderView

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLRecordDetailSectionHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"CMLRecordDetailSectionHeaderView" owner:self options:nil][0];
    [view setFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    return view;
}

@end
