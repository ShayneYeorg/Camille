//
//  CMLTopPanel.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLTopPanel.h"

const CGFloat topViewHeight  = 64;

@implementation CMLTopPanel {
    BOOL _isManualDragging;
    CGFloat _currentOffsetY;
    CGFloat _previousOffsetY;
}

#pragma mark - Public

+ (instancetype)loadTopViewAbove:(UIView *)superView {
    CMLTopPanel *view = [[CMLTopPanel alloc]initWithFrame:CGRectMake(0, 0, superView.bounds.size.width, topViewHeight)];
    [view configDetails];
    [superView addSubview:view];
    
    return view;
}

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView {
    _currentOffsetY = scrollView.contentOffset.y;
    
    // && self.frame.origin.y <= 0 && self.frame.origin.y >= -topViewHeight
    if (_isManualDragging) {
        CGRect topViewCurrentFrame = self.frame;
        //运动
        [self setFrame:CGRectMake(0, topViewCurrentFrame.origin.y+(_currentOffsetY-_previousOffsetY), topViewCurrentFrame.size.width, topViewHeight)];
        
        //校正
        if (self.frame.origin.y > 0) {
            [self showWithAnimation:NO];
            
        } else if (self.frame.origin.y < -topViewHeight) {
            [self hideWithAnimation:NO];
        }
    }
    
    _previousOffsetY = scrollView.contentOffset.y;
}

- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView {
    _isManualDragging = NO;
    
    if (self.frame.origin.y > -(topViewHeight/2)) {
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
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height-20)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"Camille";
    lbl.font = [UIFont systemFontOfSize:18];
    lbl.textColor = [UIColor blackColor];
    [self addSubview:lbl];
}

- (void)showWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:CGRectMake(0, 0, self.bounds.size.width, topViewHeight)];
        }];
        
    } else {
        [self setFrame:CGRectMake(0, 0, self.bounds.size.width, topViewHeight)];
    }
}

- (void)hideWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:CGRectMake(0, -topViewHeight, self.bounds.size.width, topViewHeight)];
        }];
        
    } else {
        [self setFrame:CGRectMake(0, -topViewHeight, self.bounds.size.width, topViewHeight)];
    }
}

@end
