//
//  CMLNewItemAddingView2.h
//  Camille
//
//  Created by 杨淳引 on 16/3/8.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _AddingViewType {
    Adding_View_Type_Category = 0,
    Adding_View_Type_Item
} AddingViewType;
typedef void (^NewItemAddingClickHandler2)(NSString *addingName);

@interface CMLNewItemAddingView2 : UIView

@property (nonatomic, assign) AddingViewType addingViewType;

+ (instancetype)loadFromNib;
- (void)showWithClickHandler:(NewItemAddingClickHandler2)clickHandler;

@end
