//
//  AccountAddingViewController.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/25.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "AccountAddingViewController.h"
#import "ItemInputViewController.h"

@interface AccountAddingViewController () <UITextFieldDelegate>

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

@property (nonatomic, strong) UITextField *amountInputField;

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
    self.itemInputField = [[UIView alloc]initWithFrame:CGRectMake(20, 30 + ScaleOn375(30), self.backgroundView.frame.size.width - 40, ScaleOn375(30))];
    self.itemInputField.backgroundColor = RGB(230, 230, 230);
    self.itemInputField.layer.cornerRadius = 5;
    self.itemInputField.clipsToBounds = YES;
    [self.backgroundView addSubview:self.itemInputField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemInput)];
    [self.itemInputField addGestureRecognizer:tap];
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
    
    ItemInputViewController *itemInputViewController = [ItemInputViewController initWithInitialPosition:newFrame itemType:self.itemType];
    [self addChildViewController:itemInputViewController];
    [self.view addSubview:itemInputViewController.view];
    
    __weak ItemInputViewController *weakItemInputViewController = itemInputViewController;
    itemInputViewController.dismissBlock = ^(NSString *itemID) {
        [weakItemInputViewController.view removeFromSuperview];
        [weakItemInputViewController removeFromParentViewController];
        
        if (itemID && itemID.length) {
            //选择了某个item
            CMLLog(@"选择的itemID是：%@", itemID);
        }
    };
}

- (void)back {
    [self endEditing];
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end

