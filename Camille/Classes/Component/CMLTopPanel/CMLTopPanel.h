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

@end

@interface CMLTopPanel : UIView

@property (nonatomic, weak) id <CMLTopPanelDelegate> delegate;
@property (nonatomic, assign) BOOL delegateSwitch; //是否要回调delegate的方法

+ (instancetype)loadTopViewAbove:(UIView *)superView;

- (void)showWithAnimation:(BOOL)animated;
- (void)hideWithAnimation:(BOOL)animated;

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)motionAfterScrollViewWillBeginDragging:(UIScrollView *)scrollView;

@end
