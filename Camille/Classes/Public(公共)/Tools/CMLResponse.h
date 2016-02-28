//
//  CMLResponse.h
//  Camille
//
//  Created by 杨淳引 on 16/2/28.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMLResponse : NSObject

@property (nonatomic, strong) NSString *desc; //查询结果描述
@property (nonatomic, strong) NSString *code; //查询结果代码
@property (nonatomic, strong) NSDictionary *responseDic; //查询结果

@end
