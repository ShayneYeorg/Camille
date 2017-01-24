//
//  Accounting+CoreDataClass.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Accounting+CoreDataClass.h"
#import "CMLTool+NSDate.h"

#warning - 要完善
#define kEmptyString         @""

@implementation Accounting

+ (void)addAccountingWithItemID:(NSString *)itemID amount:(NSNumber *)amount happneTime:(NSDate *)happenTime desc:(NSString *)desc callBack:(void(^)(CMLResponse *response))callBack {
    //Entity
    Accounting *accounting = [NSEntityDescription insertNewObjectForEntityForName:@"Accounting" inManagedObjectContext:kManagedObjectContext];
    accounting.accountingID = kEmptyString; //应该先检查重复，要完善
    accounting.owner = kEmptyString;
    accounting.itemID = itemID;
    accounting.amount = amount;
    accounting.happenTime = happenTime;
    accounting.desc = desc;
    accounting.happenDay = [CMLTool getDayFromADate:happenTime];
    accounting.createTime = [NSDate date];
    
    //保存
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
    NSError *error = nil;
    if ([kManagedObjectContext save:&error]) {
        cmlResponse.code = RESPONSE_CODE_SUCCEED;
        cmlResponse.desc = kTipSaveSuccess;
        cmlResponse.responseDic = nil;
        
    } else {
        CMLLog(@"保存Accounting发生错误:%@,%@", error, [error userInfo]);
        cmlResponse.code = RESPONSE_CODE_FAILD;
        cmlResponse.desc = kTipSaveFail;
        cmlResponse.responseDic = nil;
    }
    
    callBack(cmlResponse);
}

+ (void)deleteAccounting:(Accounting *)accounting callBack:(void(^)(CMLResponse *response))callBack {
    [kManagedObjectContext deleteObject:accounting];
    
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
    NSError *error = nil;
    if([kManagedObjectContext save:&error]) {
        cmlResponse.code = RESPONSE_CODE_SUCCEED;
        cmlResponse.desc = kTipDeleteSuccess;
        cmlResponse.responseDic = nil;
        
    } else {
        CMLLog(@"删除Accounting失败");
        cmlResponse.code = RESPONSE_CODE_FAILD;
        cmlResponse.desc = kTipDeleteFail;
        cmlResponse.responseDic = nil;
    }
    callBack(cmlResponse);
}

+ (void)fetchAccountingsFrom:(NSInteger)startIndex count:(NSInteger)count callBack:(void(^)(CMLResponse *response))callBack {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounting" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //Response
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
    
    //设置排序规则
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"happenTime" ascending:NO];
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置数据条数
    [request setFetchOffset:startIndex];
    [request setFetchLimit:count];
    
    //查询
    NSError *error = nil;
    NSArray *accountings = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    //返回数据
    if (accountings == nil) {
        CMLLog(@"查询Accounting时发生错误:%@,%@", error, [error userInfo]);
        cmlResponse.code = RESPONSE_CODE_FAILD;
        cmlResponse.desc = kTipFetchFail;
        cmlResponse.responseDic = nil;
        
    } else {
        cmlResponse.code = RESPONSE_CODE_SUCCEED;
        cmlResponse.desc = kTipFetchSuccess;
        cmlResponse.responseDic = @{@"accountings": accountings};
    }
    
    callBack(cmlResponse);
}

@end
