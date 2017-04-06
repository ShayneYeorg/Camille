//
//  MonthSummaryByItemReport.m
//  Camille
//
//  Created by 杨淳引 on 2017/4/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "MonthSummaryByItemReport.h"
#import "CMLReportManager.h"

@interface MonthSummaryByItemReport () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *items;

@end

@implementation MonthSummaryByItemReport

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBackgroundView];
    [self configTableView];
    
    [self fetchMonthSummaryWithDate:[NSDate date]];
    [self fetchItemsDataWithDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Configuration

- (void)configBackgroundView {
    self.backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.backgroundView.frame style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = RGB(244, 244, 244);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.backgroundView addSubview:self.tableView];
}

#pragma mark - Fetch Data

- (void)fetchMonthSummaryWithDate:(NSDate *)date {
    
}

- (void)fetchItemsDataWithDate:(NSDate *)date {
    [CMLReportManager fetchMonthItemSummaryWithDate:date callback:^(CMLResponse *response) {
        
    }];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = @"cell";
    return cell;
}

@end
