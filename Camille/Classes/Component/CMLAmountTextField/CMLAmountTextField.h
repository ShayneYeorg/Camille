//
//  CMLAmountTextField.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/16.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLAmountTextField : UIView

@property (nonatomic, strong) NSNumber *amount;

+ (instancetype)loadAmountTextFieldWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor placeHolder:(NSString *)placeHolder;

@end
