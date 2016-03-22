//
//  CMLRecordDetailHeaderView.m
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordDetailHeaderView.h"
#import "CMLTool+NSDate.h"

@interface CMLRecordDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *pickDate; //选择的日期
@property (weak, nonatomic) IBOutlet UILabel *totalIncome; //总收入
@property (weak, nonatomic) IBOutlet UILabel *totalCost; //总支出

@end

@implementation CMLRecordDetailHeaderView

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLRecordDetailHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"CMLRecordDetailHeaderView" owner:self options:nil][0];
    [view setFrame:CGRectMake(0, 0, kScreen_Width, 95)];
    return view;
}

- (void)refreshPickDate:(NSDate *)date {
    self.pickDate.text = [CMLTool transDateToYMString:date];
}

- (void)refreshTotalIncome:(NSString *)totalIncome {
    self.totalIncome.text = totalIncome;
}

- (void)refreshTotalCost:(NSString *)totalCost {
    self.totalCost.text = totalCost;
}

#pragma mark - Private

- (IBAction)viewTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recordDetailHeaderViewDidTap:)]) {
        [self.delegate recordDetailHeaderViewDidTap:nil];
    }
}

@end
