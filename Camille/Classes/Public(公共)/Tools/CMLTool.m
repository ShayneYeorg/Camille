//
//  CMLTool.m
//  Camille
//
//  Created by 杨淳引 on 16/2/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLTool.h"

@implementation CMLTool

+ (UIWindow *)getWindow {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    return window;
}

@end
