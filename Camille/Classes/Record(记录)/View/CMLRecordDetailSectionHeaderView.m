//
//  CMLRecordDetailSectionHeaderView.m
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordDetailSectionHeaderView.h"

@interface CMLRecordDetailSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel; //日期
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel; //收入
@property (weak, nonatomic) IBOutlet UILabel *costLabel; //支出

@end

@implementation CMLRecordDetailSectionHeaderView

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLRecordDetailSectionHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"CMLRecordDetailSectionHeaderView" owner:self options:nil][0];
    [view setFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    return view;
}

- (void)refreshDate:(NSDate *)date {
    
}

- (void)refreshIncome:(NSString *)income {
    self.incomeLabel.text = income;
}

- (void)refreshCost:(NSString *)cost {
    self.costLabel.text = cost;
}

@end
