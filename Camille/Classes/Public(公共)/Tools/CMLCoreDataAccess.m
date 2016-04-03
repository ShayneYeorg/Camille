//
//  CMLCoreDataAccess.m
//  Camille
//
//  Created by 杨淳引 on 16/2/28.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLCoreDataAccess.h"
#import "CMLTool+NSDate.h"

@implementation CMLCoreDataAccess

#pragma mark - 初始化检查

+ (void)checkInitialItem:(NSString *)type {
    //不新开线程了
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItem" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"categoryID == '1' AND itemName == '新增' AND itemType == '%@'", type];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    //查询
    NSError *error = nil;
    NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (items == nil) {
        //查询过程中出错
        CMLLog(@"错误:%@,%@",error,[error userInfo]);
        
    } else if (!items.count) {
        //itemName不存在则新建并返回对应itemID
        [CMLCoreDataAccess addItem:@"新增" inCategory:@"未分类" type:type callBack:^(CMLResponse *response) {}];
    }
}

#pragma mark - 查询所有一级记账科目（排序）

//取出所有一级记账科目(并排序)
+ (void)fetchAllItemCategories:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //异步取数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Response
        CMLResponse *cmlResponse = [[CMLResponse alloc]init];
        
        //设置查询条件
        NSString *str = [NSString stringWithFormat:@"categoryType == '%@'", type];
        NSPredicate *pre = [NSPredicate predicateWithFormat:str];
        [request setPredicate:pre];
        
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
            cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:[CMLItemCategory sortItemCategories:itemCategories], @"categories", nil];
        }
        
        //回调
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(cmlResponse);
        });
    });
}

#pragma mark - 查询所有二级记账科目（分组排序）

//取出所有二级记账科目(并排序)
+ (void)fetchAllItems:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItem" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //异步取数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CMLLog(@"开始取出所有记账科目...");
        //Response
        CMLResponse *cmlResponse = [[CMLResponse alloc]init];
        
        //设置查询条件
        NSString *str = [NSString stringWithFormat:@"itemType == '%@'", type];
        NSPredicate *pre = [NSPredicate predicateWithFormat:str];
        [request setPredicate:pre];
        
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
            CMLLog(@"已取出所有记账科目...");
            cmlResponse.code = RESPONSE_CODE_SUCCEED;
            cmlResponse.desc = @"读取成功";
            cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:[CMLItem sortItems:items], @"items", nil];
        }
        
        //回调
        dispatch_async(dispatch_get_main_queue(), ^{
            CMLLog(@"返回所有记账科目...");
            callBack(cmlResponse);
        });
    });
}

#pragma mark - 新增完整记账科目相关方法

//新增完整记账科目
+ (void)addItem:(NSString *)itemName inCategory:(NSString *)categoryName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
    //根据categoryName获得categoryID
    NSString *categoryID = [CMLCoreDataAccess getCategoryIDByCategoryName:categoryName type:type];
    
    if (categoryID) {
        //在相应categoryID下保存itemName
        [CMLCoreDataAccess saveItem:itemName inCategory:categoryID type:type callBack:callBack];
        
    } else {
        callBack(nil);
    }
}

//根据categoryName获得categoryID
+ (NSString *)getCategoryIDByCategoryName:(NSString *)categoryName type:(NSString *)type {
    //判断categoryName是否存在
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"categoryName == '%@' AND categoryType == '%@'", categoryName, type];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    //查询
    NSError *error = nil;
    NSMutableArray *itemCategoris = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (itemCategoris == nil) {
        //查询过程中出错
        CMLLog(@"查询categoryName是否存在时发生错误:%@,%@",error,[error userInfo]);
        return nil;
        
    } else if (itemCategoris.count) {
        //categoryName存在则直接返回对应categoryID
        CMLItemCategory *ic = itemCategoris[0];
        return ic.categoryID;
        
    } else {
        //categoryName不存在则新建并返回对应categoryID
        __block NSString *returnStr = nil;
        [CMLCoreDataAccess addItemCategory:categoryName type:type callBack:^(CMLResponse *response) {
            if ([response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
                returnStr = response.responseDic[@"itemCategoryID"];
                CMLLog(@"returnStr赋值");
            }
        }];
        CMLLog(@"returnStr返回");
        return returnStr;
    }
}

//在相应categoryID下保存itemName
+ (void)saveItem:(NSString *)itemName inCategory:(NSString *)categoryID type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
    //判断在categoryID下itemName是否存在
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItem" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"categoryID == '%@' AND itemName == '%@' AND itemType == '%@'", categoryID, itemName, type];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    //Response
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
    cmlResponse.code = RESPONSE_CODE_FAILD;
    cmlResponse.desc = @"在相应categoryID下保存itemName出错";
    cmlResponse.responseDic = nil;
    
    //查询
    NSError *error = nil;
    NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (items == nil) {
        //查询过程中出错
        CMLLog(@"错误:%@,%@",error,[error userInfo]);
        callBack(cmlResponse);
        
    } else if (items.count) {
        //itemName存在则直接返回对应itemID
        cmlResponse.code = RESPONSE_CODE_FAILD;
        cmlResponse.desc = @"科目已存在";
        cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:((CMLItem *)items[0]).itemID, @"itemID", nil];
        callBack(cmlResponse);
        
    } else {
        //itemName不存在则新建并返回对应itemID
        [CMLCoreDataAccess addItem:itemName categoryID:categoryID type:type callBack:callBack];
    }
}

#pragma mark - 新增二级记账科目相关方法

//新增二级记账科目(sync)
//确保有categoryID了再调用此方法
+ (void)addItem:(NSString *)itemName categoryID:(NSString *)categoryID type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
    CMLLog(@"新增二级记账科目所在的线程是：%@", [NSThread currentThread]);
    
    //Response
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
    
    //分配新ID
    NSString *newID = [CMLCoreDataAccess getANewItemIDInCategory:categoryID type:type];
    if (newID == nil) {
        cmlResponse.code = RESPONSE_CODE_FAILD;
        cmlResponse.desc = @"分配新的二级科目ID出错";
        cmlResponse.responseDic = nil;
        
    } else {
        //Entity
        CMLItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"CMLItem" inManagedObjectContext:kManagedObjectContext];
        item.itemName = itemName;
        item.itemID = newID;
        item.itemType = type;
        item.categoryID = categoryID;
        item.nextItemID = nil;
        
        //保存
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) {
            if (error) {
                CMLLog(@"新增二级科目时发生错误:%@,%@",error,[error userInfo]);
                cmlResponse.code = RESPONSE_CODE_FAILD;
                cmlResponse.desc = @"保存二级科目出错";
                cmlResponse.responseDic = nil;
                
            } else {
                //将对应二级科目链表最后一个科目的nextItemID置为newID
                if ([CMLCoreDataAccess setLastItemNextID:newID inCategory:categoryID type:type]) {
                    cmlResponse.code = RESPONSE_CODE_SUCCEED;
                    cmlResponse.desc = @"新增科目成功";
                    CMLLog(@"%@", cmlResponse.desc);
                    cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:newID, @"itemID", nil];
                    
                } else {
                    CMLLog(@"将二级科目链表最后一个科目的nextItemID置为newID时发生错误:%@,%@",error,[error userInfo]);
                    cmlResponse.code = RESPONSE_CODE_FAILD;
                    cmlResponse.desc = @"保存二级科目出错";
                    cmlResponse.responseDic = nil;
                }
            }
        }
    }
    
    //回调
    callBack(cmlResponse);
}

+ (NSString *)getANewItemIDInCategory:(NSString *)categoryID type:(NSString *)type{
    //先获取最大ID，再加1
    CMLLog(@"新分配一个二级记账科目的ID所在的线程是：%@", [NSThread currentThread]);
    
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItem" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置排序规则
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"itemID" ascending:NO  selector:@selector(localizedStandardCompare:)];//像Mac Finder中的排序方式一般
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"categoryID == '%@' AND itemType == '%@'", categoryID, type];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    //设置数据条数
    [request setFetchLimit:1];
    [request setFetchOffset:0];
    
    //查询
    NSError *error = nil;
    NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (items == nil) {
        //查询过程中出错
        CMLLog(@"查询二级科目最大ID时发生错误:%@,%@",error,[error userInfo]);
        return nil;
        
    } else if (items.count) {
        //正常
        CMLItem *ic = items[0];
        NSInteger newID = ic.itemID.integerValue + 1;
        CMLLog(@"新分配的二级科目ID是：%zd", newID);
        return [NSString stringWithFormat:@"%zd", newID];
        
    } else {
        //还没有任何二级科目
        //建立二级科目链表头
        if ([CMLCoreDataAccess createItemListHeadInCategory:categoryID type:type]) {
            //成功则返回当前分类第一个二级科目ID
            return @"1";
            
        } else {
            //建立链表头失败
            return nil;
        }
    }
}

//建立二级科目链表头
+ (BOOL)createItemListHeadInCategory:(NSString *)categoryID type:(NSString *)type {
    CMLLog(@"开始为一级科目(%@)建立二级科目链表头...", categoryID);
    //Entity
    CMLItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"CMLItem" inManagedObjectContext:kManagedObjectContext];
#warning 要禁止记账科目使用这个名称
    item.itemName = @"ITEM_LIST_HEAD"; //在APP里成关键字，要禁止记账科目使用这个名称
    item.itemID = @"0";
    item.itemType = type;
    item.categoryID = categoryID;
    item.nextItemID = nil;
    
    //保存
    NSError *error = nil;
    if ([kManagedObjectContext save:&error]) {
        if (error) {
            CMLLog(@"为一级科目(%@)建立二级科目链表头失败...", categoryID);
            CMLLog(@"错误:%@,%@",error,[error userInfo]);
            return NO;
            
        } else {
            CMLLog(@"为一级科目(%@)建立二级科目链表头成功...", categoryID);
            return YES;
        }
    }
    CMLLog(@"为一级科目(%@)建立二级科目链表头失败...", categoryID);
    return NO;
}

+ (BOOL)setLastItemNextID:(NSString *)nextID inCategory:(NSString *)categoryID type:(NSString *)type {
    //先获取链表最后一个科目，再修改它的nextItemID
    CMLLog(@"获取二级链表最后一个科目所在的线程是：%@", [NSThread currentThread]);
    
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItem" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置排序规则
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"itemID" ascending:YES  selector:@selector(localizedStandardCompare:)];//像Mac Finder中的排序方式一般
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"categoryID == '%@' AND itemType = '%@' AND nextItemID == NULL", categoryID, type];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    //设置数据条数
    [request setFetchLimit:1];
    [request setFetchOffset:0];
    
    //查询
    NSError *error = nil;
    NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (items == nil) {
        //查询过程中出错
        CMLLog(@"查询二级科目链表最后一个科目时发生错误:%@,%@",error,[error userInfo]);
        return NO;
        
    } else if (items.count) {
        //正常
        CMLItem *ic = items[0];
        ic.nextItemID = nextID;
        
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) {
            CMLLog(@"修改最后一个二级科目(%@)的nextCategoryID(%@)成功", ic.itemID, ic.nextItemID);
            return YES;
        }
    }
    return NO;
}

#pragma mark - 新增一级记账科目相关方法

//新增一级记账科目(sync)
+ (void)addItemCategory:(NSString *)itemCategoryName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
    CMLLog(@"开始建立一级科目...");
    
    //Response
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
    
    //分配新ID
    NSString *newID = [CMLCoreDataAccess getANewItemCategoryID:type];
    if (newID == nil) {
        cmlResponse.code = RESPONSE_CODE_FAILD;
        cmlResponse.desc = @"分配新的一级科目ID出错";
        cmlResponse.responseDic = nil;
        
    } else {
        //Entity
        CMLItemCategory *itemCategory = [NSEntityDescription insertNewObjectForEntityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
        itemCategory.categoryName = itemCategoryName;
        itemCategory.categoryID = newID;
        itemCategory.categoryType = type;
        itemCategory.nextCategoryID = nil;
        
        //保存
        CMLLog(@"开始保存新建立的一级科目...");
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) {
            if (error) {
                CMLLog(@"保存新建立的一级科目失败...");
                CMLLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
                cmlResponse.code = RESPONSE_CODE_FAILD;
                cmlResponse.desc = @"保存一级科目出错";
                cmlResponse.responseDic = nil;
                
            } else {
                //将一级科目链表最后一个科目的nextCategoryID置为newID
                //为新建立的一级科目建立一个二级科目链表头
                if ([CMLCoreDataAccess setLastItemCategoryNextID:newID type:type] && [CMLCoreDataAccess createItemListHeadInCategory:newID type:type]) {
                    CMLLog(@"保存一级科目成功...");
                    cmlResponse.code = RESPONSE_CODE_SUCCEED;
                    cmlResponse.desc = [NSString stringWithFormat:@"保存一级科目成功:%@ %@",newID, itemCategoryName];
                    cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:newID, @"itemCategoryID", nil];
                    
                } else {
                    CMLLog(@"保存一级科目失败...");
                    CMLLog(@"错误:%@,%@",error,[error userInfo]);
                    cmlResponse.code = RESPONSE_CODE_FAILD;
                    cmlResponse.desc = @"保存一级科目出错";
                    cmlResponse.responseDic = nil;
                }
            }
        }
    }
    
    //回调
    CMLLog(@"建立一级科目成功...");
    callBack(cmlResponse);
}

//新分配一个一级记账科目的ID
+ (NSString *)getANewItemCategoryID:(NSString *)type {
    //先获取最大ID，再加1
    CMLLog(@"开始为一级科目分配新ID...");
    
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置排序规则
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:NO  selector:@selector(localizedStandardCompare:)];//像Mac finder中的排序方式一般
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"categoryType == '%@'", type];
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
        CMLLog(@"查询一级科目最大ID时发生错误:%@,%@",error,[error userInfo]);
        return nil;
        
    } else if (itemCategories.count) {
        //正常
        CMLItemCategory *ic = itemCategories[0];
        NSInteger newID = ic.categoryID.integerValue + 1;
        CMLLog(@"为一级科目分配新ID成功...");
        CMLLog(@"新分配的ID是：%zd", newID);
        return [NSString stringWithFormat:@"%zd", newID];
        
    } else {
        //还没有任何一级科目
        //建立一级科目链表头
        CMLLog(@"还没有任何一级科目，需要先建立一级科目链表头...");
        if ([CMLCoreDataAccess createItemCategoryListHead:type]) {
            //成功则返回第一个一级科目ID
            CMLLog(@"为一级科目分配新ID成功...");
            return @"1";
            
        } else {
            //建立链表头失败
            CMLLog(@"为一级科目分配新ID失败...");
            return nil;
        }
    }
}

//建立一级科目链表头
+ (BOOL)createItemCategoryListHead:(NSString *)type {
    CMLLog(@"开始建立一级科目链表头...");
    //Entity
    CMLItemCategory *itemCategory = [NSEntityDescription insertNewObjectForEntityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
#warning 要禁止记账科目使用这个名称
    itemCategory.categoryName = @"CATEGORY_LIST_HEAD"; //在APP里成关键字，要禁止记账科目使用这个名称
    itemCategory.categoryID = @"0";
    itemCategory.categoryType = type;
    itemCategory.nextCategoryID = nil;
    
    //保存
    NSError *error = nil;
    if ([kManagedObjectContext save:&error]) {
        if (error) {
            CMLLog(@"建立一级科目链表头失败...");
            CMLLog(@"错误:%@,%@",error,[error userInfo]);
            return NO;
            
        } else {
            CMLLog(@"建立一级科目链表头成功...");
            return YES;
        }
    }
    CMLLog(@"建立一级科目链表头失败...");
    return NO;
}

//将一级科目链表最后一个科目的nextCategoryID置为newID
+ (BOOL)setLastItemCategoryNextID:(NSString *)nextID type:(NSString *)type {
    //先获取链表最后一个科目，再修改它的nextCategoryID
    CMLLog(@"开始将一级科目链表最后一个科目的nextCategoryID置为newID...");
    
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLItemCategory" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置排序规则
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES  selector:@selector(localizedStandardCompare:)];//像Mac Finder中的排序方式一般
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"categoryType == '%@' AND nextCategoryID == NULL", type];
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
        CMLLog(@"将一级科目链表最后一个科目的nextCategoryID置为newID失败...");
        CMLLog(@"错误:%@,%@",error,[error userInfo]);
        return NO;
        
    } else if (itemCategories.count) {
        //正常
        CMLItemCategory *ic = itemCategories[0];
        ic.nextCategoryID = nextID;
        
        NSError *error = nil;
        if ([kManagedObjectContext save:&error]) {
            CMLLog(@"将一级科目链表最后一个科目的nextCategoryID置为newID成功...");
            CMLLog(@"将最后一个科目(%@)的nextCategoryID设置为了(%@)", ic.categoryID, ic.nextCategoryID);
            return YES;
        }
    }
    return NO;
}

#pragma mark - 新增账务记录

//新增账务记录
+ (void)addAccountingWithItem:(NSString *)itemID amount:(NSNumber *)amount type:(NSString *)type happneTime:(NSDate *)happenTime callBack:(void(^)(CMLResponse *response))callBack {
    //Entity
    CMLAccounting *accounting = [NSEntityDescription insertNewObjectForEntityForName:@"CMLAccounting" inManagedObjectContext:kManagedObjectContext];
    accounting.itemID = itemID;
    accounting.amount = amount;
    accounting.type = type;
    accounting.happenTime = happenTime;
    accounting.createTime = [NSDate date];
    
    //异步保存数据
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Response
    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
        
        //保存
        NSError *error = nil;
    if ([kManagedObjectContext save:&error]) {
        cmlResponse.code = RESPONSE_CODE_SUCCEED;
        cmlResponse.desc = @"保存成功";
        cmlResponse.responseDic = nil;
        
    } else {
        CMLLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
        cmlResponse.code = RESPONSE_CODE_FAILD;
        cmlResponse.desc = @"保存失败";
        cmlResponse.responseDic = nil;
    }
    
        //回调
//        dispatch_async(dispatch_get_main_queue(), ^{
    callBack(cmlResponse);
//        });
//    });
}

#pragma mark - 查询账务记录

+ (void)fetchAccountingDetailsOnMonth:(NSDate *)date callBack:(void(^)(CMLResponse *response))callBack {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMLAccounting" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //异步取数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Response
        CMLResponse *cmlResponse = [[CMLResponse alloc]init];
        
        //设置查询条件
        NSDate *beginDate = [CMLTool getFirstDateInMonth:date];
        NSDate *endDate = [CMLTool getLastDateInMonth:date];
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"happenTime >= %@ AND happenTime < %@", beginDate, endDate];
        [request setPredicate:pre];
        
        //查询
        NSError *error = nil;
        NSArray *accountings = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        //返回数据
        if (accountings == nil) {
            CMLLog(@"查询账务时发生错误:%@,%@",error,[error userInfo]);
            cmlResponse.code = RESPONSE_CODE_FAILD;
            cmlResponse.desc = @"读取失败";
            cmlResponse.responseDic = nil;
            
        } else {
            cmlResponse.code = RESPONSE_CODE_SUCCEED;
            cmlResponse.desc = @"读取成功";
            cmlResponse.responseDic = [CMLAccounting sortAccountingsByDay:accountings];
        }
        
        
//        cmlResponse.code = RESPONSE_CODE_SUCCEED;
//        cmlResponse.desc = @"读取成功";
//        cmlResponse.responseDic = @{
//                                    @"totalCost": @"360",
//                                    @"totalIncome": @"2000",
//                                    @"detailSections": @[
//                                            @{
//                                                @"day": @"1",
//                                                @"income": @"0",
//                                                @"cost": @"200",
//                                                @"detailCells": @[
//                                                        @{
//                                                            @"itemName":@"鞋子",
//                                                            @"itemType":@"1",
//                                                            @"amount":@"150"
//                                                            },
//                                                        @{
//                                                            @"itemName":@"买菜",
//                                                            @"itemType":@"1",
//                                                            @"amount":@"50"
//                                                            }
//                                                        ]
//                                                },
//                                            @{
//                                                @"day": @"2",
//                                                @"income": @"2000",
//                                                @"cost": @"10",
//                                                @"detailCells": @[
//                                                        @{
//                                                            @"itemName":@"工资",
//                                                            @"itemType":@"2",
//                                                            @"amount":@"2000"
//                                                            },
//                                                        @{
//                                                            @"itemName":@"买菜",
//                                                            @"itemType":@"1",
//                                                            @"amount":@"10"
//                                                            }
//                                                        ]
//                                                },
//                                            @{
//                                                @"day": @"3",
//                                                @"income": @"50",
//                                                @"cost": @"150",
//                                                @"detailCells": @[
//                                                        @{
//                                                            @"itemName":@"公交卡",
//                                                            @"itemType":@"1",
//                                                            @"amount":@"100"
//                                                            },
//                                                        @{
//                                                            @"itemName":@"报销",
//                                                            @"itemType":@"2",
//                                                            @"amount":@"50"
//                                                            },
//                                                        @{
//                                                            @"itemName":@"买菜",
//                                                            @"itemType":@"1",
//                                                            @"amount":@"50"
//                                                            }
//                                                        ]
//                                                }
//                                            ]
//                                    };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(cmlResponse);
        });
    });
}

@end
