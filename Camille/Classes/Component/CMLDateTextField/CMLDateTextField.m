//
//  CMLDateTextField.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/17.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLDateTextField.h"
#import "CMLTool+NSDate.h"

@interface CMLDateTextField () <CMLAccountingDatePickerViewDelegate>

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) CMLAccountingDatePickerView *datePickerView;
@property (nonatomic, strong) UIView *aboveView;

@property (nonatomic, copy) VoidBlock touchAction;
@property (nonatomic, copy) DateSelectBlock selectedDateAction;;

@end

@implementation CMLDateTextField

#pragma mark - Public

+ (instancetype)loadDateTextFieldWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor above:(UIView *)aboveView touchAction:(VoidBlock)touchAction selectedDateAction:(DateSelectBlock)selectedDateAction {
    CMLDateTextField *dateTextField = [[CMLDateTextField alloc]initWithFrame:frame];
    dateTextField.backgroundColor = backgroundColor;
    dateTextField.layer.cornerRadius = 5;
    dateTextField.clipsToBounds = YES;
    dateTextField.aboveView = aboveView;
    dateTextField.touchAction = touchAction;
    dateTextField.selectedDateAction = selectedDateAction;
    
    [dateTextField configDateLabel];
    [dateTextField configDatePickerView];
    [dateTextField addTapAction];
    
    return dateTextField;
}

#pragma mark - Private

- (void)chooseDate:(NSDate *)date {
    if (self.selectedDateAction) {
        NSString *dateStr = [CMLTool transDateToString:date];
        self.dateLabel.text = dateStr;
        self.selectedDateAction(date);
    }
}

- (void)configDateLabel {
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.width - 20, self.height)];
    [self addSubview:self.dateLabel];
    [self chooseDate:[NSDate date]];
}

- (void)configDatePickerView {
    self.datePickerView = [CMLAccountingDatePickerView loadFromNib];
    self.datePickerView.delegate = self;
    [self.aboveView addSubview:self.datePickerView];
}

- (void)addTapAction {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap)];
    [self addGestureRecognizer:tap];
}

- (void)didTap {
    if (self.touchAction) {
        self.touchAction();
    }
    
    [self.datePickerView show];
}

#pragma mark - CMLAccountingDatePickerViewDelegate

- (void)accountingDatePickerView:(CMLAccountingDatePickerView *)accountingDatePickerView didClickConfirmBtn:(NSDate *)selectedDate {
    [self chooseDate:selectedDate];
    [self.datePickerView dismiss];
}

@end
