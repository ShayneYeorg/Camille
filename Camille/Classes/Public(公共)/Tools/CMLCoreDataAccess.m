//
//  CMLCoreDataAccess.m
//  Camille
//
//  Created by 杨淳引 on 16/2/28.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLCoreDataAccess.h"

@implementation CMLCoreDataAccess

//新增数据
+ (void)addAccountingWithItem:(NSString *)item amount:(NSNumber *)amount happneTime:(NSDate *)happenTime callBack:(void(^)(CMLResponse *response))callBack {
    //Entity
    CMLAccounting *accounting = [NSEntityDescription insertNewObjectForEntityForName:@"CMLAccounting" inManagedObjectContext:kManagedObjectContext];
    accounting.item = item;
    accounting.amount = amount;
    accounting.happenTime = happenTime;
    accounting.createTime = [NSDate date];
    
    //异步保存数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Response
        CMLResponse *cmlresponse = [[CMLResponse alloc]init];
        
        //保存
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) {
            if (error) CMLLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
            cmlresponse.code = RESPONSE_CODE_FAILD;
            cmlresponse.desc = @"保存失败";
            cmlresponse.responseDic = nil;
            
        } else {
            cmlresponse.code = RESPONSE_CODE_SUCCEED;
            cmlresponse.desc = @"保存成功";
            cmlresponse.responseDic = nil;
        }
        
        //回调
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(cmlresponse);
        });
    });
}

@end
