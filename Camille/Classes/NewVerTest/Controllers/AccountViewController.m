//
//  AccountViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "AccountViewController.h"
#import "Accounting+CoreDataClass.h"
#import "CMLDisplayTextField.h"
#import "CMLAmountTextField.h"
#import "CMLAccountingDatePickerView.h"

#define kBtnHeight 50

@interface AccountViewController ()

@property (nonatomic, strong) MainCellModel *mainCellModel;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) CMLDisplayTextField *itemTextField;
@property (nonatomic, strong) CMLAmountTextField *amountTextField;
//@property (nonatomic, strong) CMLAccountingDatePickerView *itemTextField;
@property (nonatomic, strong) CMLDisplayTextField *descTextField;

@end

@implementation AccountViewController

#pragma mark - Life Cycle

- (instancetype)initWithAccounting:(MainCellModel *)mainCellModel {
    self = [super init];
    if (self) {
        self.mainCellModel = mainCellModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBackgroundView];
    [self configConfirmBtn];
    [self configDeleteBtn];
    [self configCancelBtn];
    
    [self configTypeLabel];
    [self configItemTextField];
    [self configAmountTextField];
    [self configDateTextField];
    [self configDescTextField];
}

- (void)dealloc {
    CMLLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Configuration

- (void)configBackgroundView {
    self.backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
}

- (void)configConfirmBtn {
    self.confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.backgroundView.height - kBtnHeight, kScreen_Width / 2, kBtnHeight)];
    self.confirmBtn.backgroundColor = [UIColor greenColor];
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.hidden = YES;
    [self.backgroundView addSubview:self.confirmBtn];
}

- (void)configDeleteBtn {
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.backgroundView.height - kBtnHeight, kScreen_Width / 2, kBtnHeight)];
    self.deleteBtn.backgroundColor = [UIColor redColor];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteAccounting) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.deleteBtn];
}

- (void)configCancelBtn {
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width / 2, self.backgroundView.height - kBtnHeight, kScreen_Width / 2, kBtnHeight)];
    self.cancelBtn.backgroundColor = [UIColor whiteColor];
    self.cancelBtn.layer.borderColor = RGB(200, 200, 200).CGColor;
    self.cancelBtn.layer.borderWidth = 0.5;
    [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.cancelBtn];
}

- (void)configTypeLabel {
    
}

- (void)configItemTextField {
    
}

- (void)configAmountTextField {
    
}

- (void)configDateTextField {
    
}

- (void)configDescTextField {
    
}

#pragma mark - Private

- (void)didEdit {
    [self showConfirmBtn];
}

- (void)confirm {
    
}

- (void)deleteAccounting {
    
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showConfirmBtn {
    self.confirmBtn.hidden = NO;
    self.deleteBtn.hidden = YES;
}

@end
