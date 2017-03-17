//
//  AccountViewController.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/23.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMLDataManager.h"

UIKIT_EXTERN NSString *const AccountingDidAlertNotification;

@interface AccountViewController : UIViewController

- (instancetype)initWithAccounting:(MainCellModel *)accounting;

@end
