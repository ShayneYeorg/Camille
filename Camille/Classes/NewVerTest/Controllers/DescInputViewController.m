//
//  DescInputViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "DescInputViewController.h"

@interface DescInputViewController () <UITextViewDelegate>

@property (nonatomic, assign) CGRect initialPosition;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UITextView *descInputField;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation DescInputViewController

#pragma mark - Life Cycle

+ (instancetype)initWithInitialPosition:(CGRect)initialPosition {
    DescInputViewController *descInputViewController = [DescInputViewController new];
    descInputViewController.initialPosition = initialPosition;
    return descInputViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBackgroundView];
    [self addKeyboardNotification];
    if (self.initialPosition.size.width > 0 && self.initialPosition.size.height) {
        self.descInputField = [[UITextView alloc]initWithFrame:self.initialPosition];
        self.descInputField.delegate = self;
        self.descInputField.backgroundColor = RGB(230, 230, 230);
        self.descInputField.layer.cornerRadius = 5;
        self.descInputField.clipsToBounds = YES;
        [self.backgroundView addSubview:self.descInputField];
        
        [self configInitialAnamation];
        
    } else {
        CMLLog(@"需要使用initWithInitialPosition:方法先指定inputField的初始位置");
    }
}

- (void)dealloc {
    CMLLog(@"%s", __func__);
    [self removeKeyboardNotification];

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
        self.descInputField.frame = CGRectMake(10, 30, self.backgroundView.frame.size.width - 20, self.backgroundView.frame.size.height - 80);
        
    } completion:^(BOOL finished) {
        self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.backgroundView.frame.size.width - 60, self.descInputField.frame.size.height + self.descInputField.frame.origin.y + 10, 50, 30)];
        self.cancelButton.backgroundColor = [UIColor clearColor];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:kAppTextColor forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.cancelButton];
        
        self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake(self.backgroundView.frame.size.width - 60, self.descInputField.frame.size.height + self.descInputField.frame.origin.y + 10, 50, 30)];
        self.saveButton.backgroundColor = [UIColor clearColor];
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.saveButton setTitleColor:kAppTextColor forState:UIControlStateNormal];
        [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.saveButton];
        self.saveButton.hidden = YES;
        
        [self.descInputField becomeFirstResponder];
    }];
}

#pragma mark - Private

- (void)cancel {
    if (self.dismissBlock) {
        [self.cancelButton removeFromSuperview];
        [self.saveButton removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            self.descInputField.frame = self.initialPosition;
            
        } completion:^(BOOL finished) {
            self.dismissBlock(nil);
        }];
    }
}

- (void)save {
    if (self.dismissBlock) {
        [self.cancelButton removeFromSuperview];
        [self.saveButton removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            self.descInputField.frame = self.initialPosition;
            
        } completion:^(BOOL finished) {
            self.dismissBlock(self.descInputField.text);
        }];
    }
}

#pragma mark - Keyboard Notification

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    
    self.descInputField.frame = CGRectMake(self.descInputField.frame.origin.x, self.descInputField.frame.origin.y, self.descInputField.frame.size.width, self.backgroundView.frame.size.height - 80 - keyboardRect.size.height);
    
    self.cancelButton.frame = CGRectMake(self.backgroundView.frame.size.width - 60, self.descInputField.frame.size.height + self.descInputField.frame.origin.y + 10, 50, 30);
    
    self.saveButton.frame = CGRectMake(self.backgroundView.frame.size.width - 60, self.descInputField.frame.size.height + self.descInputField.frame.origin.y + 10, 50, 30);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.descInputField.frame = CGRectMake(self.descInputField.frame.origin.x, self.descInputField.frame.origin.y, self.descInputField.frame.size.width, self.backgroundView.frame.size.height - 80);
    
    self.cancelButton.frame = CGRectMake(self.backgroundView.frame.size.width - 60, self.descInputField.frame.size.height + self.descInputField.frame.origin.y + 10, 50, 30);
    
    self.saveButton.frame = CGRectMake(self.backgroundView.frame.size.width - 60, self.descInputField.frame.size.height + self.descInputField.frame.origin.y + 10, 50, 30);
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *newText = textView.text.mutableCopy;
    [newText replaceCharactersInRange:range withString:text];
    if (newText.length > 0) {
        self.saveButton.hidden = NO;
        self.cancelButton.hidden = YES;
        
    } else {
        self.saveButton.hidden = YES;
        self.cancelButton.hidden = NO;
    }
    
    return YES;
}

@end
