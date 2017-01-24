//
//  CMLTransitionManager.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLTransitionManager.h"
#import "CMLTransitionManager+BreakOpenAnimation.h"
#import "UIViewController+CMLTransition.h"

@interface CMLTransitionManager ()

//@property (nonatomic, assign) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CMLTransitionManager

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *viewControllerToPresent = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [self transitionAnimation:transitionContext transitionAnimationType:viewControllerToPresent.transitionAnimationType transitionType:_transitionType];
}

- (void)transitionAnimation:(id <UIViewControllerContextTransitioning>)transitionContext transitionAnimationType:(CMLTransitionAnimationType)animationType transitionType:(CMLTransitionType)transitionType {
    switch (animationType) {
        case CMLTransitionAnimationBreakOpen:
            [self breakTransitionWithContext:transitionContext transitionType:transitionType];
            break;
            
        default:
//            [self brickOpenVerticalBackTransitionAnimation:transitionContext];
            break;
    }
}

- (void)breakTransitionWithContext:(id <UIViewControllerContextTransitioning>)transitionContext transitionType:(CMLTransitionType)transitionType {
    switch (transitionType) {
        case CMLTransitionOpen:
            [self breakOpenWithTransitionContext:transitionContext];
            break;
            
        case CMLTransitionClose:
            [self brickCloseBackWithTransitionContext:transitionContext];
            break;
            
        default:
            break;
    }
}

@end
