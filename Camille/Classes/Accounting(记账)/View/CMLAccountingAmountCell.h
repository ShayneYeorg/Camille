//
//  CMLAccountingAmountCell.h
//  Camille
//
//  Created by 杨淳引 on 16/3/12.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLAccountingAmountCell;

@protocol CMLAccountingAmountCellDelegate <NSObject>

- (void)accountingAmountCell:(CMLAccountingAmountCell *)accountingAmountCell DidEndEditing:(CGFloat)amount;

@end

@interface CMLAccountingAmountCell : UITableViewCell

@property (weak, nonatomic) id <CMLAccountingAmountCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField; //金额

+ (instancetype)loadFromNib;
- (BOOL)isAmountAvailable; //金额是否有效

@end
