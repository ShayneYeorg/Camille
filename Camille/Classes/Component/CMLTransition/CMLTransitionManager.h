//
//  CMLTransitionManager.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, CMLTransitionAnimationType) {
    CMLTransitionAnimationBreak = 0,
    CMLTransitionAnimationBacklashThenPush,
};

typedef NS_ENUM (NSInteger, CMLTransitionType) {
    CMLTransitionOpen = 0,
    CMLTransitionClose,
};

@interface CMLTransitionManager : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CMLTransitionType transitionType;
@property (nonatomic, assign) NSTimeInterval transitionTime;

@end
