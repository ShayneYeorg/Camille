//
//  CMLBottomPanel.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLBottomPanel.h"
#import "GMConstants.h"

#define kBottomViewHeight  44

@interface CMLBottomPanel ()

@property (nonatomic, assign) BOOL isManualDragging;
@property (nonatomic, assign) CGFloat bottomViewInitialY;
@property (nonatomic, assign) CGFloat superViewHeight;

@end

@implementation CMLBottomPanel {
    CGFloat _currentOffsetY;
    CGFloat _previousOffsetY;
}

#pragma mark - Public

+ (instancetype)loadBottomViewAbove:(UIView *)superView {
    CMLBottomPanel *view = [[CMLBottomPanel alloc]initWithFrame:CGRectMake(0, superView.bounds.size.height-kBottomViewHeight, superView.bounds.size.width, kBottomViewHeight)];
    view.backgroundColor = kAppColor;
    view.isManualDragging = NO;
    view.superViewHeight = superView.bounds.size.height;
    view.bottomViewInitialY = view.frame.origin.y;
    [superView addSubview:view];
    
    return view;
}

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView {
    _currentOffsetY = scrollView.contentOffset.y;
    
    if (_isManualDragging && self.frame.origin.y <= _superViewHeight && self.frame.origin.y >= _bottomViewInitialY) {
        CGRect topViewCurrentFrame = self.frame;
        //运动
        [self setFrame:CGRectMake(0, topViewCurrentFrame.origin.y-(_currentOffsetY-_previousOffsetY), topViewCurrentFrame.size.width, kBottomViewHeight)];
        
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
    
    if (self.frame.origin.y < _superViewHeight-(kBottomViewHeight/2)) {
        [self showWithAnimation:YES];
        
    } else {
        [self hideWithAnimation:YES];
    }
}

- (void)motionAfterScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isManualDragging = YES;
}

#pragma mark - Private

- (void)showWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:CGRectMake(0, _bottomViewInitialY, self.bounds.size.width, kBottomViewHeight)];
        }];
        
    } else {
        [self setFrame:CGRectMake(0, _bottomViewInitialY, self.bounds.size.width, kBottomViewHeight)];
    }
}

- (void)hideWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:CGRectMake(0, _superViewHeight, self.bounds.size.width, kBottomViewHeight)];
        }];
        
    } else {
        [self setFrame:CGRectMake(0, _superViewHeight, self.bounds.size.width, kBottomViewHeight)];
    }
}

@end
