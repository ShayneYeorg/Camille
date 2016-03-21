//
//  CMLRecordViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/2/20.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordViewController.h"
#import "CMLRecordCell.h"
#import "CMLRecordCellModel.h"
#import "CMLRecordMonthDetailViewController.h"

@interface CMLRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewDataArr;

@end

@implementation CMLRecordViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetails];
    [self configTableViewData];
    [self configTableView];
}

#pragma mark - UI Configuration

- (void)configDetails {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)configTableViewData {
    self.tableViewDataArr = @[
                              @[
                                  @{
                                      @"icon": @"record_icon_selected",
                                      @"title": @"收支明细（月份）"
                                      }
                                  ],
                              @[
                                  @{
                                      @"icon": @"record_icon_selected",
                                      @"title": @"科目设置"
                                      }
                                  ]
                              ];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGB(245, 245, 240);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *currentCellDic = self.tableViewDataArr[indexPath.section][indexPath.row];
    NSString *currentTitle = currentCellDic[@"title"];
    if ([currentTitle isEqualToString:@"收支明细（月份）"]) {
        CMLRecordMonthDetailViewController *recordMonthDetailViewController = [CMLRecordMonthDetailViewController new];
        [self.navigationController pushViewController:recordMonthDetailViewController animated:YES];
        
    } else if ([currentTitle isEqualToString:@"科目设置"]) {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *currentSectionArr = self.tableViewDataArr[section];
    return currentSectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *currentCellDic = self.tableViewDataArr[indexPath.section][indexPath.row];
    CMLRecordCellModel *model = [CMLRecordCellModel mj_objectWithKeyValues:currentCellDic];
    
    CMLRecordCell *cell = [CMLRecordCell loadFromNib];
    cell.model = model;
    cell.backgroundColor = kAppViewColor;
    return cell;
}

@end
