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
            if (error) {
                CMLLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
                cmlResponse.code = RESPONSE_CODE_FAILD;
                cmlResponse.desc = @"保存一级科目出错";
                cmlResponse.responseDic = nil;
                
            } else {
                cmlResponse.code = RESPONSE_CODE_SUCCEED;
                cmlResponse.desc = [NSString stringWithFormat:@"保存一级科目成功:%@ %@",newID, ItemCategoryName];
                cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:newID, @"itemCategoryID", nil];
                CMLLog(@"%@", cmlResponse.desc);
                
                //将一级科目链表最后一个科目的nextCategoryID置为newID
                [CMLCoreDataAccess setLastItemCategoryNextID:newID];
            }
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
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:NO  selector:@selector(localizedStandardCompare:)];//像Mac finder中的排序方式一般
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置数据条数
    [request setFetchLimit:1];
    [request setFetchOffset:0];
    
    //查询
    NSError *error = nil;
    NSMutableArray *itemCategories = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (itemCategories == nil) {
        //查询过程中出错
        CMLLog(@"查询一级科目最大ID时发生错误:%@,%@",error,[error userInfo]);
        return nil;
        
    } else if (itemCategories.count) {
        //正常
        CMLItemCategory *ic = itemCategories[0];
        NSInteger newID = ic.categoryID.integerValue + 1;
        CMLLog(@"新分配的一级科目ID是：%zd", newID);
        return [NSString stringWithFormat:@"%zd", newID];
        
    } else {
        //还没有任何一级科目
        //建立一级科目链表头
        [CMLCoreDataAccess createItemCategoryListHead];
        //返回第一个一级科目ID
        return @"1";
    }
}

//建立一级科目链表头
+ (void)createItemCategoryListHead {
    //Entity
    CMLItemCategory *itemCategory = [NSEntityDescription insertNewObjectForEntityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
#warning 要禁止记账科目使用这个名称
    itemCategory.categoryName = @"CATEGORY_LIST_HEAD"; //在APP里成关键字，要禁止记账科目使用这个名称
    itemCategory.categoryID = @"0";
    itemCategory.nextCategoryID = nil;
    
    //保存
    NSError *error = nil;
    if (error) {
        CMLLog(@"建立一级科目链表头时发生错误:%@,%@",error,[error userInfo]);
        
    } else {
        CMLLog(@"%@", [NSString stringWithFormat:@"建立一级科目链表头成功"]);
    }
}

//将一级科目链表最后一个科目的nextCategoryID置为newID
+ (void)setLastItemCategoryNextID:(NSString *)nextID {
    //第一个科目滚蛋
//    if ([nextID isEqualToString:@"0"]) return;
    
    //先获取链表最后一个科目，再修改它的nextCategoryID
    CMLLog(@"获取链表最后一个科目所在的线程是：%@", [NSThread currentThread]);
    
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置排序规则
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES  selector:@selector(localizedStandardCompare:)];//像Mac Finder中的排序方式一般
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"nextCategoryID==NULL"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    //设置数据条数
    [request setFetchLimit:1];
    [request setFetchOffset:0];
    
    //查询
    NSError *error = nil;
    NSMutableArray *itemCategories = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (itemCategories == nil) {
        //查询过程中出错
        CMLLog(@"查询一级科目链表最后一个科目时发生错误:%@,%@",error,[error userInfo]);
        
    } else if (itemCategories.count) {
        //正常
        CMLItemCategory *ic = itemCategories[0];
        ic.nextCategoryID = nextID;
        
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) CMLLog(@"修改最后一个科目(%@)的nextCategoryID(%@)成功", ic.categoryID, ic.nextCategoryID);
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
