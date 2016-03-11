//
//  CMLNavigationController.m
//  Camille
//
//  Created by 杨淳引 on 16/2/20.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLNavigationController.h"

@implementation CMLNavigationController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDetails];
}

#pragma mark - Private

- (void)configDetails {
    //指定导航控制器的背景色为程序统一色
    self.navigationBar.barTintColor = kAppColor;
    
    // 设置navigationBar标题的颜色
    NSMutableDictionary *navTitleAttrs = [NSMutableDictionary dictionary];
    navTitleAttrs[NSForegroundColorAttributeName] = kAppTextColor;
    [self.navigationBar setTitleTextAttributes:navTitleAttrs];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
