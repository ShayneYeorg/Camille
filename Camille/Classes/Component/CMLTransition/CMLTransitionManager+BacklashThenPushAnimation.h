//
//  CMLTransitionManager+BacklashThenPushAnimation.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLTransitionManager.h"

@interface CMLTransitionManager (BacklashThenPushAnimation)

- (void)backlashThenPushWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)backlashThenPopWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
