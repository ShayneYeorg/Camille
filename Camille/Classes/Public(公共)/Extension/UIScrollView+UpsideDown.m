//
//  UIScrollView+UpsideDown.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/22.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "UIScrollView+UpsideDown.h"

@implementation UIScrollView (UpsideDown)

- (void)setScrollsToBottom:(BOOL)scrollsToBottom {
    objc_setAssociatedObject(self, @selector(scrollsToBottom), @(scrollsToBottom), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)scrollsToBottom {
    return objc_getAssociatedObject(self, _cmd);
}

@end
