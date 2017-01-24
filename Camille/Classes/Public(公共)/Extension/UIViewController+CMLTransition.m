//
//  UIViewController+CMLTransition.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "UIViewController+CMLTransition.h"

CMLTransitionManager *_transtion;

@implementation UIViewController (CMLTransition)

- (void)setTransitionAnimationType:(CMLTransitionAnimationType)transitionAnimationType {
    objc_setAssociatedObject(self, @selector(transitionAnimationType), @(transitionAnimationType), OBJC_ASSOCIATION_RETAIN);
}

- (CMLTransitionAnimationType)transitionAnimationType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)CML_presentViewController:(UIViewController *)viewControllerToPresent transitionType:(CMLTransitionAnimationType)transitionAnimationType completion:(void (^)(void))completion {
    viewControllerToPresent.transitioningDelegate = viewControllerToPresent;
    viewControllerToPresent.transitionAnimationType = transitionAnimationType;
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    !_transtion ? _transtion = [[CMLTransitionManager alloc] init] : nil ;
    _transtion.transitionType = CMLTransitionOpen;
    return _transtion;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    !_transtion ? _transtion = [[CMLTransitionManager alloc] init] : nil;
    _transtion.transitionType = CMLTransitionClose;
    return _transtion;
}

@end
