//
//  CMLAmountTextField.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/16.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AmountEndEditBlock)(NSNumber *amount);

@interface CMLAmountTextField : UIView

+ (instancetype)loadAmountTextFieldWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor placeHolder:(NSString *)placeHolder endEditAction:(AmountEndEditBlock)endEditAction;
- (void)refreshWithNumber:(NSNumber *)number;

@end
