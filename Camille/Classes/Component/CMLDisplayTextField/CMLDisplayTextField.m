//
//  CMLDisplayTextField.m
//  Camille
//
//  Created by 杨淳引 on 2017/3/15.
//  Copyright © 2017年 shayneyeorg. All rights reserved.
//

#import "CMLDisplayTextField.h"

@interface CMLDisplayTextField ()

@property (nonatomic, copy) VoidBlock touchAction;
@property (nonatomic, strong) UILabel *placeHolder;
@property (nonatomic, strong) UILabel *text;

@end

@implementation CMLDisplayTextField

+ (instancetype)loadDisplayTextFieldWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor placeHolder:(NSString *)placeHolder touchAction:(VoidBlock)touchAction {
    CMLDisplayTextField *displayTextField = [[CMLDisplayTextField alloc]initWithFrame:frame];
    displayTextField.backgroundColor = backgroundColor;
    displayTextField.layer.cornerRadius = 5;
    displayTextField.clipsToBounds = YES;
    displayTextField.touchAction = touchAction;
    
    displayTextField.placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, displayTextField.width - 20, displayTextField.height)];
    displayTextField.placeHolder.text = placeHolder;
    displayTextField.placeHolder.textColor = RGB(180, 180, 180);
    [displayTextField addSubview:displayTextField.placeHolder];
    displayTextField.placeHolder.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    displayTextField.text = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, displayTextField.width - 20, displayTextField.height)];
    displayTextField.text.text = @"";
    [displayTextField addSubview:displayTextField.text];
    displayTextField.text.hidden = YES;
    displayTextField.text.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:displayTextField action:@selector(touch)];
    [displayTextField addGestureRecognizer:tap];
    
    return displayTextField;
}


- (void)refreshWithText:(NSString *)text {
    if (text && text.length) {
        self.placeHolder.hidden = YES;
        self.text.text = text;
        self.text.hidden = NO;
        
    } else {
        self.placeHolder.hidden = NO;
        self.text.text = @"";
        self.text.hidden = YES;
    }
}

- (NSString *)currentText {
    return self.text.text;
}

- (void)touch {
    if (self.touchAction) {
        self.touchAction();
    }
}

@end
