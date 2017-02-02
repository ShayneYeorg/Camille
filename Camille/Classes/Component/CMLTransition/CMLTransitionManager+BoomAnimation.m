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
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
//    UIView *tempView = [toVC.view snapshotViewAfterScreenUpdates:YES];
    UIView *containView = [transitionContext containerView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect rect0 = CGRectMake(0 , 0 , screenWidth, screenHeight/2);
    CGRect rect1 = CGRectMake(0 , screenHeight/2 , screenWidth, screenHeight/2);
    
    UIImage *image0 = [self imageFromView:fromVC.view atFrame:rect0];
    UIImage *image1 = [self imageFromView:fromVC.view atFrame:rect1];
    
    UIImageView *imgView0 = [[UIImageView alloc] initWithImage:image0];
    UIImageView *imgView1 = [[UIImageView alloc] initWithImage:image1];
    
    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];
//    [containView addSubview:imgView0];
//    [containView addSubview:imgView1];
    
//    [containView addSubview:toVC.view];
//    [containView addSubview:fromVC.view];
//    [containView addSubview:tempView];
    
//    tempView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    
    toView.layer.transform = CATransform3DMakeScale(0.3,0.3,1);
    
    [UIView animateWithDuration:self.transitionTime animations:^{
        toView.layer.transform = CATransform3DMakeScale(0.9,0.9,1);
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            fromView.layer.transform = CATransform3DIdentity;
            
        } else {
            [transitionContext completeTransition:YES];
            fromView.layer.transform = CATransform3DIdentity;
        }
    }];
    
//    [UIView animateWithDuration:self.transitionTime delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:1/0.4 options:0 animations:^{
//        tempView.layer.transform = CATransform3DIdentity;
//        
//    } completion:^(BOOL finished) {
//        if ([transitionContext transitionWasCancelled]) {
//            [transitionContext completeTransition:NO];
//            
//        } else {
//            [transitionContext completeTransition:YES];
//            toVC.view.hidden = NO;
//        }
//        [tempView removeFromSuperview];
//    }];
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
