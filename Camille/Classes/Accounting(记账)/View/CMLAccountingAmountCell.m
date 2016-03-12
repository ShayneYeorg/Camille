//
//  CMLAccountingAmountCell.m
//  Camille
//
//  Created by 杨淳引 on 16/3/12.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingAmountCell.h"

@interface CMLAccountingAmountCell ()

@property (weak, nonatomic) IBOutlet UITextField *amountTextField; //金额

@end

@implementation CMLAccountingAmountCell

+ (instancetype)loadFromNib {
    CMLAccountingAmountCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CMLAccountingAmountCell" owner:self options:nil][0];
    cell.amountTextField.text = @"金额";
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
