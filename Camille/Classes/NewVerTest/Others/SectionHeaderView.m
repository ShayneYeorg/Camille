//
//  SectionHeaderView.m
//  CamilleTest
//
//  Created by 杨淳引 on 2017/1/17.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

+ (instancetype)loadSectionHeaderView {
    SectionHeaderView *view = [[SectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kSectionHeaderHeight)];
    view.backgroundColor = RGB(150, 150, 150);
    
    return view;
}

@end
