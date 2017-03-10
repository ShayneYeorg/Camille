//
//  MainViewController.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MainViewController.h"
#import "AccountingCell.h"
#import "CMLTopPanel.h"
#import "CMLBottomPanel.h"
#import "CMLControlHandle.h"
#import "SectionHeaderView.h"
#import "UIScrollView+UpsideDown.h"
#import "AccountViewController.h"
#import "AccountAddingViewController.h"
#import "ReportViewController.h"
#import "UIViewController+CMLTransition.h"
#import "CMLDataManager.h"

#define dataCountPerPage        20
#define kLoadingOffset          60
#define kLoadmoreThreshold     -90

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate, CMLTopPanelDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
//@property (nonatomic, assign) BOOL isLoading; //如果处在_isLoading状态，则topPanel会隐藏，不会因为停止拖动的时候topPanel露出偏多就完全展示出来了，那样会盖住loading的UIActivityIndicatorView

@property (nonatomic, strong) CMLTopPanel *topView;
@property (nonatomic, strong) CMLBottomPanel *bottomView;
@property (nonatomic, strong) CMLControlHandle *controlHandle;
@property (nonatomic, strong) CMLControlHandle *toBottomHandle;

@property (nonatomic, assign) BOOL isToBottomBtnClicked;
@property (nonatomic, strong) NSMutableArray *accountingsData;

@end

@implementation MainViewController {
    CGFloat _currentTableViewInsetY;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetails];
    [self configBackgroungView];
    [self configTableView];
    [self configTopView];
    [self configBottomView];
    [self configControlHandle];
    [self configToBottomHandle];
    
    [self fetchAllAccountingsWithLoadType:Load_Type_Refresh];
}

#pragma mark - UI Configuration

- (void)configDetails {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentTableViewInsetY = topPanelHeight;
    _isToBottomBtnClicked = NO;
//    self.isLoading = NO;
}

- (void)configBackgroungView {
    self.backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.backgroundView];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:self.backgroundView.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB(200, 200, 200);
    [self.backgroundView addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self _tableViewSetContentInsetTop:topPanelHeight bottom:44];
}

- (void)configTopView {
    self.topView = [CMLTopPanel loadTopViewAbove:self.backgroundView];
    self.topView.delegate = self;
}

- (void)configBottomView {
    self.bottomView = [CMLBottomPanel loadBottomViewAbove:self.backgroundView];
}

#pragma mark - Getter

- (NSMutableArray *)accountingsData {
    if (!_accountingsData) {
        _accountingsData = [NSMutableArray array];
    }
    return _accountingsData;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((kScreen_Width-50)/2, -50, 50, 50)];
        [self.tableView addSubview:_activityView];
        _activityView.hidden = YES;
    }
    return _activityView;
}

#pragma mark - Private

- (void)_scrollToBottomWithAnimation:(BOOL)animated {
    MainSectionModel *sectionModel = (MainSectionModel *)self.accountingsData.firstObject;
    if (sectionModel) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sectionModel.cellModels.count - 1 inSection:(self.accountingsData.count - 1)] atScrollPosition:UITableViewScrollPositionNone animated:animated];
    }
}

- (void)_tableViewSetContentInsetTop:(CGFloat)top bottom:(CGFloat)bottom {
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
}

- (void)_tableViewSetContentOffset:(CGPoint)offset animated:(BOOL)animated {
    [self.tableView setContentOffset:offset animated:animated];
}

#pragma mark - Fetch Data

- (void)fetchAllAccountingsWithLoadType:(Load_Type)loadType {
    if (loadType == Load_Type_LoadMore) {
        //让tableView保持在loading样式
        [self.topView scrollViewIsLoading];
        [self.controlHandle restore];
        self.tableView.scrollEnabled = NO;
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
        [self _tableViewSetContentInsetTop:kLoadingOffset bottom:44];
        [self _tableViewSetContentOffset:CGPointMake(0, -kLoadingOffset) animated:YES];
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    //数据缓存在中间层
    DECLARE_WEAK_SELF
    [CMLDataManager fetchAllAccountingsWithLoadType:loadType callBack:^(BOOL isFetchSuccess, NSMutableArray *accountings, NSInteger newSectionCount, NSInteger newAccountingCount) {
        weakSelf.accountingsData = accountings;
        [weakSelf.activityView stopAnimating];
        weakSelf.activityView.hidden = YES; //无论如何都hide一次
        [weakSelf.tableView reloadData];
        
        if (weakSelf.accountingsData.count) {
            if (loadType == Load_Type_Refresh) {
                //第一次进入 | 添加了Accounting | 取消日期查询
                [weakSelf _scrollToBottomWithAnimation:NO];
                
            } else {
                //加载新页
                [weakSelf _tableViewSetContentInsetTop:0 bottom:44];
//                [weakSelf.tableView setContentOffset:CGPointMake(0, cellHeight*dataCountPerPage - kLoadingOffset + kSectionHeaderHeight * 7) animated:NO];
                [weakSelf.controlHandle restore];
            }
            weakSelf.tableView.scrollEnabled = YES;
            [weakSelf.topView scrollViewLoadingComplete];
            
        } else {
            weakSelf.tableView.scrollEnabled = NO;
        }
    }];
        
        
//    });
}

- (void)fetchAccountingsByDate:(NSDate *)date {
    //这种形式的查询不做缓存
    
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderView *sectionHeaderView = [SectionHeaderView loadSectionHeaderView];
    MainSectionModel *sectionModel = (MainSectionModel *)self.accountingsData[self.accountingsData.count - 1 - section];
    sectionHeaderView.date.text = sectionModel.diaplayDate;
    
    return sectionHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.accountingsData.count;
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
    MainSectionModel *sectionModel = (MainSectionModel *)self.accountingsData[self.accountingsData.count - 1 - section];
    return sectionModel.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountingCell *cell = [AccountingCell loadFromNib];
    MainSectionModel *sectionModel = self.accountingsData[self.accountingsData.count - 1 - indexPath.section];
    MainCellModel *cellModel = (MainCellModel *)sectionModel.cellModels[sectionModel.cellModels.count - 1 - indexPath.row];
    cell.model = cellModel;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //先把必要的逻辑处理了，再让控件做反应
    //load more
    if (self.tableView.contentOffset.y < kLoadmoreThreshold) {
        [self fetchAllAccountingsWithLoadType:Load_Type_LoadMore];
    }
    
    [self.topView motionAfterScrollViewDidEndDragging:scrollView];
    [self.bottomView motionAfterScrollViewDidEndDragging:scrollView];
    [self.controlHandle motionAfterScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.topView motionAfterScrollViewWillBeginDragging:scrollView];
    [self.bottomView motionAfterScrollViewWillBeginDragging:scrollView];
    [self.controlHandle motionAfterScrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
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
            [self _tableViewSetContentInsetTop:_currentTableViewInsetY bottom:44];
        }
        
    } else {
        self.tableView.scrollsToBottom = NO;
        [self.toBottomHandle showWithAnimation:YES];
    }
    
    [self.topView motionAfterScrollViewDidScroll:scrollView];
    [self.bottomView motionAfterScrollViewDidScroll:scrollView];
    [self.controlHandle motionAfterScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.controlHandle motionAfterScrollViewDidEndDecelerating:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self _tableViewSetContentInsetTop:0 bottom:44];
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
            [weakSelf fetchAllAccountingsWithLoadType:Load_Type_Refresh];
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
        [weakSelf _scrollToBottomWithAnimation:YES];
        [weakSelf.topView showWithAnimation:YES];
        [weakSelf.bottomView showWithAnimation:YES];
    };
}

#pragma mark - CMLTopPanelDelegate

- (void)topPanelDidScroll:(CMLTopPanel *)topPanel {
    CGFloat newTableViewInsetY = topPanelHeight + self.topView.frame.origin.y;
    if (_currentTableViewInsetY != newTableViewInsetY) {
        [self _tableViewSetContentInsetTop:newTableViewInsetY bottom:44];
        _currentTableViewInsetY = newTableViewInsetY;
    }
}

- (void)topPanelDidShow:(CMLTopPanel *)topPanel animation:(BOOL)animation {
//    [self _tableViewSetContentInsetTop:topPanelHeight + topPanel.frame.origin.y bottom:44];
}

- (void)topPanelDidHide:(CMLTopPanel *)topPanel animation:(BOOL)animation {
//    [self _tableViewSetContentInsetTop:0 bottom:44];
}

@end
