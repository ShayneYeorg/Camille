//
//  AccountAddingViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/25.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "AccountAddingViewController.h"
#import "ItemInputViewController.h"

@interface AccountAddingViewController ()

@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSDate *happenTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *itemID;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, copy) NSString *itemType;
@property (nonatomic, strong) UIView *itemTypeBtn;
@property (nonatomic, strong) UILabel *costLabel;
@property (nonatomic, strong) UILabel *incomeLabel;

@property (nonatomic, strong) UIView *itemInputField;

@end

@implementation AccountAddingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetail];
    [self configBackgroundView];
    [self configBackButton];
    [self configItemTypeBtn];
    [self configItemInputField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configDetail {
    self.view.backgroundColor = [UIColor clearColor];
    self.itemType = Item_Type_Cost;
}

- (void)configBackgroundView {
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(viewWidth*0.05, viewHeight*0.05, viewWidth*0.9, viewHeight*0.9)];
    self.backgroundView.layer.cornerRadius = 10;
    self.backgroundView.clipsToBounds = YES;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
}

- (void)configBackButton {
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(self.backgroundView.frame.size.width - ScaleOn375(50), 0, ScaleOn375(50), ScaleOn375(50))];
    b.backgroundColor = [UIColor clearColor];
    [b setBackgroundImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:b];
}

- (void)configItemTypeBtn {
    self.itemTypeBtn = [[UIView alloc]initWithFrame:CGRectMake((self.backgroundView.frame.size.width - ScaleOn375(100)) / 2, 10, ScaleOn375(100), ScaleOn375(30))];
    self.itemTypeBtn.backgroundColor = [UIColor redColor];
    
    self.costLabel = [[UILabel alloc]init];
    self.costLabel.text = @"支出";
    [self.costLabel sizeToFit];
    [self.itemTypeBtn addSubview:self.costLabel];
    
    self.incomeLabel = [[UILabel alloc]init];
    self.incomeLabel.text = @"收入";
    [self.incomeLabel sizeToFit];
    self.incomeLabel.hidden = YES;
    [self.itemTypeBtn addSubview:self.incomeLabel];
    
    [self.backgroundView addSubview:self.itemTypeBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchItemType)];
    [self.itemTypeBtn addGestureRecognizer:tap];
}

- (void)configItemInputField {
    self.itemInputField = [[UIView alloc]initWithFrame:CGRectMake(20, 30 + ScaleOn375(30), self.backgroundView.frame.size.width - 40, ScaleOn375(30))];
    self.itemInputField.backgroundColor = RGB(230, 230, 230);
    self.itemInputField.layer.cornerRadius = 5;
    self.itemInputField.clipsToBounds = YES;
    [self.backgroundView addSubview:self.itemInputField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemInput)];
    [self.itemInputField addGestureRecognizer:tap];
}

#pragma mark - Private

- (void)switchItemType {
    if ([self.itemType isEqualToString:Item_Type_Cost]) {
        self.itemType = Item_Type_Income;
        self.costLabel.hidden = YES;
        self.incomeLabel.hidden = NO;
        
    } else {
        self.itemType = Item_Type_Cost;
        self.costLabel.hidden = NO;
        self.incomeLabel.hidden = YES;
    }
}

- (void)itemInput {
    CGRect newFrame = [self.backgroundView convertRect:self.itemInputField.frame toView:self.view];
    
    ItemInputViewController *itemInputViewController = [ItemInputViewController initWithInitialPosition:newFrame];
    [self addChildViewController:itemInputViewController];
    [self.view addSubview:itemInputViewController.view];
    
    __weak ItemInputViewController *weakItemInputViewController = itemInputViewController;
    itemInputViewController.dismissBlock = ^{
        [weakItemInputViewController.view removeFromSuperview];
        [weakItemInputViewController removeFromParentViewController];
    };
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

