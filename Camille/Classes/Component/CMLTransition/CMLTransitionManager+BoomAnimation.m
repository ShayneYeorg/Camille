//
//  CMLTransitionManager+BoomAnimation.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/25.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLTransitionManager+BoomAnimation.h"
#import "CMLTransitionManager+CommonMethods.h"

@implementation CMLTransitionManager (BoomAnimation)

- (void)boomOpenWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //生成一张fromVC的图片
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImage *backgroungImage = [self imageFromView:fromVC.view atFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroungImage];
    
    //图片上再盖一层黑色蒙板
    UIView *mask = [[UIView alloc]initWithFrame:imageView.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.5;
    [imageView addSubview:mask];
    
    //依次添加
    UIView *containView = [transitionContext containerView];
    [containView addSubview:imageView];
    [containView addSubview:toVC.view];
    toVC.view.layer.transform = CATransform3DMakeScale(0.3,0.3,1);
    
    //动画
    [UIView animateWithDuration:self.transitionTime animations:^{
        toVC.view.layer.transform = CATransform3DMakeScale(1,1,1);
        
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
    
    //生成一张toVC的图片
    UIImage *backgroungImage = [self imageFromView:fromVC.view atFrame:fromVC.view.frame];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroungImage];
    
    UIView *containView = [transitionContext containerView];
    [containView addSubview:toVC.view];
    [containView addSubview:imageView];
    
    imageView.layer.transform = CATransform3DIdentity;
    [UIView animateWithDuration:self.transitionTime animations:^{
        imageView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            fromVC.view.hidden = NO;
            [imageView removeFromSuperview];
            
        } else {
            [transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            fromVC.view.hidden = YES;
            [imageView removeFromSuperview];
        }
    }];
}

@end
