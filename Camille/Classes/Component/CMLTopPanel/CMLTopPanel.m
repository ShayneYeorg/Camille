//
//  CMLTopPanel.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLTopPanel.h"
#import "UIScrollView+UpsideDown.h"

const CGFloat topPanelHeight  = 64;

@implementation CMLTopPanel {
    BOOL _isManualDragging;
    CGFloat _scrollViewPreviousOffsetY;
}

#pragma mark - Public

+ (instancetype)loadTopViewAbove:(UIView *)superView {
    CMLTopPanel *view = [[CMLTopPanel alloc]initWithFrame:CGRectMake(0, 0, superView.bounds.size.width, topPanelHeight)];
    [view configDetails];
    [superView addSubview:view];
    
    return view;
}

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.scrollsToBottom && _isManualDragging) {
        //1、先计算一下要运动多长距离
        CGFloat distence = scrollView.contentOffset.y - _scrollViewPreviousOffsetY;
        
        //2、判断现在是否已运动到临界点，是则不需要运动了
        CGRect topPanelCurrentFrame = self.frame;
        if (topPanelCurrentFrame.origin.y == 0 && distence >= 0) {
            _scrollViewPreviousOffsetY = scrollView.contentOffset.y;
            return;
            
        } else if (topPanelCurrentFrame.origin.y == -topPanelHeight && distence <= 0) {
            _scrollViewPreviousOffsetY = scrollView.contentOffset.y;
            return;
        }
        
        //3、判断运动后是否会越界，会越界则让其只运动到临界点，并设置运动已完成
        CGFloat topPanelNewOffsetY = topPanelCurrentFrame.origin.y + distence;
        BOOL isMoveEnded = NO;
        if (topPanelNewOffsetY >= 0) {
            topPanelNewOffsetY = 0;
            isMoveEnded = YES;
            
        } else if (topPanelNewOffsetY <= -topPanelHeight) {
            topPanelNewOffsetY = -topPanelHeight;
            isMoveEnded = YES;
        }
        
        //4、运动
        [self setFrame:CGRectMake(0, topPanelNewOffsetY, topPanelCurrentFrame.size.width, topPanelHeight)];
        if ([self.delegate respondsToSelector:@selector(topPanelDidScroll:)]) {
            [self.delegate topPanelDidScroll:self];
        }
        
        //5、如果运动已完成，调用代理方法告知代理运动已完成
        if (isMoveEnded) {
            if (topPanelNewOffsetY == 0 && [self.delegate respondsToSelector:@selector(topPanelDidShow:animation:)]) {
                [self.delegate topPanelDidShow:self animation:YES];
                
            } else if ([self.delegate respondsToSelector:@selector(topPanelDidHide:animation:)]) {
                [self.delegate topPanelDidHide:self animation:YES];
            }
        }
    }
    
    _scrollViewPreviousOffsetY = scrollView.contentOffset.y;
}

- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView {
    _isManualDragging = NO;
    
    if (self.frame.origin.y > -(topPanelHeight/2)) {
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
        [self _autoMoveFrom:self.frame.origin.y isShow:YES];
        
    } else {
        [self setFrame:CGRectMake(0, 0, self.bounds.size.width, topPanelHeight)];
        if ([self.delegate respondsToSelector:@selector(topPanelDidShow:animation:)]) {
            [self.delegate topPanelDidShow:self animation:animated];
        }
    }
}

- (void)hideWithAnimation:(BOOL)animated {
    if (animated) {
        [self _autoMoveFrom:self.frame.origin.y isShow:NO];
        
    } else {
        [self setFrame:CGRectMake(0, -topPanelHeight, self.bounds.size.width, topPanelHeight)];
        if ([self.delegate respondsToSelector:@selector(topPanelDidHide:animation:)]) {
            [self.delegate topPanelDidHide:self animation:animated];
        }
    }
}

- (void)_autoMoveFrom:(CGFloat)currentY isShow:(BOOL)isShow {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //1、获得要运动到的新位置
        CGFloat newY;
        if (isShow) {
            newY = currentY + 10;
            
        } else {
            newY = currentY - 10;
        }
        
        //2、根据判断移动是否会越界，越界则设置其只运动到临界点，并标记运动已完成
        BOOL isMoveEnded = NO;
        if (isShow && newY >= 0) {
            newY = 0;
            isMoveEnded = YES;
            
        } else if (!isShow && newY <= -topPanelHeight) {
            newY = -topPanelHeight;
            isMoveEnded = YES;
        }
        
        //3、运动
        self.frame = CGRectMake(0, newY, self.bounds.size.width, topPanelHeight);
        if ([self.delegate respondsToSelector:@selector(topPanelDidScroll:)]) {
            [self.delegate topPanelDidScroll:self];
        }
        
        //4、如果运动未完成，则继续运动；如果运动已完成，则调用代理方法告知代理运动已完成
        if (!isMoveEnded) {
            [self _autoMoveFrom:newY isShow:isShow];
            
        } else if (isShow && [self.delegate respondsToSelector:@selector(topPanelDidShow:animation:)]) {
            [self.delegate topPanelDidShow:self animation:YES];
            
        } else if (!isShow && [self.delegate respondsToSelector:@selector(topPanelDidHide:animation:)]) {
            [self.delegate topPanelDidHide:self animation:YES];
        }
    });
}

@end
