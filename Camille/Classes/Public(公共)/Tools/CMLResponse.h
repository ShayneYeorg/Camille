//
//  CMLResponse.h
//  Camille
//
//  Created by 杨淳引 on 16/2/28.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

//响应码
#define RESPONSE_CODE_SUCCEED         @"000" //查询成功
#define RESPONSE_CODE_ERROR           @"001" //查询出错
#define RESPONSE_CODE_FAILD           @"111" //查询失败
#define RESPONSE_CODE_NO_RECORD       @"011" //查询无记录

//提示语
#define kTipSaveSuccess               @"保存成功"
#define kTipSaveFail                  @"保存失败"
#define kTipDeleteSuccess             @"删除成功"
#define kTipDeleteFail                @"删除失败"
#define kTipFetchSuccess              @"查询成功"
#define kTipFetchFail                 @"查询失败"

@interface CMLResponse : NSObject

@property (nonatomic, strong) NSString *desc; //查询结果描述
@property (nonatomic, strong) NSString *code; //查询结果代码
@property (nonatomic, strong) NSDictionary *responseDic; //查询结果

@end
