//
//  CMLAccountingRegistrationViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/2/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingRegistrationViewController.h"

@interface CMLAccountingRegistrationViewController ()

@end

@implementation CMLAccountingRegistrationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTitle];
    [self configBarBtns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)configTitle {
    self.title = @"收入";
    if (self.type == Accounting_Type_Cost) {
        self.title = @"支出";
    }
}

- (void)configBarBtns {
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 0, 44, 44);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:kAppTextCoclor forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 44, 44);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kAppTextCoclor forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)cancle {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    
}

@end
