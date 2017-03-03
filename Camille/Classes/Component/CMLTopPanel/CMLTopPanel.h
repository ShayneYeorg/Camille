//
//  CMLTopPanel.h
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat topPanelHeight;

@class CMLTopPanel;

@protocol CMLTopPanelDelegate <NSObject>

- (void)topPanelDidScroll:(CMLTopPanel *)topPanel;
- (void)topPanelDidShow:(CMLTopPanel *)topPanel animation:(BOOL)animation;
- (void)topPanelDidHide:(CMLTopPanel *)topPanel animation:(BOOL)animation;

@end

@interface CMLTopPanel : UIView

@property (nonatomic, weak) id <CMLTopPanelDelegate> delegate;

+ (instancetype)loadTopViewAbove:(UIView *)superView;

- (void)showWithAnimation:(BOOL)animated;
- (void)hideWithAnimation:(BOOL)animated;

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)motionAfterScrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)scrollViewIsLoading;
- (void)scrollViewLoadingComplete;

@end
