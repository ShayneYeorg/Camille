//
//  CMLAmountTextField.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/16.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLAmountTextField.h"

@interface CMLAmountTextField () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL hasDot; //是否已输入小数点

@end

@implementation CMLAmountTextField

+ (instancetype)loadAmountTextFieldWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor placeHolder:(NSString *)placeHolder {
    CMLAmountTextField *amountTextField = [[CMLAmountTextField alloc]initWithFrame:frame];
    amountTextField.backgroundColor = backgroundColor;
    amountTextField.layer.cornerRadius = 5;
    amountTextField.clipsToBounds = YES;
    amountTextField.hasDot = NO;
    
    amountTextField.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, amountTextField.width - 20, amountTextField.height)];
    amountTextField.textField.delegate = amountTextField;
    amountTextField.textField.keyboardType = UIKeyboardTypeDecimalPad;
    amountTextField.textField.placeholder = placeHolder;
    [amountTextField addSubview:amountTextField.textField];
    amountTextField.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    return amountTextField;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //判断是否已有“.”
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        self.hasDot = NO;
        
    } else {
        self.hasDot = YES;
    }
    
    //检测输入内容是否合法
    for (NSUInteger i = 0; i < [string length]; i++) {
        unichar character = [string characterAtIndex:i];
        if ((character < '0' || character > '9') && character != '.') {
            CMLLog(@"输入了非法字符");
            return NO;
        }
        
        if (self.hasDot && character == '.') {
            //判断"."是否重复
            CMLLog(@"\".\"重复输入");
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGFloat amount = textField.text.floatValue;
    
    if (amount >= 0.01) {
        NSString *strAmount = [NSString stringWithFormat:@"%.2f", amount];
        self.textField.text = strAmount;
        CGFloat newAmount = strAmount.floatValue;
        self.amount = [NSNumber numberWithFloat:newAmount];
        
//        CMLLog(@"输入金额是 - %f", amount);
//        CMLLog(@"输入金额转换成展示字符是 - %@", strAmount);
//        CMLLog(@"展示字符转换回float是 - %f", newAmount);
//        CMLLog(@"保存的金额是 - %@", self.amount);
        
    } else {
        self.textField.text = @"";
        self.amount = nil;
    }
}

@end
