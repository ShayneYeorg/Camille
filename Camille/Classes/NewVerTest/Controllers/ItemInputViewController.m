//
//  ItemInputViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "ItemInputViewController.h"

@interface ItemInputViewController () <UITextFieldDelegate>

@property (nonatomic, assign) CGRect initialPosition;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UITextField *itemInputField;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation ItemInputViewController

#pragma mark - Life Cycle

+ (instancetype)initWithInitialPosition:(CGRect)initialPosition {
    ItemInputViewController *itemInputViewController = [ItemInputViewController new];
    itemInputViewController.initialPosition = initialPosition;
    return itemInputViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBackgroundView];
    if (self.initialPosition.size.width > 0 && self.initialPosition.size.height > 0) {
        self.itemInputField = [[UITextField alloc]initWithFrame:self.initialPosition];
        self.itemInputField.delegate = self;
        self.itemInputField.backgroundColor = RGB(230, 230, 230);
        self.itemInputField.layer.cornerRadius = 5;
        self.itemInputField.clipsToBounds = YES;
        [self.backgroundView addSubview:self.itemInputField];
        self.itemInputField.placeholder = @"项目";
        [self configInitialAnamation];
        
    } else {
        CMLLog(@"需要使用initWithInitialPosition:方法先指定inputField的初始位置");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configBackgroundView {
    self.backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
}

- (void)configInitialAnamation {
    [UIView animateWithDuration:0.2 animations:^{
        self.itemInputField.frame = CGRectMake(10, 30, self.backgroundView.frame.size.width - 70, self.itemInputField.frame.size.height);
        
    } completion:^(BOOL finished) {
        self.dismissBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.backgroundView.frame.size.width - 50, 30, 40, self.itemInputField.frame.size.height)];
        self.dismissBtn.backgroundColor = [UIColor clearColor];
        [self.dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.dismissBtn setTitleColor:kAppTextColor forState:UIControlStateNormal];
        [self.dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.dismissBtn];
        
        self.confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.backgroundView.frame.size.width - 50, 30, 40, self.itemInputField.frame.size.height)];
        self.confirmBtn.backgroundColor = [UIColor clearColor];
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:kAppTextColor forState:UIControlStateNormal];
        [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        self.confirmBtn.hidden = YES;
        [self.backgroundView addSubview:self.confirmBtn];
        
        [self.itemInputField becomeFirstResponder];
    }];
}

#pragma mark - Private

- (void)dismiss {
    if (self.dismissBlock) {
        [self.dismissBtn removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            self.itemInputField.frame = self.initialPosition;
            
        } completion:^(BOOL finished) {
            self.dismissBlock();
        }];
    }
}

- (void)confirm {
    CMLLog(@"confirm");
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *newText = textField.text.mutableCopy;
    [newText replaceCharactersInRange:range withString:string];
    if (newText.length > 0) {
        self.confirmBtn.hidden = NO;
        self.dismissBtn.hidden = YES;
        
    } else {
        self.confirmBtn.hidden = YES;
        self.dismissBtn.hidden = NO;
    }
    
    return YES;
}

@end
