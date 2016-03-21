//
//  CMLRecordDetailCell.m
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordDetailCell.h"

@interface CMLRecordDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel; //科目名称
@property (weak, nonatomic) IBOutlet UILabel *amountLabel; //金额

@end

@implementation CMLRecordDetailCell

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLRecordDetailCell *cell = [[NSBundle mainBundle] loadNibNamed:@"CMLRecordDetailCell" owner:self options:nil][0];
    return cell;
}

- (void)refreshItemName:(NSString *)itemName {
    self.itemNameLabel.text = itemName;
}

- (void)refreshAmount:(NSString *)amount {
    self.amountLabel.text = amount;
}

@end
