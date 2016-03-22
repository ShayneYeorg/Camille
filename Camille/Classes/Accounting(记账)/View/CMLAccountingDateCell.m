//
//  CMLAccountingDateCell.m
//  Camille
//
//  Created by 杨淳引 on 16/3/13.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLAccountingDateCell.h"
#import "CMLTool+NSDate.h"

@interface CMLAccountingDateCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CMLAccountingDateCell

#pragma mark - Public

+ (instancetype)loadFromNib {
    CMLAccountingDateCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CMLAccountingDateCell" owner:self options:nil][0];
    return cell;
}

- (void)refreshDateLabelWithDate:(NSDate *)date {
    NSString *dateStr = [CMLTool transDateToString:date];
    self.dateLabel.text = dateStr;
}

@end
