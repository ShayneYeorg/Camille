//
//  UIViewController+CMLTransition.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLTransitionManager.h"

@interface UIViewController (CMLTransition) <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) CMLTransitionAnimationType transitionAnimationType;

- (void)CML_presentViewController:(UIViewController *)viewControllerToPresent transitionType:(CMLTransitionAnimationType)transitionType completion:(void (^)(void))completion;

@end
