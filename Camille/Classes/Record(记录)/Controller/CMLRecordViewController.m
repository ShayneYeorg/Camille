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
                                      @"icon": @"",
                                      @"title": @"零零"
                                      },
                                  @{
                                      @"icon": @"",
                                      @"title": @"零一"
                                      }
                                  ],
                              
                              @[
                                  @{
                                      @"icon": @"",
                                      @"title": @"一零"
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *currentSectionArr = self.tableViewDataArr[section];
    return currentSectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *currentSectionArr = self.tableViewDataArr[indexPath.section];
    NSDictionary *currentCellDic = currentSectionArr[indexPath.row];
    CMLRecordCellModel *model = [CMLRecordCellModel mj_objectWithKeyValues:currentCellDic];
    
    CMLRecordCell *cell = [CMLRecordCell loadFromNib];
    cell.model = model;
    cell.backgroundColor = kAppViewColor;
    return cell;
}

@end
