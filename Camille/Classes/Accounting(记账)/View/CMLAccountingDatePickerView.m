//
//  CMLAccountingDatePickerView.m
//  Camille
//
//  Created by 杨淳引 on 16/3/14.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingDatePickerView.h"

#define kPickerViewHeight 250

@interface CMLAccountingDatePickerView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker; //日期选择器

@end

@implementation CMLAccountingDatePickerView

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLAccountingDatePickerView *view = [[NSBundle mainBundle]loadNibNamed:@"CMLAccountingDatePickerView" owner:self options:nil][0];
    [view setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, kPickerViewHeight)];
    
    return view;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.y = kScreen_Height - kPickerViewHeight;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.y = kScreen_Height;
    }];
}

@end
