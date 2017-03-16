//
//  CMLAccountingDatePickerView.m
//  Camille
//
//  Created by 杨淳引 on 16/3/14.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingDatePickerView.h"

@interface CMLAccountingDatePickerView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker; //日期选择器
@property (nonatomic, strong) UIView *coverView;

@end

@implementation CMLAccountingDatePickerView

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLAccountingDatePickerView *view = [[NSBundle mainBundle]loadNibNamed:@"CMLAccountingDatePickerView" owner:self options:nil][0];
    [view setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, kPickerViewHeight)];
    view.isShow = NO;
    
    return view;
}

- (void)show {
    if (self.superview) {
        [self.superview insertSubview:self.coverView belowSubview:self];
        
        self.isShow = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.y = kScreen_Height - kPickerViewHeight;
        }];
    }
}

- (void)dismiss {
    [self.coverView removeFromSuperview];
    self.isShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.y = kScreen_Height;
    }];
}

#pragma mark - Getter

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.superview.bounds];
        _coverView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

#pragma mark - Private

- (IBAction)confirmBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(accountingDatePickerView:didClickConfirmBtn:)]) {
        [self dismiss];
        [self.delegate accountingDatePickerView:nil didClickConfirmBtn:self.datePicker.date];
    }
}


@end
