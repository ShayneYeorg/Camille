//
//  CMLAccountingItemCell.m
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingItemCell.h"

@interface CMLAccountingItemCell ()

@property (weak, nonatomic) IBOutlet UIView *topView; //上部区域
@property (weak, nonatomic) IBOutlet UIView *bottomView; //选择项目的区域

@end

@implementation CMLAccountingItemCell

+ (instancetype)loadFromNib {
    CMLAccountingItemCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CMLAccountingItemCell" owner:self options:nil] firstObject];
    
    return cell;
}

+ (CGFloat)heightForCellByExpand:(BOOL)isExpand {
    if (isExpand) {
        return 300.5;
        
    } else {
        return 50.5;
    }
}

- (void)refreshWithExpand:(BOOL)isExpand {
    if (isExpand) {
        self.bottomView.hidden = NO;
        
    } else {
        self.bottomView.hidden = YES;
    }
}

- (IBAction)expandTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(accountingItemCellDidTapExpandArea:)]) {
        [self.delegate accountingItemCellDidTapExpandArea:self];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
