//
//  CMLTransitionManager+BoomAnimation.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/25.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLTransitionManager.h"

@interface CMLTransitionManager (BoomAnimation)

- (void)boomOpenWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)boomCloseWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
