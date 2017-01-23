//
//  UIViewController+CMLTransition.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "UIViewController+CMLTransition.h"
#import "CMLTransitionManager.h"

@implementation UIViewController (CMLTransition)

- (void)CML_presentViewController:(UIViewController *)viewControllerToPresent animationType:(NSInteger)animationType completion:(void (^)(void))completion {
    
    [self CML_presentViewController:viewControllerToPresent completion:completion];
}

//-(void)wxs_presentViewController:(UIViewController *)viewControllerToPresent makeTransition:(WXSTransitionBlock)transitionBlock completion:(void (^)(void))completion{

- (void)CML_presentViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion {
    
//    if (viewControllerToPresent.transitioningDelegate) {
//        self.CML_transitioningDelegate = viewControllerToPresent.transitioningDelegate;
//    }
//    viewControllerToPresent.CML_addTransitionFlag = YES;
    viewControllerToPresent.transitioningDelegate = viewControllerToPresent;
//    viewControllerToPresent.wxs_callBackTransition = transitionBlock ? transitionBlock : nil;
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}

//- (void)setCML_addTransitionFlag:(BOOL)addTransitionFlag {
//    objc_setAssociatedObject(self, @selector(CML_addTransitionFlag), @(addTransitionFlag), OBJC_ASSOCIATION_ASSIGN);
//}
//- (BOOL)CML_addTransitionFlag {
//    return ([objc_getAssociatedObject(self, _cmd) integerValue] != 0);
//}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
//    if (!self.wxs_addTransitionFlag) {
//        return nil;//present directly
//    }
    
//    !_transtion ? _transtion = [[WXSTransitionManager alloc] init] : nil ;
//    WXSTransitionProperty *make = [[WXSTransitionProperty alloc] init];
//    self.wxs_callBackTransition ? self.wxs_callBackTransition(make) : nil;
//    _transtion = [WXSTransitionManager copyPropertyFromObjcet:make toObjcet:_transtion];
//    _transtion.transitionType = WXSTransitionTypePresent;
//    self.wxs_delegateFlag = _transtion.isSysBackAnimation ? NO : YES;
//    self.wxs_backGestureEnable =  make.backGestureEnable;
//    return _transtion;
    
    return [CMLTransitionManager new];
}

@end
