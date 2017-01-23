//
//  CMLTransitionManager.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMLTransitionManager : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) NSInteger transitionType;
@property (nonatomic, assign) NSTimeInterval animationTime;

@end
