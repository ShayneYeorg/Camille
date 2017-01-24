//
//  CMLTransitionManager+BreakAnimation.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLTransitionManager.h"

@interface CMLTransitionManager (BreakAnimation)

- (void)breakOpenWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)breakCloseWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
