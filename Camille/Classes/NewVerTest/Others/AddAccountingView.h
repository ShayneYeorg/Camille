//
//  AddAccountingView.h
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAccountingView : UIView

@property (nonatomic, copy) VoidBlock saveBtnClickAction;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *value;

+ (instancetype)loadFromNib;

@end
