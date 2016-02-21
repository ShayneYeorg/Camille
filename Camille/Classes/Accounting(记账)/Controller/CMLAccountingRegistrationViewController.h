//
//  CMLAccountingRegistrationViewController.h
//  Camille
//
//  Created by 杨淳引 on 16/2/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _AccountingType {
    Accounting_Type_Income = 0,
    Accounting_Type_Cost
} AccountingType;

@interface CMLAccountingRegistrationViewController : UIViewController

@property (nonatomic, assign) AccountingType type;

@end
