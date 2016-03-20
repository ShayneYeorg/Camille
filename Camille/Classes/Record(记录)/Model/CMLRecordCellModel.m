//
//  CMLRecordCellModel.m
//  Camille
//
//  Created by 杨淳引 on 16/3/20.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLRecordCellModel.h"

@implementation CMLRecordCellModel

#pragma mark - Public

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title {
    if (self = [super init]) {
        self.icon = icon;
        self.title = title;
    }
    return self;
}

@end
