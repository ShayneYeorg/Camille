//
//  CMLAccountingItemCell.m
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#define kTopViewHeight    50
#define kBottomViewHeight 250

#import "CMLAccountingItemCell.h"

@interface CMLAccountingItemCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topView; //上部区域
@property (weak, nonatomic) IBOutlet UIView *bottomView; //选择项目的区域
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTableViewWidthContraint;//左菜单的宽度约束

@end

@implementation CMLAccountingItemCell

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLAccountingItemCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CMLAccountingItemCell" owner:self options:nil] firstObject];
    
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
    
    self.leftTableView.backgroundColor = RGB(250, 230, 150);
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    
    self.rightTableView.backgroundColor = RGB(255, 250, 235);
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.tableFooterView = [UIView new];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (tableView == self.leftTableView) {
        cell.backgroundColor = RGB(250, 230, 150);
    } else {
        cell.backgroundColor = RGB(255, 250, 235);
    }
    return cell;
}

@end




