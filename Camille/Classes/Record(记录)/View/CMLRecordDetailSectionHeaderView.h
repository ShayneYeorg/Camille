//
//  CMLRecordDetailSectionHeaderView.h
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLRecordDetailSectionHeaderView : UIView

+ (instancetype)loadFromNib;
- (void)refreshDate:(NSDate *)date;
- (void)refreshIncome:(NSString *)income;
- (void)refreshCost:(NSString *)cost;

@end
