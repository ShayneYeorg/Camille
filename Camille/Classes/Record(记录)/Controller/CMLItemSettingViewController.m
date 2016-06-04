//
//  CMLItemSettingViewController.m
//  Camille
//
//  Created by 杨淳引 on 16/5/29.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLItemSettingViewController.h"
#import "CMLItemCategorySettingCell.h"

@interface CMLItemSettingViewController ()

@property (nonatomic, strong) CMLItemCategory *category;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation CMLItemSettingViewController

static NSString *cellID = @"ItemSettingCell";

#pragma mark - Life Cycle

- (instancetype)initWithCategory:(CMLItemCategory *)category {
    if ([self init]) {
        self.category = category;
        self.title = category.categoryName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetails];
    [self configBarBtn];
    [self configTableView];
    [self fetchItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configDetails {
    self.tableView.backgroundColor = RGB(245, 245, 240);
    self.tableView.allowsSelection = NO;
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
    [self.tableView setTableFooterView:[UIView new]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - Private

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteCellInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Core Data

- (void)fetchItems {
    [CMLCoreDataAccess fetchAllItemsInCategory:self.category.categoryID callBack:^(CMLResponse *response) {
        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
            self.items = response.responseDic[@"items"];
            [self.items removeObjectAtIndex:0];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCellInTableView:tableView indexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMLItemCategorySettingCell *cell = [CMLItemCategorySettingCell loadFromNibWithTableView:tableView];
    CMLItem *item = self.items[indexPath.row];
    cell.cellText.text = item.itemName;
    cell.arrow.hidden = YES;
    
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
