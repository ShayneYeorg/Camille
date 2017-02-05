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
    if (self.initialPosition.size.width > 0 && self.initialPosition.size.height) {
        self.descInputField = [[UITextView alloc]initWithFrame:self.initialPosition];
        self.descInputField.delegate = self;
        self.descInputField.backgroundColor = RGB(230, 230, 230);
        self.descInputField.layer.cornerRadius = 5;
        self.descInputField.clipsToBounds = YES;
        [self.backgroundView addSubview:self.descInputField];
        self.descInputField.text = @"备注";
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
        self.descInputField.frame = CGRectMake(10, 30, self.backgroundView.frame.size.width - 20, self.backgroundView.frame.size.height - 60);
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
