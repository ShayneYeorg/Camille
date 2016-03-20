//
//  CMLAccountingRegistrationViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/2/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingRegistrationViewController.h"
#import "CMLAccountingItemCell.h"
#import "CMLAccountingAmountCell.h"
#import "CMLAccountingDateCell.h"
#import "CMLAccountingDatePickerView.h"
#import "SVProgressHUD.h"

#define kDatePickerBGViewTag        201603141611
#define kAmountCellEditingBGViewTag 201603151414

@interface CMLAccountingRegistrationViewController () <UITableViewDelegate, UITableViewDataSource, CMLAccountingItemCellDelegate, CMLAccountingAmountCellDelegate, CMLAccountingDatePickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isItemCellExpand;
@property (nonatomic, strong) NSDictionary *itemsDic; //第一个cell右菜单使用的数据
@property (nonatomic, strong) NSArray *categoryModels; //第一个cell左菜单的模型
@property (nonatomic, strong) CMLAccountingDatePickerView *datePickerView; //日期选择view

@property (nonatomic, strong) CMLItem *selectedItem; //选中的item
@property (nonatomic, strong) CMLItem *lastSelectedItem; //上一次选中的item
@property (nonatomic, assign) CGFloat amount; //金额
@property (nonatomic, strong) NSDate *happenDate; //账务发生时间

@end

@implementation CMLAccountingRegistrationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViewDetails];
    [self configTitle];
    [self configBarBtns];
    [self configTableView];
    //一进来就请求数据
    [self fetchItemsData];
    [self addKeyboardNotifications];
}

- (void)dealloc {
    CMLLog(@"dealloc");
    [self removeKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configTitle {
    self.title = @"收入";
    if ([self.type isEqualToString:Item_Type_Cost]) {
        self.title = @"支出";
    }
}

- (void)configViewDetails {
    self.view.backgroundColor = kAppViewColor;
    self.isItemCellExpand = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)configBarBtns {
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 0, 44, 44);
    [cancleBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:kAppTextColor forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 44, 44);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kAppTextColor forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64)];
    self.tableView.backgroundColor = kAppViewColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - Notification

- (void)addKeyboardNotifications {
    //主要是为了金额cell
    //UIKeyboardWillShowNotification键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAmountCellEditingBGView) name:UIKeyboardWillShowNotification object:nil];
    //UIKeyboardWillHideNotification 键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAmountCellEditingBGView) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Private

#pragma mark -- 科目cell

//只刷新科目cell的数据，不更改状态（展开或收起）
- (void)reloadItemCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

//刷新科目cell的数据并更改状态（展开或收起）
- (void)reloadItemCellWithExpandAction {
    self.isItemCellExpand = !self.isItemCellExpand;
    [self reloadItemCell];
}

#pragma mark -- 金额cell

//这块蒙板只挡住NavigationBar
- (void)addAmountCellEditingBGView {
    //如果科目cell展开着，就收起它
    if(self.isItemCellExpand) {
        [self reloadItemCellWithExpandAction];
    }
    
    //添加amountCellEditingBGView
    UIView *amountCellEditingBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    amountCellEditingBGView.backgroundColor = [UIColor clearColor];
    amountCellEditingBGView.tag = kAmountCellEditingBGViewTag;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(amountCellEditingBGViewTap)];
    [amountCellEditingBGView addGestureRecognizer:tap];
    
    UIWindow *window = [CMLTool getWindow];
    [window addSubview:amountCellEditingBGView];
}

- (void)amountCellEditingBGViewTap {
    [self.view endEditing:YES];
}

- (void)removeAmountCellEditingBGView {
    UIWindow *window = [CMLTool getWindow];
    [[window viewWithTag:kAmountCellEditingBGViewTag] removeFromSuperview];
}

//获取金额cell
- (CMLAccountingAmountCell *)getAmountCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CMLAccountingAmountCell *amountCell = [self.tableView cellForRowAtIndexPath:indexPath];
    return amountCell;
}

#pragma mark -- 日期cell

//根据参数date刷新日期cell的数据
- (void)refreshDateCellWithDate:(NSDate *)date {
    self.happenDate = date;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    CMLAccountingDateCell *accountingDateCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [accountingDateCell refreshDateLabelWithDate:self.happenDate];
}

- (void)addDatePickerBGView {
    UIView *datePickerBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kPickerViewHeight)];
    datePickerBGView.backgroundColor = [UIColor clearColor];
    datePickerBGView.tag = kDatePickerBGViewTag;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(datePickerBGViewTap)];
    [datePickerBGView addGestureRecognizer:tap];
    
    UIWindow *window = [CMLTool getWindow];
    [window addSubview:datePickerBGView];
}

- (void)datePickerBGViewTap {
    UIWindow *window = [CMLTool getWindow];
    [self.datePickerView dismiss];
    [[window viewWithTag:kDatePickerBGViewTag] removeFromSuperview];
}

#pragma mark -- NavigationBar上的按钮

- (void)save {
    //是否已选择账务
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    if (!self.selectedItem) {
        [SVProgressHUD showErrorWithStatus:@"请先选择科目"];
        return;
    }
    
    //是否已有金额
    CMLAccountingAmountCell *accountCell = [self getAmountCell];
    if (!accountCell) {
        CMLLog(@"获取金额cell出错");
        return;
        
    } else if (![accountCell isAmountAvailable]) {
        //输入金额格式有误
        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
        return;
    }
    
    //已保存过账务
    if (self.lastSelectedItem) {
        //判断是否重复保存
        if (self.selectedItem.objectID == self.lastSelectedItem.objectID) {
            //可能是重复保存，提示是否确定保存
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"您刚才已经记过一笔%@的帐了，确定还要保存吗？",self.selectedItem.itemName] preferredStyle:UIAlertControllerStyleAlert];
            
            __weak typeof(self) weakSelf = self;
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"还要保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CMLLog(@"还要保存");
                [weakSelf addAccounting];
            }];
            [alertController addAction:saveAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不保存了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                CMLLog(@"不保存了");
            }];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } else {
        //没保存过账务
        [self addAccounting];
    }
}

- (void)cancle {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter

- (NSArray *)categoryModels {
    if (_categoryModels == nil) {
        _categoryModels = [NSArray array];
    }
    return _categoryModels;
}

- (NSDictionary *)itemsDic {
    if (_itemsDic == nil) {
        _itemsDic = [NSDictionary dictionary];
    }
    return _itemsDic;
}

- (CMLAccountingDatePickerView *)datePickerView {
    if (_datePickerView == nil) {
        _datePickerView = [CMLAccountingDatePickerView loadFromNib];
        _datePickerView.delegate = self;
        [self.view addSubview:_datePickerView];
    }
    return _datePickerView;
}

#pragma mark - Core Data

- (void)fetchItemsData {
    __weak typeof(self) weakSelf = self;
    __block BOOL isItemsFetchFinish = NO;
    __block BOOL isCategoriesFetchFinish = NO;
    
    [CMLCoreDataAccess fetchAllItems:self.type callBack:^(CMLResponse *response) {
        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
            NSDictionary *dic = response.responseDic;
            weakSelf.itemsDic = dic[@"items"];
            isItemsFetchFinish = YES;
            if (isItemsFetchFinish && isCategoriesFetchFinish) {
                [weakSelf reloadItemCell];
            }
        }
    }];
    
    [CMLCoreDataAccess fetchAllItemCategories:self.type callBack:^(CMLResponse *response) {
        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
            NSDictionary *dic = response.responseDic;
            weakSelf.categoryModels = dic[@"categories"];
            isCategoriesFetchFinish = YES;
            if (isItemsFetchFinish && isCategoriesFetchFinish) {
                [weakSelf reloadItemCell];
            }
        }
    }];
}

- (void)addItem:(NSString *)itemName inCategory:(NSString *)catogoryName {
    __weak typeof(self) weakSelf = self;
    [CMLCoreDataAccess addItem:itemName inCategory:catogoryName type:self.type callBack:^(CMLResponse *response) {
        if (response) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            if ([response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
                [SVProgressHUD showSuccessWithStatus:response.desc];
                [weakSelf fetchItemsData];
                [[[CMLTool getWindow] viewWithTag:kNewItemAddingViewTag] removeFromSuperview];
                
            } else if ([response.code isEqualToString:RESPONSE_CODE_FAILD]) {
                [SVProgressHUD showErrorWithStatus:response.desc];
            }
        }
    }];
}

- (void)addAccounting {
    [CMLCoreDataAccess addAccountingWithItem:self.selectedItem.itemID amount:[NSNumber numberWithFloat:self.amount] type:self.type happneTime:self.happenDate callBack:^(CMLResponse *response) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        if (response) {
            if ([response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
                [SVProgressHUD showSuccessWithStatus:response.desc];
                self.lastSelectedItem = self.selectedItem;
                
            } else {
                [SVProgressHUD showErrorWithStatus:response.desc];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"保存出错，请重新保存！"];
        }
    }];
}

#pragma mark - CMLAccountingItemCellDelegate

- (void)accountingItemCellDidTapExpandArea:(CMLAccountingItemCell *)accountingItemCell {
    [self reloadItemCellWithExpandAction];
    [self.view endEditing:YES];
}

- (void)accountingItemCell:(CMLAccountingItemCell *)accountingItemCell shouldSelectItem:(CMLItem *)item {
    self.selectedItem = item;
}

- (void)accountingItemCell:(CMLAccountingItemCell *)accountingItemCell didSelectItem:(CMLItem *)item {
    //金额cell becomeFirstResponder
    NSIndexPath *amountCellIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    CMLAccountingAmountCell *accountingAmountCell = [self.tableView cellForRowAtIndexPath:amountCellIndex];
    [accountingAmountCell.amountTextField becomeFirstResponder];
}

- (void)accountingItemCell:(CMLAccountingItemCell *)accountingItemCell didAddItem:(NSString *)itemName inCaterogy:(NSString *)categoryName {
    [self addItem:itemName inCategory:categoryName];
}

#pragma mark - CMLAccountingAmountCellDelegate

- (void)accountingAmountCell:(CMLAccountingAmountCell *)accountingAmountCell DidEndEditing:(CGFloat)amount {
    self.amount = amount;
}

#pragma mark - CMLAccountingDatePickerViewDelegate

- (void)accountingDatePickerView:(CMLAccountingDatePickerView *)accountingDatePickerView didClickConfirmBtn:(NSDate *)selectedDate {
    [self refreshDateCellWithDate:selectedDate];
    [self datePickerBGViewTap];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [CMLAccountingItemCell heightForCellByExpand:self.isItemCellExpand];
        
    } else if (indexPath.row == 3) {
        return 250;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    //日期选择cell
    if (indexPath.row == 2) {
        //如果科目cell展开着，就收起它
        if(self.isItemCellExpand) {
            [self reloadItemCellWithExpandAction];
        }
        
        //出现上拉框
        [self.datePickerView show];
        [self addDatePickerBGView];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *ID = @"AccountingItemCell";
        CMLAccountingItemCell *accountingItemCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!accountingItemCell) {
            accountingItemCell = [CMLAccountingItemCell loadFromNib];
            accountingItemCell.type = self.type;
            accountingItemCell.delegate = self;
            accountingItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            accountingItemCell.backgroundColor = kCellBackgroundColor;
        }
        [accountingItemCell refreshWithCatogoryModels:self.categoryModels itemsDic:self.itemsDic isExpand:self.isItemCellExpand selectedItem:self.selectedItem];
        return accountingItemCell;
        
    } else if (indexPath.row == 1) {
        CMLAccountingAmountCell *accountingAmountCell = [CMLAccountingAmountCell loadFromNib];
        accountingAmountCell.delegate = self;
        accountingAmountCell.selectionStyle = UITableViewCellSelectionStyleNone;
        accountingAmountCell.backgroundColor = kCellBackgroundColor;
        return accountingAmountCell;
        
    } else if (indexPath.row == 2) {
        CMLAccountingDateCell *accountingDateCell = [CMLAccountingDateCell loadFromNib];
        accountingDateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        accountingDateCell.backgroundColor = kCellBackgroundColor;
        self.happenDate = [NSDate date];
        [accountingDateCell refreshDateLabelWithDate:self.happenDate];
        return accountingDateCell;
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kCellBackgroundColor;
        return cell;
    }
}

@end


