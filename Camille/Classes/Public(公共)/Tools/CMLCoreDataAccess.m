//
//  CMLCoreDataAccess.m
//  Camille
//
//  Created by 杨淳引 on 16/2/28.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLCoreDataAccess.h"

@implementation CMLCoreDataAccess

//取出所有记账科目(并排序)
+ (void)fetchAllItems:(void(^)(CMLResponse *response))callBack {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItem" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //异步取数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Response
        CMLResponse *cmlResponse = [[CMLResponse alloc]init];
        
        //查询
        NSError *error = nil;
        NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        //取数据
        if (items == nil) {
            CMLLog(@"查询所有数据时发生错误:%@,%@",error,[error userInfo]);
            cmlResponse.code = RESPONSE_CODE_FAILD;
            cmlResponse.desc = @"读取失败";
            cmlResponse.responseDic = nil;
            
        } else {
            cmlResponse.code = RESPONSE_CODE_SUCCEED;
            cmlResponse.desc = @"读取成功";
            cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:items, @"items", nil];
            
            //排序
            
        }
        
        //回调
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(cmlResponse);
        });
    });
}

//取出所有一级记账科目(并排序)
+ (void)fetchAllItemCategories:(void(^)(CMLResponse *response))callBack {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //异步取数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Response
        CMLResponse *cmlResponse = [[CMLResponse alloc]init];
        
        //查询
        NSError *error = nil;
        NSMutableArray *itemCategories = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        //取数据
        if (itemCategories == nil) {
            CMLLog(@"查询所有数据时发生错误:%@,%@",error,[error userInfo]);
            cmlResponse.code = RESPONSE_CODE_FAILD;
            cmlResponse.desc = @"读取失败";
            cmlResponse.responseDic = nil;
            
        } else {
            cmlResponse.code = RESPONSE_CODE_SUCCEED;
            cmlResponse.desc = @"读取成功";
            cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:[CMLItemCategory sortItemCategories:itemCategories], @"items", nil];
        }
        
        //回调
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(cmlResponse);
        });
    });
}

//新增一级记账科目
+ (void)addItemCategory:(NSString *)ItemCategoryName callBack:(void(^)(CMLResponse *response))callBack {
    CMLLog(@"新增一级记账科目所在的线程是：%@", [NSThread currentThread]);
    
    //Response
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
    
    //分配新ID
    NSString *newID = [CMLCoreDataAccess getANewItemCategoryID];
    if (newID == nil) {
        cmlResponse.code = RESPONSE_CODE_FAILD;
        cmlResponse.desc = @"分配新的一级科目ID出错";
        cmlResponse.responseDic = nil;
        callBack(cmlResponse);
        
    } else {
        //Entity
        CMLItemCategory *itemCategory = [NSEntityDescription insertNewObjectForEntityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
        itemCategory.categoryName = ItemCategoryName;
        itemCategory.categoryID = newID;
        itemCategory.nextCategoryID = nil;
        
        //保存
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) {
            if (error) CMLLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
            cmlResponse.code = RESPONSE_CODE_FAILD;
            cmlResponse.desc = @"保存一级科目出错";
            cmlResponse.responseDic = nil;
            
        } else {
            cmlResponse.code = RESPONSE_CODE_SUCCEED;
            cmlResponse.desc = @"保存一级科目成功";
            cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:newID, @"itemCategoryID", nil];
        }
        
        //回调
        callBack(cmlResponse);
    }
}

//新分配一个一级记账科目的ID
+ (NSString *)getANewItemCategoryID {
    //先获取最大ID，再加1
    CMLLog(@"新分配一个一级记账科目的ID所在的线程是：%@", [NSThread currentThread]);
    
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置排序规则
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO comparator:^(CMLItemCategory *obj1, CMLItemCategory *obj2) {
        NSInteger idNum1 = [obj1.categoryID integerValue];
        NSInteger idNum2 = [obj2.categoryID integerValue];
        return [@(idNum1) compare:@(idNum2)];
    }];
    NSArray * sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置数据条数
    [request setFetchLimit:1];
    [request setFetchOffset:0];
    
    //查询
    NSError *error = nil;
    NSMutableArray *itemCategories = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (itemCategories.count) {
        CMLItemCategory *ic = itemCategories[0];
        NSInteger newID = ic.categoryID.integerValue + 1;
        CMLLog(@"新分配的一级科目ID是：%zd", newID);
        return [NSString stringWithFormat:@"%zd", newID];
        
    } else {
        //要么是查询过程中出错
        //要么是第一个一级科目（这是不可能的）
        CMLLog(@"查询一级科目最大ID时发生错误:%@,%@",error,[error userInfo]);
        return nil;
    }
}

//新增数据
+ (void)addAccountingWithItem:(NSString *)itemID amount:(NSNumber *)amount happneTime:(NSDate *)happenTime callBack:(void(^)(CMLResponse *response))callBack {
    //Entity
    CMLAccounting *accounting = [NSEntityDescription insertNewObjectForEntityForName:@"CMLAccounting" inManagedObjectContext:kManagedObjectContext];
    accounting.itemID = itemID;
    accounting.amount = amount;
    accounting.happenTime = happenTime;
    accounting.createTime = [NSDate date];
    
    //异步保存数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Response
        CMLResponse *cmlResponse = [[CMLResponse alloc]init];
        
        //保存
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) {
            if (error) CMLLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
            cmlResponse.code = RESPONSE_CODE_FAILD;
            cmlResponse.desc = @"保存失败";
            cmlResponse.responseDic = nil;
            
        } else {
            cmlResponse.code = RESPONSE_CODE_SUCCEED;
            cmlResponse.desc = @"保存成功";
            cmlResponse.responseDic = nil;
        }
        
        //回调
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(cmlResponse);
        });
    });
}

@end
