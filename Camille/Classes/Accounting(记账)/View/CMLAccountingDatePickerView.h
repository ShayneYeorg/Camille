//
//  CMLAccountingDatePickerView.h
//  Camille
//
//  Created by 杨淳引 on 16/3/14.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLAccountingDatePickerView;

@protocol CMLAccountingDatePickerView <NSObject>

- (void)accountingDatePickerView:(CMLAccountingDatePickerView *)accountingDatePickerView didClickConfirmBtn:(NSDate *)selectedDate;

@end

@interface CMLAccountingDatePickerView : UIView

+ (instancetype)loadFromNib;
- (void)show;
- (void)dismiss;

@end
