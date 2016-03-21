//
//  CMLRecordMonthDetailViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/3/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordMonthDetailViewController.h"
#import "CMLRecordDetailHeaderView.h"

@interface CMLRecordMonthDetailViewController () <UITableViewDelegate, UITableViewDataSource, CMLRecordDetailHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CMLRecordDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) NSDate *fetchDate;

@end

@implementation CMLRecordMonthDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetails];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configDetails {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
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

#pragma mark - Core Data

- (void)fetchData {
    
}

#pragma mark - CMLRecordDetailHeaderViewDelegate

- (void)recordDetailHeaderViewDidTap:(CMLRecordDetailHeaderView *)recordDetailHeaderView {
    CMLLog(@"tap");
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

@end
