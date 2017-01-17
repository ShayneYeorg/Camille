//
//  CMLControlHandle.m
//  CamilleTest
//
//  Created by 杨淳引 on 2016/12/19.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "CMLControlHandle.h"

#define DEGREES_TO_RADIANS(x) (0.0174532925 * (x))
#define kTurningSpeed         5

const CGFloat controlHandleHeight                = 50;
const CGFloat controlHandleWidth                 = 90;
const CGFloat controlHandleDefaultBottomInterval = 50;

@implementation CMLControlHandleCircleView {
    CGFloat _currentRadian;
}

#pragma mark - Public

+ (CMLControlHandleCircleView *)loadCircleView {
    CMLControlHandleCircleView *circleView = [[CMLControlHandleCircleView alloc]initWithFrame:CGRectMake(0, 0, controlHandleHeight, controlHandleHeight)];
    circleView.layer.cornerRadius = controlHandleHeight/2;
    circleView.layer.masksToBounds = YES;
    circleView.backgroundColor = kAppColor;
    circleView.isClockwiseAnimating = NO;
    circleView.isAntiClockwiseAnimating = NO;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, circleView.frame.size.width, circleView.frame.size.height)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:22];
    lbl.text = @"记";
    lbl.textColor = [UIColor blackColor];
    [circleView addSubview:lbl];
    
    return circleView;
}

- (void)turnByClockwise {
    if (_isClockwiseAnimating) {
        return;
    }
    
    [self.layer removeAllAnimations];
    _isAntiClockwiseAnimating = NO;
    _isClockwiseAnimating = YES;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    [rotate setToValue:[NSNumber numberWithFloat: M_PI / 2]];
    rotate.repeatCount = HUGE_VALF;
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    rotate.duration = 0.08;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

- (void)turnByAntiClockwise {
    if (_isAntiClockwiseAnimating) {
        return;
    }
    
    [self.layer removeAllAnimations];
    _isClockwiseAnimating = NO;
    _isAntiClockwiseAnimating = YES;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    [rotate setToValue:[NSNumber numberWithFloat: - M_PI / 2]];
    rotate.repeatCount = HUGE_VALF;
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    rotate.duration = 0.08;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

- (void)turnFrom:(CGFloat)lastOffsetY to:(CGFloat)currentOffsetY {
    CGFloat displacement = currentOffsetY - lastOffsetY;
    _currentRadian += DEGREES_TO_RADIANS(displacement) * kTurningSpeed;
    //需要累积
    self.layer.transform = CATransform3DMakeRotation(_currentRadian, 0, 0, 1);
}

- (void)stop {
    _isClockwiseAnimating = NO;
    _isAntiClockwiseAnimating = NO;
    [self.layer removeAllAnimations];
}

- (void)restore {
    _currentRadian = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.layer.transform = CATransform3DMakeRotation(_currentRadian, 0, 0, 1);
    }];
    
}

@end


@interface CMLControlHandle ()

@property (nonatomic, strong) CMLControlHandleCircleView *circleView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, assign) CGFloat superViewWidth;

@end

@implementation CMLControlHandle {
    CGFloat _currentOffsetY;
    BOOL _isManualDragging;
    CGFloat _reserveWidth; //hide的时候保留的宽度
}

#pragma mark - Life Cycle

+ (CMLControlHandle *)loadControlHandleAbove:(UIView *)superView {
    return [self loadControlHandleWithY:(superView.bounds.size.height-controlHandleDefaultBottomInterval-controlHandleHeight) above:superView];
}

+ (CMLControlHandle *)loadControlHandleWithY:(CGFloat)y above:(UIView *)superView {
    CMLControlHandle *controlHandle = [[CMLControlHandle alloc]initWithFrame:CGRectMake(superView.bounds.size.width - controlHandleWidth, y, controlHandleWidth, controlHandleHeight)];
    controlHandle.superViewWidth = superView.bounds.size.width;
    [superView addSubview:controlHandle];
    return controlHandle;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configDetails];
        [self configRightView];
        [self configCircleView];
    }
    return self;
}

#pragma mark - Public

- (void)turnByClockwise {
    [self.circleView turnByClockwise];
}

- (void)turnByAntiClockwise {
    [self.circleView turnByAntiClockwise];
}

- (void)stop {
    [self.circleView stop];
}

- (void)restore {
    [self.circleView restore];
}

- (void)showWithAnimation:(BOOL)animated {
    CGRect currentFrame = self.frame;
    if (animated) {
        if (_moveAnimation) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake(_superViewWidth - controlHandleWidth, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
            }];
            
        } else {
            if (self.alpha != 1) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.alpha = 1;
                }];
            }
        }
        
    } else {
        if (_moveAnimation) {
            self.frame = CGRectMake(_superViewWidth - controlHandleWidth, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
            
        } else {
            self.alpha = 1;
        }
    }
}

- (void)hideWithAnimation:(BOOL)animated {
    CGRect currentFrame = self.frame;
    if (animated) {
        if (_moveAnimation) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = CGRectMake(_superViewWidth - _reserveWidth, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
            }];
            
        } else {
            if (self.alpha != 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.alpha = 0;
                }];
            }
        }
        
    } else {
        if (_moveAnimation) {
            self.frame = CGRectMake(_superViewWidth - _reserveWidth, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
            
        } else {
            self.alpha = 0;
        }
    }
}

- (void)motionAfterScrollViewDidScroll:(UIScrollView *)scrollView {
    _currentOffsetY = scrollView.contentOffset.y;
    
    if (_isManualDragging && _moveAnimation) {
        if (!_slowAnimation) {
            //一步到位快速运动
            if (_currentOffsetY > _lastOffsetY) {
                [self showWithAnimation:YES];
                
            } else {
                [self hideWithAnimation:YES];
            }
            
        } else {
            //随着拖动慢慢运动
            self.frame = CGRectMake(self.frame.origin.x - (_currentOffsetY - _lastOffsetY), self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            
            //校正
            if (self.frame.origin.x < _superViewWidth - controlHandleWidth) {
                [self showWithAnimation:NO];
                
            } else if (self.frame.origin.x > _superViewWidth - _reserveWidth) {
                [self hideWithAnimation:NO];
            }
        }
    }
    
    
    if (_isConstantSpeedTurning) {
        if (_currentOffsetY > _lastOffsetY) {
            [self turnByClockwise];
            
        } else {
            [self turnByAntiClockwise];
        }
        
    } else {
        [self turnFrom:_lastOffsetY to:_currentOffsetY];
    }
    
    _lastOffsetY = scrollView.contentOffset.y;
}

- (void)motionAfterScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isManualDragging = NO;
    
    if (_moveAnimation) {
        if (self.frame.origin.x < _superViewWidth - controlHandleWidth + (controlHandleWidth - _reserveWidth) / 2) {
            [self showWithAnimation:YES];
            
        } else {
            [self hideWithAnimation:YES];
        }
    }
    
    if (_isConstantSpeedTurning) {
        [self stop];
        
    } else {
        if (!decelerate) {
            //            NSLog(@"不动了");
            //scrollView直接停住不动了，要复位self
            [self restore];
            
        } else {
            //            NSLog(@"继续移动");
            //还会继续移动
        }
    }
}

- (void)motionAfterScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isManualDragging = YES;
}


- (void)motionAfterScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_isConstantSpeedTurning) {
        [self stop];
        
    } else {
        //        NSLog(@"停了");
        //scrollView滑动后自动停止了，要复位self
        [self restore];
    }
}

#pragma mark - Setter

- (void)setCompleteHide:(BOOL)completeHide {
    _completeHide = completeHide;
    
    if (_completeHide) {
        _reserveWidth = 0;
        
    } else {
        _reserveWidth = controlHandleHeight + 10;
    }
}

- (void)setRightViewHidden:(BOOL)rightViewHidden {
    _rightViewHidden = rightViewHidden;
    self.rightView.hidden = _rightViewHidden;
}

- (void)setMoveAnimation:(BOOL)moveAnimation {
    _moveAnimation = moveAnimation;
    
    if (!_moveAnimation) {
        self.rightViewHidden = YES;
        self.alpha = 0;
        self.frame = CGRectMake(_superViewWidth - controlHandleHeight - 10, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
}

#pragma mark -Private

- (void)configDetails {
    self.backgroundColor = [UIColor clearColor];
    _moveAnimation = YES;
    _slowAnimation = NO;
    _completeHide = NO;
    _isManualDragging = NO;
    _reserveWidth = controlHandleHeight + 10;
    _rightViewHidden = NO;
    _isConstantSpeedTurning = NO;
}

- (void)configRightView {
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(controlHandleWidth*3/7, controlHandleHeight/6, controlHandleWidth*4/7, controlHandleHeight*2/3)];
    self.rightView.backgroundColor = kAppColor;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.rightView.frame.size.width, self.rightView.frame.size.height)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = @"     一笔";
    lbl.textColor = [UIColor grayColor];
    [self.rightView addSubview:lbl];
    
    [self addSubview:self.rightView];
}

- (void)configCircleView {
    self.circleView = [CMLControlHandleCircleView loadCircleView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapAcition)];
    [self.circleView addGestureRecognizer:tap];
    
    [self addSubview:self.circleView];
}

- (void)tapAcition {
    if (self.clickAction) {
        self.clickAction();
    }
}

- (void)turnFrom:(CGFloat)lastOffsetY to:(CGFloat)currentOffsetY {
    [self.circleView turnFrom:lastOffsetY to:currentOffsetY];
}

@end
