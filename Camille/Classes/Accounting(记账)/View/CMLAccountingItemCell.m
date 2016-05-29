//
//  CMLAccountingItemCell.m
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#define kTopViewHeight       50
#define kBottomViewHeight    250

#import "CMLAccountingItemCell.h"
#import "CMLAccountingItemLeftCell.h"
#import "CMLAccountingItemRightCell.h"
//#import "CMLNewItemAddingView.h"
#import "CMLNewItemAddingView2.h"

@interface CMLAccountingItemCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topView; //上部区域
@property (weak, nonatomic) IBOutlet UIView *bottomView; //选择项目的区域
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTableViewWidthContraint;//左菜单的宽度约束
@property (weak, nonatomic) IBOutlet UIView *topViewBottomSepLine; //顶部区域的下分割线
@property (weak, nonatomic) IBOutlet UILabel *topViewText; //topView的文字

@property (nonatomic, strong) NSIndexPath *leftTableViewSelectedIndexPath;//左菜单选中项
@property (nonatomic, strong) NSIndexPath *leftTableViewLastSelectedIndexPath;//左菜单上一次选中项
@property (nonatomic, strong) NSArray *categoryModels; //左菜单的模型
@property (nonatomic, strong) NSDictionary *itemsDic; //右菜单的模型
@property (nonatomic, strong) NSArray *itemsModel; //当前所显示右菜单的模型

@end

@implementation CMLAccountingItemCell

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLAccountingItemCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CMLAccountingItemCell" owner:self options:nil] firstObject];
    cell.topView.backgroundColor = kCellBackgroundColor;
    
    return cell;
}

+ (CGFloat)heightForCellByExpand:(BOOL)isExpand {
    if (isExpand) {
        return kTopViewHeight + kBottomViewHeight + 0.5;
        
    } else {
        return kTopViewHeight + 0.5;
    }
}

- (void)refreshWithCatogoryModels:(NSArray *)categoryModels itemsDic:(NSDictionary *)itemsDic isExpand:(BOOL)isExpand selectedItem:(CMLItem *)item {
    if (item) {
        self.topViewText.text = item.itemName;
    } else {
        self.topViewText.text = @"选择科目";
    }
    
    if (isExpand) {
        self.bottomView.hidden = NO;
        self.topViewBottomSepLine.hidden = YES;
        self.categoryModels = categoryModels;
        self.itemsDic = itemsDic;
        
        self.leftTableViewSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.leftTableViewLastSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.itemsModel = self.itemsDic[@"1"];
        if (self.categoryModels.count > 1) {
            self.leftTableViewSelectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            self.leftTableViewLastSelectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            
            CMLItemCategory *secondCategory = self.categoryModels[1];
            self.itemsModel = self.itemsDic[secondCategory.categoryID];
        }
        
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
        
    } else {
        self.bottomView.hidden = YES;
        self.topViewBottomSepLine.hidden = NO;
    }
}

- (void)refreshTopViewText:(NSString *)itemName {
    self.topViewText.text = itemName;
}

#pragma mark - Private

- (IBAction)expandTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(accountingItemCellDidTapExpandArea:)]) {
        [self.delegate accountingItemCellDidTapExpandArea:self];
    }
}

- (void)awakeFromNib {
    self.leftTableViewWidthContraint.constant = kContent_Width * 0.35;
    self.leftTableViewSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.leftTableViewLastSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.leftTableView.backgroundColor = kItemLeftTableViewColor;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableView.showsVerticalScrollIndicator = NO;
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    
    self.rightTableView.backgroundColor = kItemRightTableViewColor;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.showsVerticalScrollIndicator = NO;
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.tableFooterView = [UIView new];
}

#pragma mark - Getter

- (NSArray *)itemsModel {
    if (_itemsModel == nil) {
        _itemsModel = [NSArray array];
    }
    return _itemsModel;
}

- (NSArray *)categoryModels {
    if (_categoryModels == nil) {
        _categoryModels = [NSArray array];
    }
    return _categoryModels;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        //重复选同一个
        if (indexPath == self.leftTableViewLastSelectedIndexPath) return;
        
        //将上一个选中的设为未选中
        CMLAccountingItemLeftCell *lastSelectedLeftCell = (CMLAccountingItemLeftCell *)[self.leftTableView cellForRowAtIndexPath:self.leftTableViewLastSelectedIndexPath];
        [lastSelectedLeftCell setCellSelected:NO];
        self.leftTableViewLastSelectedIndexPath = indexPath;
        
        //将此次选中的设为选中
        self.leftTableViewSelectedIndexPath = indexPath;
        CMLAccountingItemLeftCell *selectedLeftCell = (CMLAccountingItemLeftCell *)[self.leftTableView cellForRowAtIndexPath:self.leftTableViewSelectedIndexPath];
        [selectedLeftCell setCellSelected:YES];
        
        //刷新二级科目表
        CMLItemCategory *selectedCategory = self.categoryModels[self.leftTableViewSelectedIndexPath.row];
        self.itemsModel = self.itemsDic[selectedCategory.categoryID];
        [self.rightTableView reloadData];
        
    } else {
        if (indexPath.row == 0) {
            //这些都是新增按钮
            __weak typeof(self) weakSelf = self;
            if (self.leftTableViewSelectedIndexPath.row == 0) {
                CMLNewItemAddingView2 *newItemAddingView = [CMLNewItemAddingView2 loadFromNib];
                newItemAddingView.tag = kNewItemAddingViewTag;
                newItemAddingView.addingViewType = Adding_View_Type_Category;
                [newItemAddingView showWithClickHandler:^(NSString *addingName) {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(accountingItemCell:didAddCaterogy:)]) {
                        [weakSelf.delegate accountingItemCell:weakSelf didAddCaterogy:addingName];
                    }
                }];
                
            } else {
                CMLNewItemAddingView2 *newItemAddingView = [CMLNewItemAddingView2 loadFromNib];
                newItemAddingView.tag = kNewItemAddingViewTag;
                newItemAddingView.addingViewType = Adding_View_Type_Item;
                [newItemAddingView showWithClickHandler:^(NSString *addingName) {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(accountingItemCell:didAddItem:inCaterogy:)]) {
                        CMLItemCategory *category = weakSelf.categoryModels[self.leftTableViewSelectedIndexPath.row];
                        [weakSelf.delegate accountingItemCell:weakSelf didAddItem:addingName inCaterogy:category.categoryID];
                    }
                }];
            }
            
        } else {
            //正常科目按钮
            CMLItem *selectedItem = (CMLItem *)self.itemsModel[indexPath.row];
            if ([self.delegate respondsToSelector:@selector(accountingItemCell:shouldSelectItem:)]) {
                [self.delegate accountingItemCell:nil shouldSelectItem:selectedItem];
                [self expandTap:nil];
            }
            if ([self.delegate respondsToSelector:@selector(accountingItemCell:didSelectItem:)]) {
                [self.delegate accountingItemCell:self didSelectItem:nil];
            }
        }
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.categoryModels.count;
        
    } else {
        return self.itemsModel.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        CMLAccountingItemLeftCell *cell = [CMLAccountingItemLeftCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CMLItemCategory *category = self.categoryModels[indexPath.row];
        cell.cellText.text = category.categoryName;
        if (indexPath.row == self.leftTableViewSelectedIndexPath.row) {
            [cell setCellSelected:YES];
        }
        return cell;
        
    } else {
        CMLAccountingItemRightCell *cell = [CMLAccountingItemRightCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CMLItem *item = self.itemsModel[indexPath.row];
        cell.cellText.text = item.itemName;
        return cell;
    }
}

@end




