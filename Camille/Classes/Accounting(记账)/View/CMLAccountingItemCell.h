//
//  CMLAccountingItemCell.h
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLAccountingItemCell : UITableViewCell

+ (instancetype)loadFromNib;
+ (CGFloat)heightForCellByExpand:(BOOL)isExpand;
- (void)refreshWithExpand:(BOOL)isExpand;

@end
