//
//  SectionHeaderView.h
//  CamilleTest
//
//  Created by 杨淳引 on 2017/1/17.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#define kSectionHeaderHeight    50

#import <UIKit/UIKit.h>
#import "MainDataModel.h"

@interface SectionHeaderView : UIView

@property (nonatomic, strong) MainSectionModel *model;

+ (instancetype)loadSectionHeaderView;

@end
