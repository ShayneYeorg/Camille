//
//  CMLAccountingItemLeftCell.m
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingItemLeftCell.h"

@interface CMLAccountingItemLeftCell ()

@end

@implementation CMLAccountingItemLeftCell

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLAccountingItemLeftCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CMLAccountingItemLeftCell" owner:self options:nil] firstObject];
    cell.backgroundColor = kItemLeftTableViewColor;
    
    return cell;
}

- (void)setCellSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = kItemRightTableViewColor;
        
    } else {
        self.backgroundColor = kItemLeftTableViewColor;
    }
}

@end
