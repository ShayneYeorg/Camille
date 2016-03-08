//
//  CMLNewItemAddingView.m
//  Camille
//
//  Created by 杨淳引 on 16/3/8.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLNewItemAddingView.h"
#import "SVProgressHUD.h"

#define kNewItemAddingViewWidth   250
#define kNewItemAddingViewHeight  180
#define kBackGroundViewTag        1603081938

@interface CMLNewItemAddingView () <UITextFieldDelegate>

@property (nonatomic, strong) NewItemAddingClickHandler clickHandler;

@property (weak, nonatomic) IBOutlet UITextField *itemInputField; //请输入科目名称
@property (weak, nonatomic) IBOutlet UITextField *categoryInputField; //所属分类

@end

@implementation CMLNewItemAddingView

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLNewItemAddingView *view = [[NSBundle mainBundle]loadNibNamed:@"CMLNewItemAddingView" owner:self options:nil][0];
    [view setFrame:CGRectMake((kScreen_Width - kNewItemAddingViewWidth) * 0.5, kScreen_Height * 0.2, kNewItemAddingViewWidth, kNewItemAddingViewHeight)];
    view.backgroundColor = kAppViewColor;
    
    return view;
}

- (void)showWithClickHandler:(NewItemAddingClickHandler)clickHandler {
    self.clickHandler = clickHandler;
    
    UIWindow *window = [CMLTool getWindow];
    UIView *backgroundView = [[UIView alloc]initWithFrame:window.bounds];
    backgroundView.tag = kBackGroundViewTag;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.7;
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewTap)];
    [backgroundView addGestureRecognizer:tap];
    
    [window addSubview:self];
    self.itemInputField.delegate = self;
    self.categoryInputField.delegate = self;
}

#pragma mark - Private

- (void)backgroundViewTap {
    if ([self.itemInputField isFirstResponder] || [self.categoryInputField isFirstResponder]) {
        [self endEditing:YES];
        
    } else {
        UIWindow *window = [CMLTool getWindow];
        [[window viewWithTag:kBackGroundViewTag] removeFromSuperview];
        if (self) [self removeFromSuperview];
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    if (!self.itemInputField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入科目名称"];
        
    } else if (!self.categoryInputField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入所属分类"];
        
    } else if (self.clickHandler) {
        self.clickHandler(self.itemInputField.text, self.categoryInputField.text);
        [self backgroundViewTap];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.itemInputField) {
        [self.categoryInputField becomeFirstResponder];
        
    } else {
        [self.categoryInputField resignFirstResponder];
    }
    return YES;
}

@end
