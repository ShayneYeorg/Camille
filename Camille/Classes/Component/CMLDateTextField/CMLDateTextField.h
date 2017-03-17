//
//  CMLDateTextField.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/17.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLAccountingDatePickerView.h"

typedef void (^DateSelectBlock)(NSDate *selectedDate);

@interface CMLDateTextField : UIView

+ (instancetype)loadDateTextFieldWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor above:(UIView *)aboveView touchAction:(VoidBlock)touchAction selectedDateAction:(DateSelectBlock)selectedDateAction;

@end
