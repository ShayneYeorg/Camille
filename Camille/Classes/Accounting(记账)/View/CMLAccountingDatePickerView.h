//
//  CMLAccountingDatePickerView.h
//  Camille
//
//  Created by 杨淳引 on 16/3/14.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPickerViewHeight 250

@class CMLAccountingDatePickerView;

@protocol CMLAccountingDatePickerViewDelegate <NSObject>

- (void)accountingDatePickerView:(CMLAccountingDatePickerView *)accountingDatePickerView didClickConfirmBtn:(NSDate *)selectedDate;

@end

@interface CMLAccountingDatePickerView : UIView

@property (nonatomic, weak) id <CMLAccountingDatePickerViewDelegate> delegate;

+ (instancetype)loadFromNib;
- (void)show;
- (void)dismiss;

@end
