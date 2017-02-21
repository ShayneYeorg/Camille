//
//  CMLTransitionManager+CommonMethods.m
//  Camille
//
//  Created by 杨淳引 on 2017/2/21.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLTransitionManager+CommonMethods.h"

@implementation CMLTransitionManager (CommonMethods)

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
