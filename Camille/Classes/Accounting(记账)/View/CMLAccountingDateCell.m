//
//  CMLAccountingDateCell.m
//  Camille
//
//  Created by 杨淳引 on 16/3/13.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingDateCell.h"

@interface CMLAccountingDateCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CMLAccountingDateCell

+ (instancetype)loadFromNib {
    CMLAccountingDateCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CMLAccountingDateCell" owner:self options:nil][0];
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
