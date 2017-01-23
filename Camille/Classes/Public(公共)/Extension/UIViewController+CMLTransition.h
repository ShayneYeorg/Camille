//
//  UIViewController+CMLTransition.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CMLTransition) <UIViewControllerTransitioningDelegate>

- (void)CML_presentViewController:(UIViewController *)viewControllerToPresent animationType:(NSInteger)animationType completion:(void (^)(void))completion;

@end
