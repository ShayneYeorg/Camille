//
//  CMLTransitionManager+BreakOpenAnimation.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLTransitionManager+BreakOpenAnimation.h"

@implementation CMLTransitionManager (BreakOpenAnimation)


- (void)breakOpenWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containView = [transitionContext containerView];
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect rect0 ;
    CGRect rect1;
    
//    switch (type) {
//        case WXSTransitionAnimationTypeBrickOpenHorizontal:
//            rect0 = CGRectMake(0 , 0 , screenWidth/2, screenHeight);
//            rect1 = CGRectMake(screenWidth/2 , 0 , screenWidth/2, screenHeight);
//            break;
//        default:
            rect0 = CGRectMake(0 , 0 , screenWidth, screenHeight/2);
            rect1 = CGRectMake(0 , screenHeight/2 , screenWidth, screenHeight/2);
//            break;
//    }
    
    UIImage *image0 = [self imageFromView:fromVC.view atFrame:rect0];
    UIImage *image1 = [self imageFromView:fromVC.view atFrame:rect1];
    
    UIImageView *imgView0 = [[UIImageView alloc] initWithImage:image0];
    UIImageView *imgView1 = [[UIImageView alloc] initWithImage:image1];
    
    [containView addSubview:fromVC.view];
    [containView addSubview:toVC.view];
    [containView addSubview:imgView0];
    [containView addSubview:imgView1];
    
    
    [UIView animateWithDuration:1 animations:^{
        
//        switch (type) {
//            case WXSTransitionAnimationTypeBrickOpenHorizontal:
//                imgView0.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0);
//                imgView1.layer.transform = CATransform3DMakeTranslation(screenWidth/2, 0, 0);
//                break;
//            default:
                imgView0.layer.transform = CATransform3DMakeTranslation(0, -screenHeight/2, 0);
                imgView1.layer.transform = CATransform3DMakeTranslation(0, screenHeight/2, 0);
//                break;
//        }
        
    } completion:^(BOOL finished) {
        
        if ([transitionContext transitionWasCancelled]) {
            
            [transitionContext completeTransition:NO];
            [imgView0 removeFromSuperview];
            [imgView1 removeFromSuperview];
            
        }else{
            [transitionContext completeTransition:YES];
            [imgView0 removeFromSuperview];
            [imgView1 removeFromSuperview];
        }
    }];
    
}

- (UIImage *)imageFromView: (UIView *)view atFrame:(CGRect)rect{
    
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;
    
}

@end
