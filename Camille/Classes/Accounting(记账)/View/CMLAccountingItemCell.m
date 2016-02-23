//
//  CMLAccountingItemCell.m
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#define kTopViewHeight       50
#define kBottomViewHeight    250
#define kLeftTableViewColor  RGB(250,230,150)
//#define kRightTableViewColor RGB(255,250,235)

#import "CMLAccountingItemCell.h"

@interface CMLAccountingItemCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topView; //上部区域
@property (weak, nonatomic) IBOutlet UIView *bottomView; //选择项目的区域
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTableViewWidthContraint;//左菜单的宽度约束

@property (nonatomic, strong) NSIndexPath *leftTableViewSelectedIndexPath;//左菜单选中项

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

- (void)refreshWithExpand:(BOOL)isExpand {
    if (isExpand) {
        self.bottomView.hidden = NO;
        
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
    
    self.leftTableView.backgroundColor = kLeftTableViewColor;
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    
    self.rightTableView.backgroundColor = kAppViewColor;
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        self.leftTableViewSelectedIndexPath = indexPath;
        [self.leftTableView reloadData];
    }
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView == self.leftTableView) {
        if (indexPath.row == self.leftTableViewSelectedIndexPath.row) {
            cell.backgroundColor = kAppViewColor;
            
        } else {
            cell.backgroundColor = kLeftTableViewColor;
        }
        
    } else {
        cell.backgroundColor = kAppViewColor;
    }
    return cell;
}

@end




