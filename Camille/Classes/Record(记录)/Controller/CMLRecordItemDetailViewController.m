//
//  CMLRecordItemDetailViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/5/17.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordItemDetailViewController.h"
#import "CMLRecordItemDetailModel.h"
#import "CMLRecordDetailHeaderView.h"
#import "CMLRecordItemDetailSectionHeaderView.h"
#import "CMLRecordDetailCell.h"
#import "CMLRecordDetailDatePickerView.h"
#import "SVProgressHUD.h"

#define kRecordDetailDatePickerBGViewTag 20160517210127

@interface CMLRecordItemDetailViewController () <UITableViewDelegate, UITableViewDataSource, CMLRecordDetailHeaderViewDelegate, CMLRecordDetailDatePickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CMLRecordDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) NSDate *fetchDate; //查询条件
@property (nonatomic, strong) CMLRecordDetailDatePickerView *recordDetailDatePickerView;
@property (nonatomic, strong) CMLRecordItemDetailModel *itemModel; //数据模型
@property (nonatomic, strong) NSDictionary *itemsContrastDic; //存放所有itemID和item的对应关系
@property (nonatomic, assign) BOOL isItemsContrastDicReady; //所有itemID和item的对应关系已取出

@end

@implementation CMLRecordItemDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetails];
    [self configBarBtn];
    [self configTableView];
    
    [self fetchAllItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configDetails {
    self.title = @"科目收支明细";
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
//                [weakSelf refreshView];
                
            } else {
                [SVProgressHUD showErrorWithStatus:response.desc];
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"查询二级记账科目名称出错！"];
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
    [self.tableHeaderView refreshPickDate:self.fetchDate];
//    [self fetchData];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CMLRecordItemDetailSectionHeaderView *sectionHeaderView = [CMLRecordItemDetailSectionHeaderView loadFromNib];
//    CMLRecordMonthDetailSectionModel *currentSection = self.monthModel.detailSections[section];
//    [sectionHeaderView refreshDate:[NSString stringWithFormat:@"%@号", currentSection.setionDay]];
//    [sectionHeaderView refreshCost:[NSString stringWithFormat:@"%.2f", currentSection.cost]];
//    [sectionHeaderView refreshIncome:[NSString stringWithFormat:@"%.2f", currentSection.income]];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.monthModel.detailSections.count;
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    CMLRecordMonthDetailSectionModel *currentSection = self.monthModel.detailSections[section];
//    return currentSection.detailCells.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMLRecordDetailCell *cell = [CMLRecordDetailCell loadFromNib];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kAppViewColor;
    
//    CMLRecordMonthDetailSectionModel *currentSection = self.monthModel.detailSections[indexPath.section];
//    cell.model = currentSection.detailCells[indexPath.row];
//    if ([self.itemsContrastDic.allKeys containsObject:cell.model.itemID]) {
//        [cell refreshItemName:self.itemsContrastDic[cell.model.itemID]];
//    } else {
//        [cell refreshItemName:@"获取科目出错"];
//    }
    
    return cell;
}


@end




