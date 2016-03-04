//
//  CMLAccountingRegistrationViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/2/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingRegistrationViewController.h"
#import "CMLAccountingItemCell.h"

@interface CMLAccountingRegistrationViewController () <UITableViewDelegate, UITableViewDataSource, CMLAccountingItemCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isItemCellExpand;

@end

@implementation CMLAccountingRegistrationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //手动添加完整记账项目
//    [CMLCoreDataAccess addItem:@"鞋子" inCategory:@"衣物" callBack:^(CMLResponse *response) {
//        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
//            CMLLog(@"%@", response.responseDic[@"itemID"]);
//        }
//    }];

    //手动添加一级记账科目
//    [CMLCoreDataAccess addItemCategory:@"房租" callBack:^(CMLResponse *response) {
//        if ([response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
//            CMLLog(@"%@", response.responseDic[@"itemCategoryID"]);
//        }
//    }];
    
    //手动添加二级记账科目
//    [CMLCoreDataAccess addItem:@"weyg" categoryID:@"1" callBack:^(CMLResponse *response) {
//        if ([response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
//            CMLLog(@"%@", response.responseDic[@"itemID"]);
//        }
//    }];

    //取出二级记账科目（已排序）
//    [CMLCoreDataAccess fetchAllItems:^(CMLResponse *response) {
//        NSDictionary *dic = response.responseDic;
//        NSDictionary *itemsDic = dic[@"items"];
//        NSArray *dicAllKeys = itemsDic.allKeys;
//        for (int i = 0; i < dicAllKeys.count; i++) {
//            NSString *cid = dicAllKeys[i];
//            CMLLog(@"分类：%@", cid);
//            NSArray *a = (NSArray *)itemsDic[cid];
//            for (CMLItem *i in a) {
//                CMLLog(@"%@", i.itemID);
//            }
//        }
//    }];
    
    //取出一级记账科目（已排序）
//    [CMLCoreDataAccess fetchAllItemCategories:^(CMLResponse *response) {
//        NSDictionary *dic = response.responseDic;
//        NSArray *arr = dic[@"items"];
//        for (int i = 0; i < arr.count; i++) {
//            CMLLog(@"%@", ((CMLItemCategory *)arr[i]).categoryID);
//        }
//    }];
    
    self.view.backgroundColor = kAppViewColor;
    [self configViewDetails];
    [self configTitle];
    [self configBarBtns];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)configViewDetails {
    self.isItemCellExpand = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)configTitle {
    self.title = @"收入";
    if (self.type == Accounting_Type_Cost) {
        self.title = @"支出";
    }
}

- (void)configBarBtns {
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 0, 44, 44);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:kAppTextCoclor forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 44, 44);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kAppTextCoclor forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)cancle {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    
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

#pragma mark - CMLAccountingItemCellDelegate

- (void)accountingItemCellDidTapExpandArea:(CMLAccountingItemCell *)accountingItemCell {
    self.isItemCellExpand = !self.isItemCellExpand;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:accountingItemCell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CMLAccountingItemCell *cell = [CMLAccountingItemCell loadFromNib];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kCellBackgroundColor;
        [cell refreshWithExpand:self.isItemCellExpand];
        return cell;
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 3) {
            cell.backgroundColor = kAppViewColor;
            
        } else {
            cell.backgroundColor = kCellBackgroundColor;
        }
        return cell;
    }
}

@end





