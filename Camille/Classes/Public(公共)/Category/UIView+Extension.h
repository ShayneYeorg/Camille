//
//  UIView+Extension.h
//  ondine
//
//  Created by 杨淳引 on 15/5/23.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//
//  这个分类用来简化frame的各个属性赋值的过程

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@end
