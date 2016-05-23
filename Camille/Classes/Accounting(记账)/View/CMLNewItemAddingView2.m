//
//  CMLNewItemAddingView2.m
//  Camille
//
//  Created by 杨淳引 on 16/3/8.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLNewItemAddingView2.h"
#import "SVProgressHUD.h"

#define kNewItemAddingViewWidth   250
#define kNewItemAddingViewHeight  180
#define kBackGroundViewTag        1603081938

@interface CMLNewItemAddingView2 () <UITextFieldDelegate>

@property (nonatomic, strong) NewItemAddingClickHandler2 clickHandler;

@property (weak, nonatomic) IBOutlet UITextField *itemInputField; //请输入科目名称
@property (weak, nonatomic) IBOutlet UITextField *categoryInputField; //所属分类

@end

@implementation CMLNewItemAddingView2

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLNewItemAddingView2 *view = [[NSBundle mainBundle]loadNibNamed:@"CMLNewItemAddingView2" owner:self options:nil][0];
    [view setFrame:CGRectMake((kScreen_Width - kNewItemAddingViewWidth) * 0.5, kScreen_Height * 0.2, kNewItemAddingViewWidth, kNewItemAddingViewHeight)];
    view.backgroundColor = kAppViewColor;
    
    return view;
}

- (void)showWithClickHandler:(NewItemAddingClickHandler2)clickHandler {
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
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showErrorWithStatus:@"请输入科目名称"];
        
    } else if (!self.categoryInputField.text.length) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
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
