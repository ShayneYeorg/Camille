//
//  CMLAccountingItemLeftCell.m
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingItemLeftCell.h"

@interface CMLAccountingItemLeftCell ()

@property (weak, nonatomic) IBOutlet UIView *rightSepLine; //右分割线

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
        self.rightSepLine.hidden = YES;
        
    } else {
        self.backgroundColor = kItemLeftTableViewColor;
        self.rightSepLine.hidden = NO;
    }
}

@end
