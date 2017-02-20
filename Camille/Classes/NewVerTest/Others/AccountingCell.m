//
//  AccountingCell.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "AccountingCell.h"

@interface AccountingCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation AccountingCell

+ (instancetype)loadFromNib {
    AccountingCell *cell = [[NSBundle mainBundle]loadNibNamed:@"AccountingCell" owner:self options:nil][0];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MainCellModel *)model {
    _model = model;
    
    self.nameLabel.text = model.displayItemName;
    self.valueLabel.text = _model.displayAmount;
}

@end
