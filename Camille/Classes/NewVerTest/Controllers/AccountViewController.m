//
//  AccountViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "AccountViewController.h"
#import "Accounting+CoreDataClass.h"
#import "CMLDisplayTextField.h"
#import "CMLAmountTextField.h"
#import "CMLDateTextField.h"
#import "ItemInputViewController.h"
#import "DescInputViewController.h"

#define kBtnHeight 50
#define kIntevalV  20

@interface AccountViewController ()

@property (nonatomic, strong) MainCellModel *mainCellModel;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSDate *happenTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *itemID;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) CMLDisplayTextField *itemTextField;
@property (nonatomic, strong) CMLAmountTextField *amountTextField;
@property (nonatomic, strong) CMLDateTextField *dateTextField;
@property (nonatomic, strong) CMLDisplayTextField *descTextField;

@end

@implementation AccountViewController

#pragma mark - Life Cycle

- (instancetype)initWithAccounting:(MainCellModel *)mainCellModel {
    self = [super init];
    if (self) {
        self.mainCellModel = mainCellModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBackgroundView];
    [self configDetails];
    [self configConfirmBtn];
    [self configDeleteBtn];
    [self configCancelBtn];
    
    [self configTypeLabel];
    [self configItemTextField];
    [self configAmountTextField];
    [self configDateTextField];
    [self configDescTextField];
}

- (void)dealloc {
    CMLLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configBackgroundView {
    self.backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [self.backgroundView addGestureRecognizer:tap];
}

- (void)configDetails {
    self.amount = self.mainCellModel.accounting.amount;
    self.happenTime = self.mainCellModel.accounting.happenTime;
    self.desc = self.mainCellModel.accounting.desc;
    self.itemID = self.mainCellModel.accounting.itemID;
}

- (void)configConfirmBtn {
    self.confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.backgroundView.height - kBtnHeight, kScreen_Width / 2, kBtnHeight)];
    self.confirmBtn.backgroundColor = RGB(76, 155, 41);
    [self.confirmBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.hidden = YES;
    [self.backgroundView addSubview:self.confirmBtn];
}

- (void)configDeleteBtn {
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.backgroundView.height - kBtnHeight, kScreen_Width / 2, kBtnHeight)];
    self.deleteBtn.backgroundColor = [UIColor redColor];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteAccounting) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.deleteBtn];
}

- (void)configCancelBtn {
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width / 2, self.backgroundView.height - kBtnHeight, kScreen_Width / 2, kBtnHeight)];
    self.cancelBtn.backgroundColor = [UIColor whiteColor];
    self.cancelBtn.layer.borderColor = RGB(200, 200, 200).CGColor;
    self.cancelBtn.layer.borderWidth = 0.5;
    [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.cancelBtn];
}

- (void)configTypeLabel {
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.backgroundView.frame.size.width - ScaleOn375(100)) / 2, 30, ScaleOn375(100), ScaleOn375(30))];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    if ([self.mainCellModel.itemType isEqualToString:Item_Type_Cost]) {
        self.typeLabel.text = @"支出";
        
    } else {
        self.typeLabel.text = @"收入";
    }
    [self.backgroundView addSubview:self.typeLabel];
}

- (void)configItemTextField {
    DECLARE_WEAK_SELF
    self.itemTextField = [CMLDisplayTextField loadDisplayTextFieldWithFrame:CGRectMake(20, self.typeLabel.y + self.typeLabel.height + kIntevalV, self.backgroundView.frame.size.width - 40, ScaleOn375(30)) backgroundColor:RGB(230, 230, 230) placeHolder:@"项目" touchAction:^{
        [weakSelf didEdit];
        [weakSelf itemInput];
    }];
    [self.backgroundView addSubview:self.itemTextField];
    [self.itemTextField refreshWithText:self.mainCellModel.displayItemName];
}

- (void)configAmountTextField {
    DECLARE_WEAK_SELF
    self.amountTextField = [CMLAmountTextField loadAmountTextFieldWithFrame:CGRectMake(20, self.itemTextField.y + self.itemTextField.height + kIntevalV, self.backgroundView.frame.size.width - 40, ScaleOn375(30)) backgroundColor:RGB(230, 230, 230) placeHolder:@"金额" endEditAction:^(NSNumber *amout) {
        [weakSelf didEdit];
        weakSelf.amount = amout;
    }];
    [self.backgroundView addSubview:self.amountTextField];
    [self.amountTextField refreshWithNumber:self.amount];
}

- (void)configDateTextField {
    DECLARE_WEAK_SELF
    self.dateTextField = [CMLDateTextField loadDateTextFieldWithFrame:CGRectMake(20, self.amountTextField.y + self.amountTextField.height + kIntevalV, self.backgroundView.frame.size.width - 40, ScaleOn375(30)) backgroundColor:RGB(230, 230, 230) above:self.view touchAction:^{
        [weakSelf endEdit];
        
    } selectedDateAction:^(NSDate *selectedDate) {
        weakSelf.happenTime = selectedDate;
    }];
    [self.backgroundView addSubview:self.dateTextField];
}

- (void)configDescTextField {
    DECLARE_WEAK_SELF
    CGFloat descTextFieldX = 20;
    CGFloat descTextFieldY = self.dateTextField.y + self.dateTextField.height + kIntevalV;
    CGFloat descTextFieldW = self.backgroundView.frame.size.width - 40;
    CGFloat descTextFieldH = self.backgroundView.height - kBtnHeight - kIntevalV - descTextFieldY;
    self.descTextField = [CMLDisplayTextField loadDisplayTextFieldWithFrame:CGRectMake(descTextFieldX, descTextFieldY, descTextFieldW, descTextFieldH) backgroundColor:RGB(230, 230, 230) placeHolder:@"备注" touchAction:^{
        [weakSelf didEdit];
        [weakSelf descInput];
    }];
    [self.backgroundView addSubview:self.descTextField];
    [self.descTextField refreshWithText:self.desc];
}

#pragma mark - Private

- (void)endEdit {
    [self.view endEditing:YES];
}

- (void)didEdit {
    [self showConfirmBtn];
}

- (void)confirm {
    
}

- (void)deleteAccounting {
    
}

- (void)cancel {
    [self endEdit];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showConfirmBtn {
    self.confirmBtn.hidden = NO;
    self.deleteBtn.hidden = YES;
}

- (void)itemInput {
    CGRect newFrame = [self.backgroundView convertRect:self.itemTextField.frame toView:self.view];
    
    ItemInputViewController *itemInputViewController = [ItemInputViewController initWithInitialPosition:newFrame itemType:self.mainCellModel.itemType initialText:[self.itemTextField currentText]];
    [self addChildViewController:itemInputViewController];
    [self.view addSubview:itemInputViewController.view];
    
    DECLARE_WEAK_SELF
    __weak ItemInputViewController *weakItemInputViewController = itemInputViewController;
    itemInputViewController.dismissBlock = ^(NSString *itemID, NSString *itemName) {
        [weakItemInputViewController.view removeFromSuperview];
        [weakItemInputViewController removeFromParentViewController];
        if (itemID && itemID.length) {
            weakSelf.itemID = itemID;
        }
        [weakSelf.itemTextField refreshWithText:itemName];
    };
}

- (void)descInput {
    CGRect newFrame = [self.backgroundView convertRect:self.descTextField.frame toView:self.view];
    
    DescInputViewController *descInputViewController = [DescInputViewController initWithInitialPosition:newFrame initialText:self.desc];
    [self addChildViewController:descInputViewController];
    [self.view addSubview:descInputViewController.view];
    
    __weak DescInputViewController *weakDescInputViewController = descInputViewController;
    descInputViewController.dismissBlock = ^(NSString *desc) {
        [weakDescInputViewController.view removeFromSuperview];
        [weakDescInputViewController removeFromParentViewController];
        
        if (desc && desc.length) {
            self.desc = desc;
            [self.descTextField refreshWithText:desc];
            
        } else {
            self.desc = @"";
            [self.descTextField refreshWithText:@""];
        }
    };
}

@end
