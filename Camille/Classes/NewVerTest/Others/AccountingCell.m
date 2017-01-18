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

- (void)setModel:(TestDataAccounting *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    NSString *symbol = @"-";
    if (!_model.isOutcome) {
        symbol = @"+";
    }
    self.valueLabel.text = [NSString stringWithFormat:@"%@%.2f", symbol, _model.value];
}

@end
