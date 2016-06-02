//
//  CMLCategorySettingViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/5/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLCategorySettingViewController.h"
#import "CMLItemSettingViewController.h"
#import "CMLItemCategorySettingHeaderView.h"
#import "CMLItemCategorySettingCell.h"

@interface CMLCategorySettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *costCategoryModels;
@property (nonatomic, strong) NSMutableArray *incomeCategoryModels;

@end

@implementation CMLCategorySettingViewController

static NSString *cellID = @"categoryCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetails];
    [self configBarBtn];
    [self configTableView];
    [self fetchCatogories];
}

- (void)dealloc {
    CMLLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configDetails {
    self.title = @"科目设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)configBarBtn {
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 0, 44, 44);
    [cancleBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:kAppTextColor forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancleBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB(245, 245, 240);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

#pragma mark - Private

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Core Data

- (void)fetchCatogories {
    __weak typeof(self) weakSelf = self;
    __block BOOL isCostCategoriesFetchFinish = NO;
    __block BOOL isIncomeCategoriesFetchFinish = NO;
    
    [CMLCoreDataAccess fetchAllItemCategories:Item_Type_Income callBack:^(CMLResponse *response) {
        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
            NSDictionary *dic = response.responseDic;
            weakSelf.incomeCategoryModels = dic[@"categories"];
            [weakSelf.incomeCategoryModels removeObjectAtIndex:0];
            isIncomeCategoriesFetchFinish = YES;
            if (isCostCategoriesFetchFinish && isIncomeCategoriesFetchFinish) {
                [weakSelf.tableView reloadData];
            }
        }
    }];
    
    [CMLCoreDataAccess fetchAllItemCategories:Item_Type_Cost callBack:^(CMLResponse *response) {
        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
            NSDictionary *dic = response.responseDic;
            weakSelf.costCategoryModels = dic[@"categories"];
            [weakSelf.costCategoryModels removeObjectAtIndex:0]; //去掉“设置”
            isCostCategoriesFetchFinish = YES;
            if (isCostCategoriesFetchFinish && isIncomeCategoriesFetchFinish) {
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CMLItemSettingViewController *itemSettingViewController = [CMLItemSettingViewController new];
    [self.navigationController pushViewController:itemSettingViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CMLItemCategorySettingHeaderView *itemCategorySettingHeaderView = [CMLItemCategorySettingHeaderView loadFromNib];
    if (section == 0) {
        itemCategorySettingHeaderView.titleText.text = @"收入";
    } else {
        itemCategorySettingHeaderView.titleText.text = @"支出";
    }
    return itemCategorySettingHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.incomeCategoryModels.count;
    } else {
        return self.costCategoryModels.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMLItemCategorySettingCell *cell = [CMLItemCategorySettingCell loadFromNibWithTableView:tableView];
    if (indexPath.section == 0) {
        CMLItemCategory *category = self.incomeCategoryModels[indexPath.row];
        cell.cellText.text = category.categoryName;
        
    } else {
        CMLItemCategory *category = self.costCategoryModels[indexPath.row];
        cell.cellText.text = category.categoryName;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
