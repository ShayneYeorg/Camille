//
//  SectionHeaderView.m
//  CamilleTest
//
//  Created by 杨淳引 on 2017/1/17.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "SectionHeaderView.h"
#import "CMLReportManager.h"
#import "Day_Summary+CoreDataClass.h"

@interface SectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *cost;

@end

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

#pragma mark - Setter

- (void)setModel:(MainSectionModel *)model {
    _model = model;
    
    self.date.text = _model.diaplayDate;
    DECLARE_WEAK_SELF
    [CMLReportManager fetchDaySummaryWithDate:_model.happenDate callback:^(CMLResponse *response) {
        if (PHRASE_ResponseSuccess) {
            NSArray *dss = response.responseDic[KEY_Day_Summaries];
            if (dss.count) {
                Day_Summary *ds = dss.firstObject;
                weakSelf.income.text = [NSString stringWithFormat:@"+%.2f", ds.income.floatValue];
                weakSelf.cost.text = [NSString stringWithFormat:@"-%.2f", ds.cost.floatValue];
            }
        }
    }];
}

@end
