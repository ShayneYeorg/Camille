//
//  AccountAddingViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/25.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "AccountAddingViewController.h"

@interface AccountAddingViewController ()

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation AccountAddingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configDetail];
    [self configBackgroundView];
    [self configBackButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configDetail {
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)configBackgroundView {
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(viewWidth*0.05, viewHeight*0.05, viewWidth*0.9, viewHeight*0.9)];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
}

- (void)configBackButton {
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(self.backgroundView.frame.size.width - ScaleOn375(50), 0, ScaleOn375(50), ScaleOn375(50))];
    b.backgroundColor = [UIColor clearColor];
    [b setBackgroundImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:b];
}

#pragma mark - Private

- (void)click {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

