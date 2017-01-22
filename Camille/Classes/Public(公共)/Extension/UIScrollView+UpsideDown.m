//
//  UIScrollView+UpsideDown.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/22.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "UIScrollView+UpsideDown.h"

static BOOL _scrollsToBottom;

@implementation UIScrollView (UpsideDown)

- (void)setScrollsToBottom:(BOOL)scrollsToBottom {
    _scrollsToBottom = scrollsToBottom;
}

- (BOOL)scrollsToBottom {
    return _scrollsToBottom;
}

@end
