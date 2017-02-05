//
//  ItemInputViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "ItemInputViewController.h"

@interface ItemInputViewController ()

@property (nonatomic, assign) CGRect initialPosition;


@property (nonatomic, strong) UIView *testItemInputField;

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.initialPosition.size.width > 0 && self.initialPosition.size.height > 0) {
        self.testItemInputField = [[UIView alloc]initWithFrame:self.initialPosition];
        self.testItemInputField.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.testItemInputField];
        
    } else {
        CMLLog(@"需要使用initWithInitialPosition:方法先指定inputField的初始位置");
    }
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
