//
//  CMLAccountingAmountCell.m
//  Camille
//
//  Created by 杨淳引 on 16/3/12.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingAmountCell.h"

@interface CMLAccountingAmountCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *amountTextField; //金额

@end

@implementation CMLAccountingAmountCell

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLAccountingAmountCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CMLAccountingAmountCell" owner:self options:nil][0];
    cell.amountTextField.text = @"金额";
    cell.amountTextField.delegate = cell;
    return cell;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.amountTextField.text.length) {
        self.amountTextField.text = @"金额";
    }
}

@end




