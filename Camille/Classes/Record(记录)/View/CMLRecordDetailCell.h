//
//  CMLRecordDetailCell.h
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLRecordDetailCell : UITableViewCell

+ (instancetype)loadFromNib;
- (void)refreshItemName:(NSString *)itemName;
- (void)refreshAmount:(NSString *)amount;

@end
