//
//  CMLAccountingItemCell.m
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#define kTopViewHeight       50
#define kBottomViewHeight    250
#define kLeftTableViewColor  RGB(191,226,151)
#define kRightTableViewColor RGB(252,212,108)

#import "CMLAccountingItemCell.h"
#import "CMLAccountingItemLeftCell.h"
#import "CMLAccountingItemRightCell.h"
#import "CMLNewItemAddingView.h"

@interface CMLAccountingItemCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topView; //上部区域
@property (weak, nonatomic) IBOutlet UIView *bottomView; //选择项目的区域
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTableViewWidthContraint;//左菜单的宽度约束

@property (nonatomic, strong) NSIndexPath *leftTableViewSelectedIndexPath;//左菜单选中项
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

- (void)refreshWithCatogoryModels:(NSArray *)categoryModels itemsDic:(NSDictionary *)itemsDic isExpand:(BOOL)isExpand {
    if (isExpand) {
        self.bottomView.hidden = NO;
        
        self.categoryModels = categoryModels;
        [self.leftTableView reloadData];
        self.itemsDic = itemsDic;
        
        self.itemsModel = self.itemsDic[@"1"];
        [self.rightTableView reloadData];
        
    } else {
        self.bottomView.hidden = YES;
    }
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
    
    self.leftTableView.backgroundColor = kItemLeftTableViewColor;
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    
    self.rightTableView.backgroundColor = kItemRightTableViewColor;
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
        self.leftTableViewSelectedIndexPath = indexPath;
        [self.leftTableView reloadData];
        
        CMLItemCategory *selectedCategory = self.categoryModels[self.leftTableViewSelectedIndexPath.row];
        self.itemsModel = self.itemsDic[selectedCategory.categoryID];
        [self.rightTableView reloadData];
        
    } else {
#warning 此处判断逻辑记得要改
        if (self.leftTableViewSelectedIndexPath.row == 0 && indexPath.row == 0) {
            //这是新增按钮
            __weak typeof(self) weakSelf = self;
            CMLNewItemAddingView *newItemAddingView = [CMLNewItemAddingView loadFromNib];
            [newItemAddingView showWithClickHandler:^(NSString *itemName, NSString *categoryName) {
                if (weakSelf.delegate) {
                    [weakSelf.delegate accountingItemCell:weakSelf didAddItem:itemName inCaterogy:categoryName];
                }
            }];
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
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView == self.leftTableView) {
        if (indexPath.row == self.leftTableViewSelectedIndexPath.row) {
            cell.backgroundColor = kRightTableViewColor;
            
        } else {
            cell.backgroundColor = kLeftTableViewColor;
        }
        CMLItemCategory *category = self.categoryModels[indexPath.row];
        cell.textLabel.text = category.categoryName;
        
    } else {
        cell.backgroundColor = kRightTableViewColor;
        CMLItem *item = self.itemsModel[indexPath.row];
        cell.textLabel.text = item.itemName;
    }
    
    return cell;
}

@end




