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
#define kTipFetchNoRecord             @"查询无记录"
#define kTipExist                     @"查询对象已存在"
#define kTipRestore                   @"科目已复原"

//KEY
#define KEY_Item                      @"item"
#define KEY_Items                     @"items"
#define KEY_Income_Items              @"incomeItems"
#define KEY_Cost_Items                @"costItems"
#define KEY_ItemID                    @"itemID"
#define KEY_Accountings               @"accountings"
#define KEY_Pollution_Items           @"pollutionItems"

#define KEY_Day_Summaries             @"daySummaries"
#define KEY_Day_Summary               @"daySummary"

//常用短语
#define PHRASE_ResponseSuccess        (response && [response.code isEqualToString:RESPONSE_CODE_SUCCEED])
#define PHRASE_ResponseNoRecord       (response && [response.code isEqualToString:RESPONSE_CODE_NO_RECORD])

@interface CMLResponse : NSObject

@property (nonatomic, strong) NSString *desc; //查询结果描述
@property (nonatomic, strong) NSString *code; //查询结果代码
@property (nonatomic, strong) NSDictionary *responseDic; //查询结果

@end
