//
//  CMLRecordDetailDatePickerView.h
//  Camille
//
//  Created by 杨淳引 on 16/3/14.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRecordDetailDatePickerViewHeight 250

@class CMLRecordDetailDatePickerView;

@protocol CMLRecordDetailDatePickerViewDelegate <NSObject>

- (void)recordDetailDatePickerView:(CMLRecordDetailDatePickerView *)recordDetailDatePickerView didClickConfirmBtn:(NSDate *)selectedDate;

@end

@interface CMLRecordDetailDatePickerView : UIView

@property (nonatomic, weak) id <CMLRecordDetailDatePickerViewDelegate> delegate;

+ (instancetype)loadFromNib;
- (void)show;
- (void)dismiss;

@end
