//
//  CMLAccountingAmountCell.m
//  Camille
//
//  Created by 杨淳引 on 16/3/12.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingAmountCell.h"

@interface CMLAccountingAmountCell () <UITextFieldDelegate>

@end

@implementation CMLAccountingAmountCell

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLAccountingAmountCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CMLAccountingAmountCell" owner:self options:nil][0];
    cell.amountTextField.text = @"金额";
    cell.amountTextField.delegate = cell;
    return cell;
}

- (BOOL)isAmountAvailable {
    NSString *searchText = self.amountTextField.text;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+([.]{0,1}[0-9]+){0,1}$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    if (result) {
        CMLLog(@"金额格式正确");
        return YES;
        
    } else {
        CMLLog(@"金额格式错误");
        return NO;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //检测输入内容是否合法
    for (NSUInteger i = 0; i < [string length]; i++) {
        unichar character = [string characterAtIndex:i];
        if ((character < '0' || character > '9') && character != '.') {
            CMLLog(@"输入了非法字符");
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.amountTextField.text.length) {
        self.amountTextField.text = @"金额";
        
    } else {
        //是否有小数点？
        NSString *searchText = textField.text;
        NSError *pointError = NULL;
        NSRegularExpression *pointRegex = [NSRegularExpression regularExpressionWithPattern:@"[.]" options:NSRegularExpressionCaseInsensitive error:&pointError];
        NSTextCheckingResult *result = [pointRegex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
        if (result) {
            //有小数点
            //小数点前有数字没？没有就补上0
            NSError *zeroBeforePointError = NULL;
            NSRegularExpression *zeroBeforePointRegex = [NSRegularExpression regularExpressionWithPattern:@"[0-9][.]" options:NSRegularExpressionCaseInsensitive error:&zeroBeforePointError];
            NSTextCheckingResult *zeroBeforePointResult = [zeroBeforePointRegex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
            if (!zeroBeforePointResult) {
                //小数点前没数字，补上个0
                textField.text = [NSString stringWithFormat:@"0%@", textField.text];
            }
            
            //小数点后有数字没？没有就补上00
            NSError *zeroAfterPointError = NULL;
            NSRegularExpression *zeroAfterPointRegex = [NSRegularExpression regularExpressionWithPattern:@"[.][0-9]" options:NSRegularExpressionCaseInsensitive error:&zeroAfterPointError];
            NSTextCheckingResult *zeroAfterPointResult = [zeroAfterPointRegex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
            if (!zeroAfterPointResult) {
                //小数点后没数字，补上00
                textField.text = [NSString stringWithFormat:@"%@00", textField.text];
            }
            
            //小数点只有一个数字？补上0
            NSError *oneNumAfterPointError = NULL;
            NSRegularExpression *oneNumAfterPointRegex = [NSRegularExpression regularExpressionWithPattern:@"[.][0-9]$" options:NSRegularExpressionCaseInsensitive error:&oneNumAfterPointError];
            NSTextCheckingResult *oneNumAfterPointResult = [oneNumAfterPointRegex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
            if (oneNumAfterPointResult) {
                //小数点只有一个数字，补上0
                textField.text = [NSString stringWithFormat:@"%@0", textField.text];
            }
            
        } else {
            //无小数点，补上小数点和后两位
            textField.text = [NSString stringWithFormat:@"%@.00", textField.text];
        }
    }
}

@end




