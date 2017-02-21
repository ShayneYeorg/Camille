//
//  SectionHeaderView.h
//  CamilleTest
//
//  Created by 杨淳引 on 2017/1/17.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#define kSectionHeaderHeight    50

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *cost;

+ (instancetype)loadSectionHeaderView;

- (void)refershIncome:(NSNumber *)income;
- (void)refreshCost:(NSNumber *)cost;

@end
