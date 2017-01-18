//
//  TestDataAccounting.h
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestDataAccounting : NSObject

@property (nonatomic, assign) BOOL isOutcome;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, copy) NSString *desc;

@end
