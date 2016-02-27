//
//  CMLAccountingItemLeftCell.m
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingItemLeftCell.h"

@implementation CMLAccountingItemLeftCell

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLAccountingItemLeftCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CMLAccountingItemLeftCell" owner:self options:nil] firstObject];
    cell.backgroundColor = kItemLeftTableViewColor;
    
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
