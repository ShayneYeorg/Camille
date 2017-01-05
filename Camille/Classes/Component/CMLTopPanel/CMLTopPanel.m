//
//  CMLTopPanel.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLTopPanel.h"
#import "GMConstants.h"

#define kTopViewHeight 64

@interface CMLTopPanel ()

@property (nonatomic, assign) BOOL isManualDragging;

@end

@implementation CMLTopPanel {
    CGFloat _currentOffsetY;
    CGFloat _previousOffsetY;
}

#pragma mark - Public

+ (instancetype)loadTopViewAbove:(UIView *)superView {
    CMLTopPanel *view = [[CMLTopPanel alloc]initWithFrame:CGRectMake(0, 0, superView.bounds.size.width, kTopViewHeight)];
    view.backgroundColor = kAppColor;
    view.isManualDragging = NO;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, view.bounds.size.width, view.bounds.size.height-20)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"Camille";
    lbl.font = [UIFont systemFontOfSize:18];
    lbl.textColor = [UIColor blackColor];
    [view addSubview:lbl];
    
    [superView addSubview:view];
    
    return view;
}

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView {
    _currentOffsetY = scrollView.contentOffset.y;
    
    if (_isManualDragging && self.frame.origin.y <= 0 && self.frame.origin.y >= -kTopViewHeight) {
        CGRect topViewCurrentFrame = self.frame;
        //运动
        [self setFrame:CGRectMake(0, topViewCurrentFrame.origin.y+(_currentOffsetY-_previousOffsetY), topViewCurrentFrame.size.width, kTopViewHeight)];
        
        //校正
        if (self.frame.origin.y > 0) {
            [self showWithAnimation:NO];
            
        } else if (self.frame.origin.y < -kTopViewHeight) {
            [self hideWithAnimation:NO];
        }
    }
    
    _previousOffsetY = scrollView.contentOffset.y;
}

- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView {
    _isManualDragging = NO;
    
    if (self.frame.origin.y > -(kTopViewHeight/2)) {
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
            [self setFrame:CGRectMake(0, 0, self.bounds.size.width, kTopViewHeight)];
        }];
        
    } else {
        [self setFrame:CGRectMake(0, 0, self.bounds.size.width, kTopViewHeight)];
    }
}

- (void)hideWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:CGRectMake(0, -kTopViewHeight, self.bounds.size.width, kTopViewHeight)];
        }];
        
    } else {
        [self setFrame:CGRectMake(0, -kTopViewHeight, self.bounds.size.width, kTopViewHeight)];
    }
}

@end
