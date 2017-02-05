//
//  ItemInputViewController.h
//  Camille
//
//  Created by 杨淳引 on 2017/2/5.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DismissBlock)(NSString *itemID);

@interface ItemInputViewController : UIViewController

@property (nonatomic, copy) DismissBlock dismissBlock;

+ (instancetype)initWithInitialPosition:(CGRect)initialPosition itemType:(NSString *)itemType;

@end
