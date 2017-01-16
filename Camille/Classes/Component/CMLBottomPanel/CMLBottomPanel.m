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
    CGFloat _currentOffsetY;
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
    _currentOffsetY = scrollView.contentOffset.y;
    
    if (_isManualDragging) {
        CGRect topViewCurrentFrame = self.frame;
        //运动
        [self setFrame:CGRectMake(0, topViewCurrentFrame.origin.y-(_currentOffsetY-_previousOffsetY), topViewCurrentFrame.size.width, bottomViewHeight)];
        
        //校正
        if (self.frame.origin.y > _superViewHeight) {
            [self hideWithAnimation:NO];
            
        } else if (self.frame.origin.y < _bottomViewInitialY) {
            [self showWithAnimation:NO];
        }
    }
    
    _previousOffsetY = scrollView.contentOffset.y;
}

- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView {
    _isManualDragging = NO;
    
    if (self.frame.origin.y < _superViewHeight-(bottomViewHeight/2)) {
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
