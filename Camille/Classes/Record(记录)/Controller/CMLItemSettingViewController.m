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
@property (nonatomic, strong) CMLItem *listHeadItem; //链表头科目

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
    CMLItem *lastItem;
    CMLItem *currentItem = self.items[indexPath.row];
    CMLItem *nextItem;
    
    if (indexPath.row == 0) {
        lastItem = self.listHeadItem;
        if (self.items.count == 1) {
            nextItem = nil;
        } else {
            nextItem = self.items[indexPath.row+1];
        }
    
    } else if (indexPath.row == self.items.count-1) {
        nextItem = nil;
        if (self.items.count == 1) {
            lastItem = self.listHeadItem;
        } else {
            lastItem = self.items[indexPath.row-1];
        }
        
    } else {
        lastItem = self.items[indexPath.row-1];
        nextItem = self.items[indexPath.row+1];
    }
    
    CMLLog(@"lastItemName: %@", lastItem.itemName);
    CMLLog(@"itemName: %@", currentItem.itemName);
    CMLLog(@"nextItemName: %@", nextItem.itemName);
    
    [self.items removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
//    [CMLCoreDataAccess deleteAccounting:currentAccounting callBack:^(CMLResponse *response) {
//        if ([response.code isEqualToString:RESPONSE_CODE_FAILD]) {
//            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//            [SVProgressHUD showErrorWithStatus:response.desc];
//        }
//    }];
}

#pragma mark - Core Data

- (void)fetchItems {
    [CMLCoreDataAccess fetchAllItemsInCategory:self.category.categoryID type:self.category.categoryType callBack:^(CMLResponse *response) {
        __weak typeof(self) weakSelf = self;
        if (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
            weakSelf.items = response.responseDic[@"items"];
            weakSelf.listHeadItem = weakSelf.items[0];
            [weakSelf.items removeObjectAtIndex:0];
            [weakSelf.tableView reloadData];
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
