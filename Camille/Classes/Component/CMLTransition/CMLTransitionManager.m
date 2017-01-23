//
//  CMLTransitionManager.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLTransitionManager.h"
#import "CMLTransitionManager+BreakOpenAnimation.h"

@interface CMLTransitionManager ()

@property (nonatomic, assign) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CMLTransitionManager

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return _animationTime;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    [self transitionBackAnimation:transitionContext withAnimationType:0];
}

- (void)transitionBackAnimation:(id <UIViewControllerContextTransitioning>) transitionContext withAnimationType:(NSInteger)animationType {
    
//    if ((NSInteger)animationType < (NSInteger)WXSTransitionAnimationTypeDefault) {
//        [self backSysTransitionAnimationWithType:_backAnimationType  context:transitionContext];
//    }
//    
//    unsigned int count = 0;
//    Method *methodlist = class_copyMethodList([WXSTransitionManager class], &count);
//    int tag= 0;
//    for (int i = 0; i < count; i++) {
//        Method method = methodlist[i];
//        SEL selector = method_getName(method);
//        NSString *methodName = NSStringFromSelector(selector);
//        if ([methodName rangeOfString:@"BackTransitionAnimation"].location != NSNotFound) {
//            tag++;
//            if (tag == animationType - WXSTransitionAnimationTypeDefault) {
//                ((void (*)(id,SEL,id<UIViewControllerContextTransitioning>,WXSTransitionAnimationType))objc_msgSend)(self,selector,transitionContext,animationType);
//                break;
//            }
//            
//        }
//    }
//    free(methodlist);
    
    [self brickOpenVerticalNextTransitionAnimation:transitionContext];
}

- (void)brickOpenVerticalNextTransitionAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self breakOpenWithTransitionContext:transitionContext];
}

@end
