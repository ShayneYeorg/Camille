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
    CGFloat _currentOffsetY;
    CGFloat _previousOffsetY;
}

#pragma mark - Public

+ (instancetype)loadTopViewAbove:(UIView *)superView {
    CMLTopPanel *view = [[CMLTopPanel alloc]initWithFrame:CGRectMake(0, 0, superView.bounds.size.width, topPanelHeight)];
    [view configDetails];
    [superView addSubview:view];
    
    return view;
}

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView {
    _currentOffsetY = scrollView.contentOffset.y;
    
    if (!scrollView.scrollsToBottom && _isManualDragging) {
        CGRect topViewCurrentFrame = self.frame;
        //运动
        [self setFrame:CGRectMake(0, topViewCurrentFrame.origin.y+(_currentOffsetY-_previousOffsetY), topViewCurrentFrame.size.width, topPanelHeight)];
        
        //校正
        if (self.frame.origin.y > 0) {
            [self showWithAnimation:NO];
            
        } else if (self.frame.origin.y < -topPanelHeight) {
            [self hideWithAnimation:NO];
            
        }
        
        //已校正过了，所以self.frame.origin.y肯定在0到-topPanelHeight之间
        if ([self.delegate respondsToSelector:@selector(topPanelDidScroll:)]) {
            [self.delegate topPanelDidScroll:self];
        }
    }
    
    _previousOffsetY = scrollView.contentOffset.y;
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
//        [UIView animateWithDuration:0.2 animations:^{
//            [self setFrame:CGRectMake(0, 0, self.bounds.size.width, topPanelHeight)];
//        }];
        
        CGFloat currentY = self.frame.origin.y;
        while (currentY < 0) {
            currentY += 2;
            self.frame = CGRectMake(0, currentY, self.bounds.size.width, topPanelHeight);
            if ([self.delegate respondsToSelector:@selector(topPanelDidShowWithAnimation:)]) {
                [self.delegate topPanelDidShowWithAnimation:self];
            }
        }
        [self setFrame:CGRectMake(0, 0, self.bounds.size.width, topPanelHeight)];
        if ([self.delegate respondsToSelector:@selector(topPanelDidShowWithAnimation:)]) {
            [self.delegate topPanelDidShowWithAnimation:self];
        }
        
    } else {
        [self setFrame:CGRectMake(0, 0, self.bounds.size.width, topPanelHeight)];
    }
}

- (void)hideWithAnimation:(BOOL)animated {
    if (animated) {
//        [UIView animateWithDuration:0.2 animations:^{
//            [self setFrame:CGRectMake(0, -topPanelHeight, self.bounds.size.width, topPanelHeight)];
//        }];

        CGFloat currentY = self.frame.origin.y;
        while (currentY > -topPanelHeight) {
            currentY -= 2;
            self.frame = CGRectMake(0, currentY, self.bounds.size.width, topPanelHeight);
            if ([self.delegate respondsToSelector:@selector(topPanelDidHideWithAnimation:)]) {
                [self.delegate topPanelDidHideWithAnimation:self];
            }
        }
        [self setFrame:CGRectMake(0, -topPanelHeight, self.bounds.size.width, topPanelHeight)];
        if ([self.delegate respondsToSelector:@selector(topPanelDidHideWithAnimation:)]) {
            [self.delegate topPanelDidHideWithAnimation:self];
        }
        
    } else {
        [self setFrame:CGRectMake(0, -topPanelHeight, self.bounds.size.width, topPanelHeight)];
    }
}

@end
