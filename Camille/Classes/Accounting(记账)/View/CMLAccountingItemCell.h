//
//  CMLAccountingItemCell.h
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#define kCellBackgroundColor  kAppViewColor
#define kNewItemAddingViewTag 2016031182

#import <UIKit/UIKit.h>

@class CMLAccountingItemCell;

@protocol CMLAccountingItemCellDelegate <NSObject>

- (void)accountingItemCellDidTapExpandArea:(CMLAccountingItemCell *)accountingItemCell;
- (void)accountingItemCell:(CMLAccountingItemCell *)accountingItemCell shouldSelectItem:(CMLItem *)item;
- (void)accountingItemCell:(CMLAccountingItemCell *)accountingItemCell didSelectItem:(CMLItem *)item;
- (void)accountingItemCell:(CMLAccountingItemCell *)accountingItemCell didAddItem:(NSString *)itemName inCaterogy:(NSString *)categoryID;
- (void)accountingItemCell:(CMLAccountingItemCell *)accountingItemCell didAddCaterogy:(NSString *)categoryName;

@end

@interface CMLAccountingItemCell : UITableViewCell

@property (nonatomic, weak) id <CMLAccountingItemCellDelegate> delegate;
@property (nonatomic, copy) NSString *type; //账务类型(收入或支出)

+ (instancetype)loadFromNib;
+ (CGFloat)heightForCellByExpand:(BOOL)isExpand;
- (void)refreshWithCatogoryModels:(NSArray *)categoryModels itemsDic:(NSDictionary *)itemsDic isExpand:(BOOL)isExpand selectedItem:(CMLItem *)item isAfterAddingCategory:(BOOL)isAfterAddingCategory;
- (void)refreshTopViewText:(NSString *)itemName;

@end
