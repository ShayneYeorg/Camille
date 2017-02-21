//
//  SectionHeaderView.m
//  CamilleTest
//
//  Created by 杨淳引 on 2017/1/17.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

#pragma mark - Life Cycle

+ (instancetype)loadSectionHeaderView {
    SectionHeaderView *sectionHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SectionHeaderView" owner:self options:nil][0];
    sectionHeaderView.frame = CGRectMake(0, 0, kScreen_Width, kSectionHeaderHeight);
    sectionHeaderView.backgroundColor = RGB(150, 150, 150);
    sectionHeaderView.income.text = @"- -";
    sectionHeaderView.cost.text = @"- -";
    
    return sectionHeaderView;
}

#pragma mark - Public

- (void)refershIncome:(NSNumber *)income {
    
}

- (void)refreshCost:(NSNumber *)cost {
    
}

@end
