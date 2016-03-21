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
@property (nonatomic, strong) NSArray *recordCellModels;

@end

@implementation CMLRecordViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetails];
    [self configTableView];
}

#pragma mark - UI Configuration

- (void)configDetails {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGB(245, 245, 240);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

#pragma mark - Getter

- (NSArray *)recordCellModels {
    if (_recordCellModels == nil) {
        CMLRecordCellModel *cellModel1 = nil;
        CMLRecordCellModel *cellModel2 = nil;
        CMLRecordCellModel *cellModel3 = nil;
        _recordCellModels = [NSArray arrayWithObjects:cellModel1, cellModel2, cellModel3, nil];
    }
    return _recordCellModels;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
        
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = kAppViewColor;
    return cell;
}

@end
