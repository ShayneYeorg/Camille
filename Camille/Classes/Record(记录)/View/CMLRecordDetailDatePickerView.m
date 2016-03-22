//
//  CMLRecordDetailDatePickerView.m
//  Camille
//
//  Created by 杨淳引 on 16/3/14.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordDetailDatePickerView.h"
#import "CDatePickerViewEx.h"

@interface CMLRecordDetailDatePickerView ()

@property (weak, nonatomic) IBOutlet CDatePickerViewEx *monthPicker;

@end

@implementation CMLRecordDetailDatePickerView

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLRecordDetailDatePickerView *view = [[NSBundle mainBundle]loadNibNamed:@"CMLRecordDetailDatePickerView" owner:self options:nil][0];
    [view setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, kRecordDetailDatePickerViewHeight)];
    [view.monthPicker selectToday];
    
    return view;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.y = kScreen_Height - kRecordDetailDatePickerViewHeight;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.y = kScreen_Height;
    }];
}

#pragma mark - Private

- (IBAction)confirmBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(recordDetailDatePickerView:didClickConfirmBtn:)]) {
        [self.delegate recordDetailDatePickerView:nil didClickConfirmBtn:self.monthPicker.date];
    }
}

@end
