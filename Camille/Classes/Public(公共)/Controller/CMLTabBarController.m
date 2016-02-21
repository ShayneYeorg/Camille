//
//  CMLTabBarController.m
//  Camille
//
//  Created by 杨淳引 on 16/2/20.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLTabBarController.h"
#import "CMLNavigationController.h"
#import "CMLAccountingViewController.h"
#import "CMLRecordViewController.h"

@implementation CMLTabBarController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self detailsOfViewDidLoad];
}

#pragma mark - Private

- (void)detailsOfViewDidLoad{
    //初始化子控制器，这里指定了程序会有几个页面
    CMLAccountingViewController *accountingViewController = [[CMLAccountingViewController alloc] init];
    [self addChildVc:accountingViewController navTitle:@"Camille" tabbarTitle:@"记账" image:@"accounting_icon" selectedImage:@"accounting_icon_selected"];
    
    CMLRecordViewController *recordViewController = [[CMLRecordViewController alloc] init];
    [self addChildVc:recordViewController navTitle:@"账务明细" tabbarTitle:@"明细" image:@"record_icon" selectedImage:@"record_icon_selected"];
}

- (void)addChildVc:(UIViewController *)childVc navTitle:(NSString *)navTitle tabbarTitle:(NSString *)tabbarTitle image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //设置子控制器的文字
    childVc.tabBarItem.title = tabbarTitle; // 设置tabbar的文字
    childVc.navigationItem.title = navTitle; // 设置navigationBar的文字
    
    //设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置tabBar文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kAppTextCoclor;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = kAppTextCoclor;
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    //给子控制器上面包装一个导航控制器
    CMLNavigationController *nav = [[CMLNavigationController alloc] initWithRootViewController:childVc];
    
    //添加导航控制器为子控制器
    [self addChildViewController:nav];
}

@end
