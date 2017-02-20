//
//  MainViewController.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MainViewController.h"
#import "AccountingCell.h"
#import "TestData.h"
#import "CMLTopPanel.h"
#import "CMLBottomPanel.h"
#import "CMLControlHandle.h"
#import "AddAccountingView.h"
#import "SectionHeaderView.h"
#import "UIScrollView+UpsideDown.h"
#import "AccountViewController.h"
#import "AccountAddingViewController.h"
#import "ReportViewController.h"
#import "UIViewController+CMLTransition.h"
#import "MainDataModel.h"
#import "CMLDataManager.h"

#define cellHeight         50
#define dataCountPerPage   20
#define reloadOffset       60

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate, CMLTopPanelDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) CMLTopPanel *topView;
@property (nonatomic, strong) CMLBottomPanel *bottomView;
@property (nonatomic, strong) CMLControlHandle *controlHandle;
@property (nonatomic, strong) CMLControlHandle *toBottomHandle;
@property (nonatomic, assign) BOOL isToBottomBtnClicked;

@property (nonatomic, strong) NSMutableArray *accountingsData;

@end

@implementation MainViewController {
    BOOL _isLoading;
    CGFloat _currentTableViewInsetY;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self configDetails];
//    [self configBackgroungView];
//    [self configTableView];
//    [self configTopView];
//    [self configBottomView];
//    [self configControlHandle];
//    [self configToBottomHandle];
    
    [self fetchAllAccountingsWithLoadType:Load_Type_Refresh];
    
    [self fetchAllAccountingsWithLoadType:Load_Type_LoadMore];
    
    
    
//    [Item addItemWithName:@"花销一" type:Item_Type_Cost callBack:^(CMLResponse * _Nonnull response) {
//    }];
    
//    NSDate *today = [NSDate date];
//    NSDate *firstDay = [CMLTool getFirstDateInMonth:today];
//    NSDate *lastDay = [CMLTool getLastDateInMonth:today];
//    
//    [Accounting addAccountingWithItemID:@"20170220150658" amount:[NSNumber numberWithFloat:103] happneTime:firstDay desc:@"无" callBack:^(CMLResponse * _Nonnull response) {}];
}

#pragma mark - UI Configuration

- (void)configDetails {
    _currentTableViewInsetY = topPanelHeight;
    _isToBottomBtnClicked = NO;
    _isLoading = NO;
}

- (void)configBackgroungView {
    self.backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.backgroundView];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.backgroundView.frame];
    self.tableView.backgroundColor = RGB(200, 200, 200);
    [self.backgroundView addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.contentInset = UIEdgeInsetsMake(_currentTableViewInsetY, 0, 44, 0);
    
//    NSDictionary *dic = self.dataArr.firstObject;
//    NSArray *arr = dic[@"0"];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count - 1 inSection:(self.dataArr.count - 1)] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

- (void)configTopView {
    self.topView = [CMLTopPanel loadTopViewAbove:self.backgroundView];
    self.topView.delegate = self;
}

- (void)configBottomView {
    self.bottomView = [CMLBottomPanel loadBottomViewAbove:self.backgroundView];
}

#pragma mark - Getter

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:[TestData dataArrayFrom:0 to:dataCountPerPage]];
    }
    return _dataArr;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((kScreen_Width-50)/2, -50, 50, 50)];
        [self.tableView addSubview:_activityView];
        _activityView.hidden = YES;
        [_activityView startAnimating];
    }
    return _activityView;
}

#pragma mark - Private

- (void)loadNewDataWithExistCount:(NSInteger)count {
    _isLoading = YES;
    [self.controlHandle restore];
    [self.tableView setContentInset:UIEdgeInsetsMake(reloadOffset, 0, 44, 0)];
    [self.tableView setContentOffset:CGPointMake(0, -reloadOffset) animated:YES];
    self.tableView.scrollEnabled = NO;
    self.activityView.hidden = NO;
    if (self.dataArr.count == 7) {
        //第一次下拉
        [self.dataArr removeLastObject];
        [self.dataArr addObjectsFromArray:[TestData dataArrayFrom:self.dataArr.count to:self.dataArr.count+dataCountPerPage]];
        
    } else if (self.dataArr.count == 14) {
        //第二次下拉
        [self.dataArr removeLastObject];
        [self.dataArr addObjectsFromArray:[TestData dataArrayFrom:self.dataArr.count to:self.dataArr.count+dataCountPerPage]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.activityView.hidden = YES;
        [self.tableView reloadData];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
        [self.tableView setContentOffset:CGPointMake(0, cellHeight*dataCountPerPage - reloadOffset + kSectionHeaderHeight * 7) animated:NO];
        [self.controlHandle restore];
        _isLoading = NO;
        self.tableView.scrollEnabled = YES;
    });
}

#pragma mark - Fetch Data

- (void)fetchAllAccountingsWithLoadType:(Load_Type)loadType {
    //数据缓存在中间层
    DECLARE_WEAK_SELF
    [CMLDataManager fetchAllAccountingsWithLoadType:loadType callBack:^(NSMutableArray *accountings) {
        weakSelf.accountingsData = accountings;
    }];
    
}

- (void)fetchAccountingsByDate:(NSDate *)date {
    //这种形式的查询不做缓存
    
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [SectionHeaderView loadSectionHeaderView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self CML_presentViewController:[[AccountViewController alloc] init] transitionType:CMLTransitionAnimationBreak completion:nil];
    
    //    [self CML_presentViewController:[[ReportViewController alloc] init] transitionType:4 completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArr[self.dataArr.count - 1 -section][[NSString stringWithFormat:@"%zd", self.dataArr.count - 1 -section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountingCell *cell = [AccountingCell loadFromNib];
    NSDictionary *dic = self.dataArr[self.dataArr.count - 1 - indexPath.section];
    NSArray *arr = dic[[NSString stringWithFormat:@"%zd", self.dataArr.count - 1 - indexPath.section]];
    TestDataAccounting *accounting = arr[arr.count - 1 - indexPath.row];
    cell.model = accounting;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.topView motionAfterScrollViewDidEndDragging:scrollView];
    [self.bottomView motionAfterScrollViewDidEndDragging:scrollView];
    [self.controlHandle motionAfterScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    //假数据
    if (self.tableView.contentOffset.y < -reloadOffset) {
        if (!_isLoading) {
            [self loadNewDataWithExistCount:self.dataArr.count];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.topView motionAfterScrollViewWillBeginDragging:scrollView];
    [self.bottomView motionAfterScrollViewWillBeginDragging:scrollView];
    [self.controlHandle motionAfterScrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.topView motionAfterScrollViewDidScroll:scrollView];
    [self.bottomView motionAfterScrollViewDidScroll:scrollView];
    [self.controlHandle motionAfterScrollViewDidScroll:scrollView];
    
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    if (bottomOffset <= height) {
        //在最底部
        self.tableView.scrollsToBottom = YES;
        [self.toBottomHandle hideWithAnimation:YES];
        [self.controlHandle restore];
        if (self.isToBottomBtnClicked) {
            self.isToBottomBtnClicked = NO;
            _currentTableViewInsetY = topPanelHeight;
            self.tableView.contentInset = UIEdgeInsetsMake(_currentTableViewInsetY, 0, 44, 0);
        }
        
    } else {
        self.tableView.scrollsToBottom = NO;
        [self.toBottomHandle showWithAnimation:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.controlHandle motionAfterScrollViewDidEndDecelerating:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self.topView hideWithAnimation:NO];
    [self.bottomView hideWithAnimation:NO];
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self.controlHandle restore];
}

#pragma mark - CMLControlHandle

- (void)configControlHandle {
    self.controlHandle = [CMLControlHandle loadControlHandleAbove:self.backgroundView];
    self.controlHandle.lastOffsetY = self.tableView.contentOffset.y;
    __weak typeof(self) weakSelf = self;
    self.controlHandle.clickAction = ^{
        AccountAddingViewController *accountAddingViewController = [AccountAddingViewController new];
        accountAddingViewController.saveSuccessCallback = ^{
            //新添加账务成功，刷新页面
        };
        [weakSelf CML_presentViewController:accountAddingViewController transitionType:CMLTransitionAnimationBoom completion:nil];
    };
}

- (void)configToBottomHandle {
    self.toBottomHandle = [CMLControlHandle loadControlHandleWithY:self.controlHandle.frame.origin.y - controlHandleHeight - 10 above:self.backgroundView];
    self.toBottomHandle.moveAnimation = NO;
    __weak typeof(self) weakSelf = self;
    self.toBottomHandle.clickAction = ^{
        weakSelf.isToBottomBtnClicked = YES;
        NSDictionary *dic = weakSelf.dataArr.firstObject;
        NSArray *arr = dic[@"0"];
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arr.count - 1 inSection:(self.dataArr.count - 1)] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [weakSelf.topView showWithAnimation:YES];
        [weakSelf.bottomView showWithAnimation:YES];
    };
}

#pragma mark - CMLTopPanelDelegate

- (void)topPanelDidScroll:(CMLTopPanel *)topPanel {
    CGFloat newTableViewInsetY = topPanelHeight + self.topView.frame.origin.y;
    if (_currentTableViewInsetY != newTableViewInsetY) {
        self.tableView.contentInset = UIEdgeInsetsMake(newTableViewInsetY, 0, 44, 0);
        _currentTableViewInsetY = newTableViewInsetY;
    }
}

- (void)topPanelDidShowWithAnimation:(CMLTopPanel *)topPanel {
    self.tableView.contentInset = UIEdgeInsetsMake(topPanelHeight + topPanel.frame.origin.y, 0, 44, 0);
}

- (void)topPanelDidHideWithAnimation:(CMLTopPanel *)topPanel {
    self.tableView.contentInset = UIEdgeInsetsMake(topPanelHeight + topPanel.frame.origin.y, 0, 44, 0);
}

@end
