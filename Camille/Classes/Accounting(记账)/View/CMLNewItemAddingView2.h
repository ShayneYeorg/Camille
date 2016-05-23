//
//  CMLNewItemAddingView2.h
//  Camille
//
//  Created by 杨淳引 on 16/3/8.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NewItemAddingClickHandler2)(NSString *itemName, NSString *categoryName);

@interface CMLNewItemAddingView2 : UIView

+ (instancetype)loadFromNib;
- (void)showWithClickHandler:(NewItemAddingClickHandler2)clickHandler;

@end
