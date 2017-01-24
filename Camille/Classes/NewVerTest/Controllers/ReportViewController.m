//
//  ReportViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "ReportViewController.h"
#import "UIViewController+CMLTransition.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    b.backgroundColor = [UIColor redColor];
    [b setTitle:@"click" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    UIButton *b2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 50)];
    b2.backgroundColor = [UIColor blackColor];
    [b2 setTitle:@"go" forState:UIControlStateNormal];
    [b2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b2];
}

- (void)click2 {
    [self CML_presentViewController:[[ReportViewController alloc] init] transitionType:CMLTransitionAnimationBacklashThenPush completion:nil];
}

- (void)click {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
