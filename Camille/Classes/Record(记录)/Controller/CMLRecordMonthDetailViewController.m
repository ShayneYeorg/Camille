//
//  CMLRecordMonthDetailViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordMonthDetailViewController.h"
#import "CMLRecordDetailHeaderView.h"
#import "CMLRecordDetailSectionHeaderView.h"
#import "CMLRecordDetailCell.h"
#import "CMLRecordDetailDatePickerView.h"
#import "CMLRecordMonthDetailModel.h"
#import "SVProgressHUD.h"

#define kRecordDetailDatePickerBGViewTag 2016032403

@interface CMLRecordMonthDetailViewController () <UITableViewDelegate, UITableViewDataSource, CMLRecordDetailHeaderViewDelegate, CMLRecordDetailDatePickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CMLRecordDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) NSDate *fetchDate; //查询条件
@property (nonatomic, strong) CMLRecordDetailDatePickerView *recordDetailDatePickerView;
@property (nonatomic, strong) CMLRecordMonthDetailModel *monthModel; //数据模型
@property (nonatomic, strong) NSDictionary *itemsContrastDic; //存放所有itemID和item的对应关系
@property (nonatomic, assign) BOOL isItemsContrastDicReady; //所有itemID和item的对应关系已取出

@end

@implementation CMLRecordMonthDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetails];
    [self configBarBtn];
    [self configTableView];
    
    [self fetchAllItems];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configDetails {
    self.title = @"日收支明细";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isItemsContrastDicReady = NO;
    self.fetchDate = [NSDate date];
    [self.tableHeaderView refreshPickDate:self.fetchDate];
}

- (void)configBarBtn {
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 0, 44, 44);
    [cancleBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:kAppTextColor forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB(245, 245, 240);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configTableHeaderView];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)configTableHeaderView {
    self.tableHeaderView = [CMLRecordDetailHeaderView loadFromNib];
    self.tableHeaderView.delegate = self;
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)refreshView {
    if (self.isItemsContrastDicReady) {
        [self.tableHeaderView refreshPickDate:self.fetchDate];
        NSString *totalCost = [NSString stringWithFormat:@"%.2f", self.monthModel.totalCost];
        NSString *totalIncome = [NSString stringWithFormat:@"%.2f", self.monthModel.totalIncome];
        [self.tableHeaderView refreshTotalCost:totalCost];
        [self.tableHeaderView refreshTotalIncome:totalIncome];
        
        [self.tableView reloadData];
    }
}

#pragma mark - Private

- (void)cancle {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addDatePickerBGView {
    UIView *datePickerBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kRecordDetailDatePickerViewHeight)];
    datePickerBGView.backgroundColor = [UIColor clearColor];
    datePickerBGView.tag = kRecordDetailDatePickerBGViewTag;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(datePickerBGViewTap)];
    [datePickerBGView addGestureRecognizer:tap];
    
    UIWindow *window = [CMLTool getWindow];
    [window addSubview:datePickerBGView];
}

- (void)datePickerBGViewTap {
    UIWindow *window = [CMLTool getWindow];
    [self.recordDetailDatePickerView dismiss];
    [[window viewWithTag:kRecordDetailDatePickerBGViewTag] removeFromSuperview];
}

#pragma mark - Getter

- (CMLRecordDetailDatePickerView *)recordDetailDatePickerView {
    if (_recordDetailDatePickerView == nil) {
        _recordDetailDatePickerView = [CMLRecordDetailDatePickerView loadFromNib];
        _recordDetailDatePickerView.delegate = self;
        [self.view addSubview:_recordDetailDatePickerView];
    }
    return _recordDetailDatePickerView;
}

- (NSDictionary *)itemsContrastDic {
    if (!_itemsContrastDic) {
        _itemsContrastDic = [NSDictionary dictionary];
    }
    return _itemsContrastDic;
}

#pragma mark - Core Data

- (void)fetchAllItems {
    __weak typeof(self) weakSelf = self;
    [CMLCoreDataAccess fetchAllItems:^(CMLResponse *response) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        if (response) {
            if ([response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
                weakSelf.itemsContrastDic = response.responseDic[@"items"];
                weakSelf.isItemsContrastDicReady = YES;
                [weakSelf refreshView];
                
            } else {
                [SVProgressHUD showErrorWithStatus:response.desc];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"查询二级记账科目名称出错！"];
        }
    }];
}

- (void)fetchData {
    __weak typeof(self) weakSelf = self;
    [CMLCoreDataAccess fetchAccountingDetailsOnMonth:self.fetchDate callBack:^(CMLResponse *response) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        if (response) {
            if ([response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
                weakSelf.monthModel = response.responseDic[@"monthModel"];
                [weakSelf refreshView];
                
            } else {
                [SVProgressHUD showErrorWithStatus:response.desc];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"查询账务出错！"];
        }
    }];
}

#pragma mark - CMLRecordDetailHeaderViewDelegate

- (void)recordDetailHeaderViewDidTap:(CMLRecordDetailHeaderView *)recordDetailHeaderView {
    [self.recordDetailDatePickerView show];
    [self addDatePickerBGView];
}

#pragma mark - CMLRecordDetailDatePickerViewDelegate

- (void)recordDetailDatePickerView:(CMLRecordDetailDatePickerView *)recordDetailDatePickerView didClickConfirmBtn:(NSDate *)selectedDate {
    self.fetchDate = selectedDate;
    [self fetchData];
    [self datePickerBGViewTap];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CMLRecordDetailSectionHeaderView *sectionHeaderView = [CMLRecordDetailSectionHeaderView loadFromNib];
    CMLRecordMonthDetailSectionModel *currentSection = self.monthModel.detailSections[section];
    [sectionHeaderView refreshDate:[NSString stringWithFormat:@"%@号", currentSection.setionDay]];
    [sectionHeaderView refreshCost:[NSString stringWithFormat:@"%.2f", currentSection.cost]];
    [sectionHeaderView refreshIncome:[NSString stringWithFormat:@"%.2f", currentSection.income]];
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCellInTableView:tableView indexPath:indexPath];
    }
}

- (void)deleteCellInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    CMLRecordMonthDetailSectionModel *currentSection = self.monthModel.detailSections[indexPath.section];
    CMLAccounting *currentAccounting = currentSection.detailCells[indexPath.row];
    
    if ([currentAccounting.type isEqualToString:Item_Type_Cost]) {
        currentSection.cost -= [currentAccounting.amount floatValue];
    } else {
        currentSection.income -= [currentAccounting.amount floatValue];
    }
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    [currentSection.detailCells removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    if (currentSection.detailCells.count == 0) {
        [self.monthModel.detailSections removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.monthModel.detailSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CMLRecordMonthDetailSectionModel *currentSection = self.monthModel.detailSections[section];
    return currentSection.detailCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMLRecordDetailCell *cell = [CMLRecordDetailCell loadFromNib];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kAppViewColor;
    
    CMLRecordMonthDetailSectionModel *currentSection = self.monthModel.detailSections[indexPath.section];
    cell.model = currentSection.detailCells[indexPath.row];
    if ([self.itemsContrastDic.allKeys containsObject:cell.model.itemID]) {
        [cell refreshItemName:self.itemsContrastDic[cell.model.itemID]];
    } else {
        [cell refreshItemName:@"获取科目出错"];
    }
    
    return cell;
}

@end
