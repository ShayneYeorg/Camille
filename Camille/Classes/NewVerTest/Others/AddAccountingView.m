//
//  AddAccountingView.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "AddAccountingView.h"

@implementation AddAccountingView

+ (instancetype)loadFromNib {
    AddAccountingView *view = [[NSBundle mainBundle]loadNibNamed:@"AddAccountingView" owner:nil options:nil][0];
    return view;
}

- (IBAction)save:(id)sender {
    if (self.saveBtnClickAction) {
        self.saveBtnClickAction();
    }
}

@end
