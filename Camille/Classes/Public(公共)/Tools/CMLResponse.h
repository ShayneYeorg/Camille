//
//  CMLResponse.h
//  Camille
//
//  Created by 杨淳引 on 16/2/28.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RESPONSE_CODE_SUCCEED         @"000"//查询成功
#define RESPONSE_CODE_FAILD           @"111"//查询失败

@interface CMLResponse : NSObject

@property (nonatomic, strong) NSString *desc; //查询结果描述
@property (nonatomic, strong) NSString *code; //查询结果代码
@property (nonatomic, strong) NSDictionary *responseDic; //查询结果

@end
