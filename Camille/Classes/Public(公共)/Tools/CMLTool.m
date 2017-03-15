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

+ (CGFloat)widthWithText:(NSString *)text font:(UIFont *)font {
    if (text) {
        CGSize size = CGSizeZero;
        CGSize rSize = CGSizeMake(200, 13);
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, nil];
        CGRect rect = [text boundingRectWithSize:rSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        size = rect.size;
        
        return size.width;
    }
    
    return 0;
}

@end
