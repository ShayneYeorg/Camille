//
//  Accounting+CoreDataClass.h
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Accounting : NSManagedObject

NS_ASSUME_NONNULL_BEGIN

/**
 *  新增账务记录
 *
 *  @param itemID               记账项目ID
 *  @param amount               金额
 *  @param happenTime           发生时间
 *  @param desc                 备注
 *  @param callBack             回调
 */
+ (void)addAccountingWithItemID:(NSString *)itemID amount:(NSNumber *)amount happneTime:(NSDate *)happenTime desc:(NSString *)desc callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  删除账务记录
 *
 *  @param accounting           账务对象
 *  @param callBack             回调
 */
+ (void)deleteAccounting:(Accounting *)accounting callBack:(void(^)(CMLResponse *response))callBack;

/**
 *  查询下标范围内的账务信息
 *
 *  @param startIndex           开始下标
 *  @param count                条数
 */
+ (void)fetchAccountingsFrom:(NSInteger)startIndex count:(NSInteger)count callBack:(void(^)(CMLResponse *response))callBack;

NS_ASSUME_NONNULL_END


//由于这个方法可传nil，所以放在NONULL编译块的外面
/**
 修改某条accounting

 @param accounting 要修改的账务
 @param amount 修改的金额
 @param desc 修改的备注
 @param itemID 修改的所属item
 @param callBack 回调
 */
+ (void)alertAccounting:(Accounting * _Nonnull)accounting amount:(NSNumber * _Nullable)amount desc:(NSString * _Nullable)desc itemID:(NSString * _Nullable)itemID callback:(void(^_Nullable)(CMLResponse * _Nullable response))callBack;

@end

#import "Accounting+CoreDataProperties.h"




//测试代码
//    [Accounting addAccountingWithItemID:@"5" amount:[NSNumber numberWithFloat:10] happneTime:[NSDate date] desc:@"无" callBack:^(CMLResponse * _Nonnull response) {}];

//    [Accounting fetchAccountingsFrom:0 count:5 callBack:^(CMLResponse * _Nonnull response) {
//        if ([response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
//            for (Accounting *a in response.responseDic[@"accountings"]) {
//                CMLLog(@"%@", a.itemID);
////                if ([a.itemID isEqualToString:@"2"]) {
////                    [Accounting deleteAccounting:a callBack:^(CMLResponse * _Nonnull response) { }];
////                }
//            }
//        }
//    }];




