//
//  DescInputViewController.h
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DescDismissBlock)(NSString *desc);

@interface DescInputViewController : UIViewController

@property (nonatomic, copy) DescDismissBlock dismissBlock;

+ (instancetype)initWithInitialPosition:(CGRect)initialPosition initialText:(NSString *)initialText;

@end
