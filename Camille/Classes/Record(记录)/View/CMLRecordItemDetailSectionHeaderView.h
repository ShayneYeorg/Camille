//
//  CMLRecordItemDetailSectionHeaderView.h
//  Camille
//
//  Created by 杨淳引 on 16/5/18.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLRecordItemDetailSectionHeaderView : UIView

+ (instancetype)loadFromNib;
- (void)refreshItemName:(NSString *)itemName;
- (void)refreshType:(NSString *)type;
- (void)refreshAmount:(NSString *)amount;

@end
