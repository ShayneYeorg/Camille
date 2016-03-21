//
//  CMLRecordDetailHeaderView.h
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMLRecordDetailHeaderView;

@protocol CMLRecordDetailHeaderViewDelegate <NSObject>

- (void)recordDetailHeaderViewDidTap:(CMLRecordDetailHeaderView *)recordDetailHeaderView;

@end

@interface CMLRecordDetailHeaderView : UIView

@property (nonatomic, weak) id <CMLRecordDetailHeaderViewDelegate> delegate;

+ (instancetype)loadFromNib;
- (void)refreshPickDate:(NSDate *)date;
- (void)refreshTotalIncome:(NSString *)totalIncome;
- (void)refreshTotalCost:(NSString *)totalCost;

@end
