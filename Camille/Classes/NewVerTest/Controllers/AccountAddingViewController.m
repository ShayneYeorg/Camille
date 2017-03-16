//
//  AccountAddingViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/25.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "AccountAddingViewController.h"
#import "ItemInputViewController.h"
#import "DescInputViewController.h"
#import "CMLTool+NSDate.h"
#import "CMLAccountingDatePickerView.h"
#import "CMLDataManager.h"
#import "CMLDisplayTextField.h"

@interface AccountAddingViewController () <UITextFieldDelegate, CMLAccountingDatePickerViewDelegate>

@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSDate *happenTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *itemID;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, copy) NSString *itemType;
@property (nonatomic, strong) UIView *itemTypeBtn;
@property (nonatomic, strong) UILabel *costLabel;
@property (nonatomic, strong) UILabel *incomeLabel;

@property (nonatomic, strong) CMLDisplayTextField *itemInputField;

@property (nonatomic, strong) UITextField *amountInputField;

@property (nonatomic, strong) UIView *dateInputField;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) CMLAccountingDatePickerView *datePickerView;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIView *descInputField;

@end

@implementation AccountAddingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetail];
    [self configBackgroundView];
    [self configBackButton];
    [self configItemTypeBtn];
    [self configItemInputField];
    [self configAmountInputField];
    [self configDateInputField];
    [self configSaveButton];
    [self configDescInputField];
}

- (void)dealloc {
    CMLLog(@"%s", __func__);
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
    [self.backgroundView addGestureRecognizer:tap];
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
    DECLARE_WEAK_SELF
    self.itemInputField = [CMLDisplayTextField loadDisplayTextFieldWithFrame:CGRectMake(20, 30 + ScaleOn375(30), self.backgroundView.frame.size.width - 40, ScaleOn375(30)) backgroundColor:RGB(230, 230, 230) placeHolder:@"项目" touchAction:^{
        [weakSelf itemInput];
    }];
    [self.backgroundView addSubview:self.itemInputField];
}

- (void)configAmountInputField {
    self.amountInputField = [[UITextField alloc]initWithFrame:CGRectMake(20, 50 + ScaleOn375(60), self.backgroundView.frame.size.width - 40, ScaleOn375(30))];
    self.amountInputField.delegate = self;
    self.amountInputField.keyboardType = UIKeyboardTypeDecimalPad;
    self.amountInputField.backgroundColor = RGB(230, 230, 230);
    self.amountInputField.layer.cornerRadius = 5;
    self.amountInputField.clipsToBounds = YES;
    [self.backgroundView addSubview:self.amountInputField];
    self.amountInputField.placeholder = @"金额";
}

- (void)configDateInputField {
    self.dateInputField = [[UIView alloc]initWithFrame:CGRectMake(20, 70 + ScaleOn375(90), self.backgroundView.frame.size.width - 40, ScaleOn375(30))];
    self.dateInputField.backgroundColor = RGB(230, 230, 230);
    self.dateInputField.layer.cornerRadius = 5;
    self.dateInputField.clipsToBounds = YES;
    [self.backgroundView addSubview:self.dateInputField];
    
    self.dateLabel = [[UILabel alloc]initWithFrame:self.dateInputField.bounds];
    self.dateLabel.textColor = RGB(170, 170, 170);
    [self.dateInputField addSubview:self.dateLabel];
    [self chooseDate:[NSDate date]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker)];
    [self.dateInputField addGestureRecognizer:tap];
}

- (void)configSaveButton {
    self.saveButton = [[UIButton alloc]initWithFrame:CGRectMake((self.backgroundView.frame.size.width - ScaleOn375(100)) / 2, self.backgroundView.frame.size.height - 20 - ScaleOn375(30), ScaleOn375(100), ScaleOn375(30))];
    self.saveButton.backgroundColor = [UIColor greenColor];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:self.saveButton];
}

- (void)configDescInputField {
    self.descInputField = [[UIView alloc]initWithFrame:CGRectMake(20, 90 + ScaleOn375(120), self.backgroundView.frame.size.width - 40, self.saveButton.origin.y - 20 - self.dateInputField.origin.y - ScaleOn375(30) - 20)];
    self.descInputField.backgroundColor = RGB(230, 230, 230);
    self.descInputField.layer.cornerRadius = 10;
    self.descInputField.clipsToBounds = YES;
    [self.backgroundView addSubview:self.descInputField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(descInput)];
    [self.descInputField addGestureRecognizer:tap];
}

#pragma mark - Getter

- (CMLAccountingDatePickerView *)datePickerView {
    if (_datePickerView == nil) {
        _datePickerView = [CMLAccountingDatePickerView loadFromNib];
        _datePickerView.delegate = self;
        [self.view addSubview:_datePickerView];
    }
    return _datePickerView;
}

#pragma mark - Private

- (void)endEditing {
    [self.view endEditing:YES];
}

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
    
    ItemInputViewController *itemInputViewController = [ItemInputViewController initWithInitialPosition:newFrame itemType:self.itemType initialText:[self.itemInputField currentText]];
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
        [weakSelf.itemInputField refreshWithText:itemName];
    };
}

- (void)back {
    [self endEditing];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showDatePicker {
    [self endEditing];
    [self.datePickerView show];
}

- (void)chooseDate:(NSDate *)date {
    self.happenTime = date;
    NSString *dateStr = [CMLTool transDateToString:date];
    self.dateLabel.text = dateStr;
}

- (void)save {
    //1、检查各个项目是否齐全
    if (!self.itemID.length || !self.amount || !self.happenTime) {
        CMLLog(@"项目缺失");
        return;
    }
    
    //2、保存
    if (!self.desc) {
        self.desc = @"";
    }
    DECLARE_WEAK_SELF
    [CMLDataManager addAccountingWithItemID:self.itemID amount:self.amount happneTime:self.happenTime desc:self.desc callBack:^(CMLResponse * _Nonnull response) {
        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
            if (weakSelf.saveSuccessCallback) {
                weakSelf.saveSuccessCallback();
            }
            [weakSelf back];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存出错！"];
        }
    }];
}

- (void)descInput {
    CGRect newFrame = [self.backgroundView convertRect:self.descInputField.frame toView:self.view];
    
    DescInputViewController *descInputViewController = [DescInputViewController initWithInitialPosition:newFrame];
    [self addChildViewController:descInputViewController];
    [self.view addSubview:descInputViewController.view];
    
    __weak DescInputViewController *weakDescInputViewController = descInputViewController;
    descInputViewController.dismissBlock = ^(NSString *desc) {
        [weakDescInputViewController.view removeFromSuperview];
        [weakDescInputViewController removeFromParentViewController];
        
        if (desc && desc.length) {
            self.desc = desc;
        }
    };
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.amountInputField) {
        //检测输入内容是否合法
        for (NSUInteger i = 0; i < [string length]; i++) {
            unichar character = [string characterAtIndex:i];
            if ((character < '0' || character > '9') && character != '.') {
                CMLLog(@"输入了非法字符");
                return NO;
            }
        }
        return YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.amountInputField) {
        if (!self.amountInputField.text.length) {
            return;
            
        } else {
            //是否有小数点？
            NSString *searchText = textField.text;
            NSError *pointError = NULL;
            NSRegularExpression *pointRegex = [NSRegularExpression regularExpressionWithPattern:@"[.]" options:NSRegularExpressionCaseInsensitive error:&pointError];
            NSTextCheckingResult *result = [pointRegex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
            if (result) {
                //有小数点
                //小数点前有数字没？没有就补上0
                NSError *zeroBeforePointError = NULL;
                NSRegularExpression *zeroBeforePointRegex = [NSRegularExpression regularExpressionWithPattern:@"[0-9][.]" options:NSRegularExpressionCaseInsensitive error:&zeroBeforePointError];
                NSTextCheckingResult *zeroBeforePointResult = [zeroBeforePointRegex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
                if (!zeroBeforePointResult) {
                    //小数点前没数字，补上个0
                    textField.text = [NSString stringWithFormat:@"0%@", textField.text];
                }
                
                //小数点后有数字没？没有就补上00
                NSError *zeroAfterPointError = NULL;
                NSRegularExpression *zeroAfterPointRegex = [NSRegularExpression regularExpressionWithPattern:@"[.][0-9]" options:NSRegularExpressionCaseInsensitive error:&zeroAfterPointError];
                NSTextCheckingResult *zeroAfterPointResult = [zeroAfterPointRegex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
                if (!zeroAfterPointResult) {
                    //小数点后没数字，补上00
                    textField.text = [NSString stringWithFormat:@"%@00", textField.text];
                }
                
                //小数点只有一个数字？补上0
                NSError *oneNumAfterPointError = NULL;
                NSRegularExpression *oneNumAfterPointRegex = [NSRegularExpression regularExpressionWithPattern:@"[.][0-9]$" options:NSRegularExpressionCaseInsensitive error:&oneNumAfterPointError];
                NSTextCheckingResult *oneNumAfterPointResult = [oneNumAfterPointRegex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
                if (oneNumAfterPointResult) {
                    //小数点只有一个数字，补上0
                    textField.text = [NSString stringWithFormat:@"%@0", textField.text];
                }
                
            } else {
                //无小数点，补上小数点和后两位
                textField.text = [NSString stringWithFormat:@"%@.00", textField.text];
            }
            
            //最终保存金额
            self.amount = [NSNumber numberWithFloat:textField.text.floatValue];
        }
    }
}

#pragma mark - CMLAccountingDatePickerViewDelegate

- (void)accountingDatePickerView:(CMLAccountingDatePickerView *)accountingDatePickerView didClickConfirmBtn:(NSDate *)selectedDate {
    [self chooseDate:selectedDate];
    [self.datePickerView dismiss];
}

@end

