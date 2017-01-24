//
//  Item+CoreDataClass.m
//  Camille
//
//  Created by 杨淳引 on 2017/1/24.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "Item+CoreDataClass.h"

static NSDictionary *itemsDictionary;

@implementation Item

//+ (void)addItem:(NSString *)itemName type:(NSString *)type callBack:(void(^)(CMLResponse *response))callBack {
//    //先判断在categoryID下itemName是否存在
//    //request和entity
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:kManagedObjectContext];
//    [request setEntity:entity];
//    
//    //设置查询条件
//    NSString *str = [NSString stringWithFormat:@"itemName == '%@' AND itemType == '%@'", itemName, type];
//    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
//    [request setPredicate:pre];
//    
//    //Response
//    CMLResponse *cmlResponse = [[CMLResponse alloc]init];
//    
//    //查询
//    NSError *error = nil;
//    NSMutableArray *items = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
//    if (items == nil) {
//        //查询过程中出错
//        CMLLog(@"保存item出错:%@,%@",error,[error userInfo]);
//        cmlResponse.code = RESPONSE_CODE_FAILD;
//        cmlResponse.desc = kTipFetchFail;
//        cmlResponse.responseDic = nil;
//        callBack(cmlResponse);
//        
//    } else if (items.count) {
//        //查询发现item已存在
//        CMLItem *theExistItem = items[0];
//        
//        //itemName存在则直接返回对应itemID
//        cmlResponse.responseDic = [NSDictionary dictionaryWithObjectsAndKeys:theExistItem.itemID, @"itemID", theExistItem, @"item",  nil];
//        
//        if ([theExistItem.isAvailable isEqualToString:Record_Available]) {
//            cmlResponse.code = RESPONSE_CODE_FAILD;
//            cmlResponse.desc = @"科目已存在";
//            callBack(cmlResponse);
//            
//        } else {
//            [CMLCoreDataAccess alterItem:theExistItem intoItemName:nil category:nil isAvailable:Record_Available callBack:^(CMLResponse *response) {
//                [CMLCoreDataAccess setLastItemNextID:theExistItem.itemID inCategory:categoryID type:type];
//                [CMLCoreDataAccess setItem:theExistItem nextItemID:nil];
//                cmlResponse.code = RESPONSE_CODE_SUCCEED;
//                cmlResponse.desc = @"科目已复原";
//                callBack(cmlResponse);
//            }];
//        }
//        
//    } else {
//        //item不存在
//        [CMLCoreDataAccess addItem:itemName categoryID:categoryID type:type callBack:callBack];
//    }
//}

@end
