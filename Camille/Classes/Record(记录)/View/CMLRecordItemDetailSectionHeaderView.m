//
//  CMLRecordItemDetailSectionHeaderView.m
//  Camille
//
//  Created by 杨淳引 on 16/5/18.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordItemDetailSectionHeaderView.h"

@interface CMLRecordItemDetailSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end

@implementation CMLRecordItemDetailSectionHeaderView

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLRecordItemDetailSectionHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"CMLRecordItemDetailSectionHeaderView" owner:self options:nil][0];
    [view setFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    return view;
}

- (void)refreshItemName:(NSString *)itemName {
    self.itemNameLabel.text = itemName;
}

- (void)refreshType:(NSString *)type {
    self.typeLabel.text = type;
}

- (void)refreshAmount:(NSString *)amount {
    self.amountLabel.text = amount;
}

@end
