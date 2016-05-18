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

- (void)refreshAmount:(NSString *)amount type:(NSString *)type {
    if ([type isEqualToString:Item_Type_Cost]) {
        self.typeLabel.text = @"支出:";
        self.amountLabel.text = [NSString stringWithFormat:@"-%@", amount];
        
    } else {
        self.typeLabel.text = @"收入:";
        self.amountLabel.text = [NSString stringWithFormat:@"+%@", amount];
    }
}

@end
