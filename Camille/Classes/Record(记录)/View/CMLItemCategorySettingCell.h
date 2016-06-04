//
//  CMLItemCategorySettingCell.h
//  Camille
//
//  Created by 杨淳引 on 16/5/30.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLItemCategorySettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellText; //标题
@property (weak, nonatomic) IBOutlet UIImageView *arrow; //箭头

+ (instancetype)loadFromNibWithTableView:(UITableView *)tableView;

@end
