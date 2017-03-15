//
//  ItemNameCollectCell.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/15.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "ItemNameCollectCell.h"

@interface ItemNameCollectCell ()

@property (nonatomic, strong) UILabel *itemNameLabel;

@end

@implementation ItemNameCollectCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setItemName:(NSString *)itemName {
    _itemName = itemName;
    self.itemNameLabel.text = _itemName;
}

- (UILabel *)itemNameLabel {
    if (!_itemNameLabel) {
        _itemNameLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _itemNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_itemNameLabel];
    }
    return _itemNameLabel;
}

@end
