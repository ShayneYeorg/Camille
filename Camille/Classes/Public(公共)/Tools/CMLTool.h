//
//  CMLTool.h
//  Camille
//
//  Created by 杨淳引 on 16/2/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLCoreDataAccess.h"

//账务类型
#define Item_Type_Cost      @"1"
#define Item_Type_Income    @"2"

//科目和账务是否有效
#define Record_Available    @"1"
#define Record_Unavailable  @"0"

@interface CMLTool : NSObject

+ (UIWindow *)getWindow;

@end
