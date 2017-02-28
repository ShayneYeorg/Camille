//
//  CMLBottomPanel.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLBottomPanel.h"

const CGFloat bottomViewHeight  = 44;

@interface CMLBottomPanel ()

@property (nonatomic, assign) CGFloat superViewHeight;

@end

@implementation CMLBottomPanel {
    BOOL _isManualDragging;
    CGFloat _bottomViewInitialY;
    CGFloat _previousOffsetY;
}

#pragma mark - Public

+ (instancetype)loadBottomViewAbove:(UIView *)superView {
    CMLBottomPanel *view = [[CMLBottomPanel alloc]initWithFrame:CGRectMake(0, superView.bounds.size.height-bottomViewHeight, superView.bounds.size.width, bottomViewHeight)];
    view.superViewHeight = superView.bounds.size.height;
    [view configDetails];
    [superView addSubview:view];
    
    return view;
}

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isManualDragging) {
        //1、先计算要运动到哪里
        CGFloat distence = scrollView.contentOffset.y - _previousOffsetY;
        CGRect bottomViewCurrentFrame = self.frame;
        
        //2、如果当前已经处在临界值了，则不做运动了
        if (bottomViewCurrentFrame.origin.y == _superViewHeight && distence <= 0) {
            _previousOffsetY = scrollView.contentOffset.y;
            return;
            
        } else if (bottomViewCurrentFrame.origin.y == _bottomViewInitialY && distence >= 0) {
            _previousOffsetY = scrollView.contentOffset.y;
            return;
        }
        
        //3、判断运动是否会越界，越界则设置值运动到临界值
        CGFloat newBottomPanelY = bottomViewCurrentFrame.origin.y - distence;
        if (newBottomPanelY >= _superViewHeight) {
            newBottomPanelY = _superViewHeight;
            
        } else if (newBottomPanelY <= _bottomViewInitialY) {
            newBottomPanelY = _bottomViewInitialY;
        }
        
        //4、运动
        [self setFrame:CGRectMake(0, newBottomPanelY, bottomViewCurrentFrame.size.width, bottomViewHeight)];
    }
    
    _previousOffsetY = scrollView.contentOffset.y;
}

- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView {
    _isManualDragging = NO;
    
    if (self.frame.origin.y < _superViewHeight - (bottomViewHeight/2)) {
        [self showWithAnimation:YES];
        
    } else {
        [self hideWithAnimation:YES];
    }
}

- (void)motionAfterScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isManualDragging = YES;
}

#pragma mark - Private

- (void)configDetails {
    self.backgroundColor = kAppColor;
    _isManualDragging = NO;
    _bottomViewInitialY = self.frame.origin.y;
}

- (void)showWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:CGRectMake(0, _bottomViewInitialY, self.bounds.size.width, bottomViewHeight)];
        }];
        
    } else {
        [self setFrame:CGRectMake(0, _bottomViewInitialY, self.bounds.size.width, bottomViewHeight)];
    }
}

- (void)hideWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:CGRectMake(0, _superViewHeight, self.bounds.size.width, bottomViewHeight)];
        }];
        
    } else {
        [self setFrame:CGRectMake(0, _superViewHeight, self.bounds.size.width, bottomViewHeight)];
    }
}

@end
