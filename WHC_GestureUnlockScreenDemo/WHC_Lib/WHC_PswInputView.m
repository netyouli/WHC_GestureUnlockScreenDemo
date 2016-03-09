//
//  WHC_PswInputView.m
//  WHC_GestureUnlockScreenDemo
//
//  Created by 吴海超 on 15/6/18.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*
 *  qq:712641411
 *  iOSqq群:302157745
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import "WHC_PswInputView.h"
#import "WHC_CircleView.h"
#import "UIView+WHC_ViewProperty.h"
#import <AudioToolbox/AudioToolbox.h>
#define  KWHC_CircleRadius      (5.0)                   //圈半径
#define  KWHC_CircleNumber      (4)                     //密码位数
#define  KWHC_CircleMargin      (10.0)                  //密码数字间距
#define  KWHC_CircleScaleAnimationDuring    (0.15)      //圈缩放动画周期
#define  KWHC_CircleDrawAnimationDuring     (1.0)       //圈的绘制动画周期
#define  KWHC_LineWidth          (2.0)                  //线宽
@interface WHC_PswInputView (){
    NSInteger              _currentIndex;               //当前密码圈下标
    UIImage              * _circleImage;                //圈图片
    CGFloat                _circleSumWidth;             //所有圈占的总宽度
    CGFloat                _oneCircleX;                 //第一个圈x坐标
    NSMutableArray       * _circleImageVArr;            //圈视图数组
}

@end

@implementation WHC_PswInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundImage];
        _circleImage = [self makeCircleImage];
        _circleImageVArr = [NSMutableArray new];
    }
    return self;
}

- (void)setBackgroundImage{
    CAGradientLayer   *   gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)KWHC_StartColor,(id)KWHC_EndColor];
    gradientLayer.locations = @[@(0.0),@(1.0)];
    
    CAShapeLayer      * subLayer = [CAShapeLayer layer];
    subLayer.backgroundColor = [UIColor clearColor].CGColor;
    subLayer.frame = self.bounds;
    subLayer.lineWidth = KWHC_LineWidth;
    subLayer.strokeColor = [UIColor magentaColor].CGColor;
    subLayer.fillColor = [UIColor clearColor].CGColor;
    CGMutablePathRef  mutablePath = CGPathCreateMutable();
    _circleSumWidth = KWHC_CircleNumber * KWHC_CircleRadius * 2.0 + (KWHC_CircleNumber - 1) * KWHC_CircleMargin;
    _oneCircleX = (self.width - _circleSumWidth) / 2.0;
    for (NSInteger i = 0; i < KWHC_CircleNumber; i++) {
        CGFloat  x = _oneCircleX + KWHC_CircleRadius * (i + 1) + i * (KWHC_CircleMargin + KWHC_CircleRadius);
        CGPathMoveToPoint(mutablePath, NULL, x + KWHC_CircleRadius, self.height / 2.0);
        CGPathAddArc(mutablePath, NULL, x, self.height / 2.0, KWHC_CircleRadius, 0.0, M_PI * 2.0, NO);
    }
    subLayer.path = mutablePath;
    
    CABasicAnimation  * ba = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ba.fromValue = @(0.0);
    ba.toValue = @(1.0);
    ba.duration = KWHC_CircleDrawAnimationDuring;
    ba.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [subLayer addAnimation:ba forKey:@"CircleDrawAnimation"];
    
    gradientLayer.mask = subLayer;
    [self.layer addSublayer:gradientLayer];
    CGPathRelease(mutablePath);
    
}

- (UIImage *)makeCircleImage{
    UIImage  * circleImage= nil;
    UIGraphicsBeginImageContext(CGSizeMake(KWHC_CircleRadius * 2.0, KWHC_CircleRadius * 2.0));
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef  startColor = CGColorCreateCopy(KWHC_StartColor);
    CGColorRef  endColor = CGColorCreateCopy(KWHC_EndColor);
    CFArrayRef  colors = CFArrayCreate(kCFAllocatorDefault, (const void *[]){startColor,endColor}, 2, NULL);
    CGFloat const  locations[] = {0.0,1.0};
    CGGradientRef  gradientRef = CGGradientCreateWithColors(colorSpaceRef, colors, locations);
    CGContextAddArc(context, KWHC_CircleRadius, KWHC_CircleRadius, KWHC_CircleRadius, 0.0, M_PI * 2.0, NO);
    CGContextClip(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextDrawLinearGradient(context, gradientRef, CGPointZero, CGPointMake(self.width, self.height), kCGGradientDrawsBeforeStartLocation);
    
    CFRelease(colors);
    CGColorSpaceRelease(colorSpaceRef);
    CGColorRelease(endColor);
    CGColorRelease(startColor);
    CGGradientRelease(gradientRef);
    
    circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}

- (void)addPswCircleFinish:(void(^)())didFinish{
    if(_currentIndex < KWHC_CircleNumber){
        if(_circleImage == nil){
            _circleImage = [self makeCircleImage];
        }
        CGFloat  x = _oneCircleX + KWHC_CircleRadius * (_currentIndex + 1) + _currentIndex * (KWHC_CircleMargin + KWHC_CircleRadius);
        UIImageView  * circleImageView = [[UIImageView alloc]initWithImage:_circleImage];
        circleImageView.size = CGSizeMake(KWHC_CircleRadius * 2.0, KWHC_CircleRadius * 2.0);
        circleImageView.center = CGPointMake(x, self.height / 2.0);
        _currentIndex++;
        circleImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        circleImageView.tag = _currentIndex;
        [_circleImageVArr addObject:circleImageView];
        [self addSubview:circleImageView];
        [UIView animateWithDuration:KWHC_CircleScaleAnimationDuring delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            circleImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if(didFinish){
                didFinish();
            }
        }];
    }
}

- (void)clearAllPswCircle{
    _currentIndex = 0;
    [UIView animateWithDuration:KWHC_CircleScaleAnimationDuring delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        for (UIImageView * circelView in _circleImageVArr) {
            circelView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        }
    } completion:^(BOOL finished) {
        for (UIImageView * circelView in _circleImageVArr) {
            [circelView removeFromSuperview];
        }
        [_circleImageVArr removeAllObjects];
    }];
    
}

- (void)clearPswCircle{
    UIImageView  * circleView = [_circleImageVArr lastObject];
    _currentIndex--;
    if(_currentIndex < 0){
        _currentIndex = 0;
        for (UIView * subView in self.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                circleView = (UIImageView *)subView;
            }
        }
    }
    
    if (circleView) {
        [UIView animateWithDuration:KWHC_CircleScaleAnimationDuring delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            circleView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            [circleView removeFromSuperview];
            [_circleImageVArr removeLastObject];
        }];
    }
}

- (void)showMistakeMsg{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    CABasicAnimation  * ba = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    ba.delegate = self;
    ba.duration = KWHC_CircleScaleAnimationDuring / 2.0;
    ba.fromValue = @(-20.0);
    ba.toValue = @(20.0);
    ba.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ba.repeatCount = 4.0;
    ba.autoreverses = YES;
    [self.layer addAnimation:ba forKey:@"CABasicAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self clearAllPswCircle];
}
@end
