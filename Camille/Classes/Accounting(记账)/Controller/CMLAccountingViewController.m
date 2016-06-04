//
//  CMLAccountingViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/2/20.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingViewController.h"
#import "CMLAccountingRegistrationViewController.h"
#import "CMLCoreDataAccess.h"

#import "CMLItem.h"

@implementation CMLAccountingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kAppViewColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action

- (IBAction)incomeBtnClick:(id)sender {
    CMLAccountingRegistrationViewController *accountingRegistrationViewController = [[CMLAccountingRegistrationViewController alloc]init];
    accountingRegistrationViewController.type = Item_Type_Income;
    [self.navigationController pushViewController:accountingRegistrationViewController animated:YES];
}

- (IBAction)costBtnClick:(id)sender {
    CMLAccountingRegistrationViewController *accountingRegistrationViewController = [[CMLAccountingRegistrationViewController alloc]init];
    accountingRegistrationViewController.type = Item_Type_Cost;
    [self.navigationController pushViewController:accountingRegistrationViewController animated:YES];
}

@end
