//
//  CMLTopPanel.h
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMLTopPanel : UIView

+ (instancetype)loadTopViewAbove:(UIView *)superView;

- (void)showWithAnimation:(BOOL)animated;
- (void)hideWithAnimation:(BOOL)animated;

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)motionAfterScrollViewWillBeginDragging:(UIScrollView *)scrollView;

@end
