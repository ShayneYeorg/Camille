//
//  CMLAccountingViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/2/20.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingViewController.h"
#import "CMLAccountingRegistrationViewController.h"

@implementation CMLAccountingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action

- (IBAction)incomeBtnClick:(id)sender {
    CMLAccountingRegistrationViewController *accountingRegistrationViewController = [[CMLAccountingRegistrationViewController alloc]init];
    accountingRegistrationViewController.type = Accounting_Type_Income;
    [self.navigationController pushViewController:accountingRegistrationViewController animated:YES];
}

- (IBAction)costBtnClick:(id)sender {
    CMLAccountingRegistrationViewController *accountingRegistrationViewController = [[CMLAccountingRegistrationViewController alloc]init];
    accountingRegistrationViewController.type = Accounting_Type_Cost;
    [self.navigationController pushViewController:accountingRegistrationViewController animated:YES];
}

@end
