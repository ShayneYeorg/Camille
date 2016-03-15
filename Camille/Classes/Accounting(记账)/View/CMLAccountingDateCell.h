//
//  CMLAccountingDateCell.h
//  Camille
//
//  Created by 杨淳引 on 16/3/13.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLAccountingDateCell : UITableViewCell

+ (instancetype)loadFromNib;
- (void)refreshDateLabelWithDate:(NSDate *)date;

@end
