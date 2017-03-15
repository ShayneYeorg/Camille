//
//  CMLDisplayTextField.h
//  Camille
//
//  Created by 杨淳引 on 2017/3/15.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLDisplayTextField : UIView

+ (instancetype)loadDisplayTextFieldWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor placeHolder:(NSString *)placeHolder touchAction:(VoidBlock)touchAction;

- (void)refreshWithText:(NSString *)text;
- (NSString *)currentText;

@end
