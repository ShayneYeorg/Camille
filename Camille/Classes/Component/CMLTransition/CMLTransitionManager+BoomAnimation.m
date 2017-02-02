//
//  CMLTransitionManager+BoomAnimation.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/25.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLTransitionManager+BoomAnimation.h"

@implementation CMLTransitionManager (BoomAnimation)

- (void)boomOpenWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImage *backgroungImage = [self imageFromView:fromVC.view atFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroungImage];
    
    UIView *containView = [transitionContext containerView];
    [containView addSubview:imageView];
    [containView addSubview:toVC.view];
    toVC.view.layer.transform = CATransform3DMakeScale(0.3,0.3,1);
    
    [UIView animateWithDuration:self.transitionTime animations:^{
        toVC.view.layer.transform = CATransform3DMakeScale(0.9,0.9,1);
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            
        } else {
            [transitionContext completeTransition:YES];
        }
    }];
}

- (void)boomCloseWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    UIView *containView = [transitionContext containerView];
    
    [containView addSubview:toVC.view];
    [containView addSubview:tempView];
    
    tempView.layer.transform = CATransform3DIdentity;
    [UIView animateWithDuration:self.transitionTime animations:^{
        tempView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            fromVC.view.hidden = NO;
            [tempView removeFromSuperview];
            
        } else {
            [transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            fromVC.view.hidden = YES;
            [tempView removeFromSuperview];
        }
    }];
}

- (UIImage *)imageFromView:(UIView *)view atFrame:(CGRect)rect {
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
