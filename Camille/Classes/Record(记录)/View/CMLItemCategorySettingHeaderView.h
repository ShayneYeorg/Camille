//
//  CMLItemCategorySettingHeaderView.h
//  Camille
//
//  Created by 杨淳引 on 16/5/30.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLItemCategorySettingHeaderView : UIView

+ (instancetype)loadFromNib;

@property (weak, nonatomic) IBOutlet UILabel *titleText;

@end
