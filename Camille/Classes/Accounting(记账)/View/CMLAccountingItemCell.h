//
//  CMLAccountingItemCell.h
//  Camille
//
//  Created by 杨淳引 on 16/2/23.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#define kCellBackgroundColor  kAppViewColor
#define kNewItemAddingViewTag 201603112147

#import <UIKit/UIKit.h>

@class CMLAccountingItemCell;

@protocol CMLAccountingItemCellDelegate <NSObject>

- (void)accountingItemCellDidTapExpandArea:(CMLAccountingItemCell *)accountingItemCell;
- (void)accountingItemCell:(CMLAccountingItemCell *)accountingItemCell didAddItem:(NSString *)itemName inCaterogy:(NSString *)categoryName;

@end

@interface CMLAccountingItemCell : UITableViewCell

@property (nonatomic, weak) id <CMLAccountingItemCellDelegate> delegate;
@property (nonatomic, copy) NSString *type; //账务类型(收入或支出)

+ (instancetype)loadFromNib;
+ (CGFloat)heightForCellByExpand:(BOOL)isExpand;
- (void)refreshWithCatogoryModels:(NSArray *)categoryModels itemsDic:(NSDictionary *)itemsDic isExpand:(BOOL)isExpand;

@end
