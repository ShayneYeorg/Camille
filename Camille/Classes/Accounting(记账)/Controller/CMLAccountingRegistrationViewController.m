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
@property (nonatomic, strong) NSDictionary *itemsDic; //第一个cell右菜单使用的数据
@property (nonatomic, strong) NSArray *categoryModels; //第一个cell左菜单的模型

@end

@implementation CMLAccountingRegistrationViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kAppViewColor;
    [self configViewDetails];
    [self configTitle];
    [self configBarBtns];
    [self configTableView];
    
    //一进来就请求数据
    [self fetchItemsData];
}

- (void)dealloc {
    CMLLog(@"dealloc");
}

- (void)tempBackUp {
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)configViewDetails {
    self.isItemCellExpand = YES;
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

#pragma mark - AsyncFetchData

- (void)fetchItemsData {
    __weak typeof(self) weakSelf = self;
    __block BOOL isItemsFetchFinish = NO;
    __block BOOL isCategoriesFetchFinish = NO;
    
    [CMLCoreDataAccess fetchAllItems:^(CMLResponse *response) {
        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
            NSDictionary *dic = response.responseDic;
            weakSelf.itemsDic = dic[@"items"];
            isItemsFetchFinish = YES;
            if (isItemsFetchFinish && isCategoriesFetchFinish) {
                [weakSelf reloadDataItemsCell];
            }
        }
    }];
    
    [CMLCoreDataAccess fetchAllItemCategories:^(CMLResponse *response) {
        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
            NSDictionary *dic = response.responseDic;
            weakSelf.categoryModels = dic[@"categories"];
            isCategoriesFetchFinish = YES;
            if (isItemsFetchFinish && isCategoriesFetchFinish) {
                [weakSelf reloadDataItemsCell];
            }
        }
    }];
}

- (void)reloadDataItemsCell {
    CMLLog(@"reloadDataItemsCell");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
        static NSString *ID = @"AccountingItemCell";
        CMLAccountingItemCell *accountingItemCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!accountingItemCell) {
            accountingItemCell = [CMLAccountingItemCell loadFromNib];
            accountingItemCell.delegate = self;
            accountingItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            accountingItemCell.backgroundColor = kCellBackgroundColor;
        }
        [accountingItemCell refreshWithCatogoryModels:self.categoryModels itemsDic:self.itemsDic isExpand:self.isItemCellExpand];
        return accountingItemCell;
        
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





