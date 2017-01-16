//
//  CMLBottomPanel.h
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLBottomPanel : UIView

+ (instancetype)loadBottomViewAbove:(UIView *)superView;

- (void)showWithAnimation:(BOOL)animated;
- (void)hideWithAnimation:(BOOL)animated;

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)motionAfterScrollViewWillBeginDragging:(UIScrollView *)scrollView;

@end
