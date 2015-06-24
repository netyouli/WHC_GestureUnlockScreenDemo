//
//  WHC_CircleView.m
//  WHC_GestureUnlockScreenDemo
//
//  Created by 吴海超 on 15/6/18.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*
 *  qq:712641411
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import "WHC_CircleView.h"
#define KWHC_DrawCircleAnimationDuring            (1.0)           //花圈动画周期
#define KWHC_FontSize                             (30.0)          //字体大小
#define KWHC_BtnSubLayerDismissDuring             (0.1)           //按钮渐变层消失动画

@interface WHC_CircleView (){
    UIButton                            * _numBtn;                //数字按钮
    CAGradientLayer                     * _btnSubLayer;           //按钮背景层
}

@end

@implementation WHC_CircleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

- (void)setBackground{
    CAGradientLayer  * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)KWHC_StartColor,(id)KWHC_EndColor];
    gradientLayer.locations = @[@(0.0),@(1.0)];
    
    CAShapeLayer  * subLayer = [CAShapeLayer layer];
    subLayer.backgroundColor = [UIColor clearColor].CGColor;
    subLayer.frame = self.bounds;
    [gradientLayer setMask:subLayer];
    [self.layer addSublayer:gradientLayer];
    
    CGMutablePathRef  path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, subLayer.frame.size.width / 2.0, subLayer.frame.size.height / 2.0, self.width / 2.0 - 1.0, 0.0, M_PI * 2.0, NO);
    subLayer.lineWidth = 2.0;
    subLayer.strokeColor = [UIColor redColor].CGColor;
    subLayer.fillColor = [UIColor clearColor].CGColor;
    subLayer.path = path;
    CABasicAnimation  * ba = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ba.duration = KWHC_DrawCircleAnimationDuring;
    ba.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    ba.fromValue = @(0.0);
    ba.toValue = @(1.0);
    [subLayer addAnimation:ba forKey:@"AnimationDrawCircle"];
    CGPathRelease(path);
}

- (void)setCircleType:(WHCGestureUnlockType)circleType{
    _circleType = circleType;
    [self setBackground];
    _numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _numBtn.frame = self.bounds;
    _numBtn.layer.cornerRadius = self.width / 2.0;
    _numBtn.layer.masksToBounds = YES;
    _numBtn.backgroundColor = [UIColor clearColor];
    _numBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KWHC_FontSize];
    [_numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if(_circleType == ClickNumberType){
        [_numBtn addTarget:self action:@selector(clickUpNumBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_numBtn addTarget:self action:@selector(clickDownNumBtn:) forControlEvents:UIControlEventTouchDown];
    }else if (_circleType == GestureDragType){
        _numBtn.xy = CGPointMake((self.width - KWHC_SolidCircleRaduis * 2.0) / 2.0, (self.height - KWHC_SolidCircleRaduis * 2.0) / 2.0);
        _numBtn.size = CGSizeMake(KWHC_SolidCircleRaduis * 2.0, KWHC_SolidCircleRaduis * 2.0);
        _numBtn.layer.cornerRadius = KWHC_SolidCircleRaduis;
    }
    [self addSubview:_numBtn];
}

- (void)setNumber:(NSInteger)number{
    if(_numBtn && _circleType == ClickNumberType){
        _numBtn.tag = number;
        [_numBtn setTitle:@(number).stringValue forState:UIControlStateNormal];
        self.alpha = 0.0;
        [UIView animateWithDuration:KWHC_DrawCircleAnimationDuring delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 1.0;
        } completion:nil];
    }else if(_numBtn && _circleType == GestureDragType){
        _numBtn.tag = number;
        _numBtn.backgroundColor = [UIColor grayColor];
        [self addSubLayer];
    }
}

- (void)clickDownNumBtn:(UIButton *)sender{
    [self addSubLayer];
}

- (void)clickUpNumBtn:(UIButton *)sender{
    if(_btnSubLayer){
        CABasicAnimation   * ba = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        ba.delegate = self;
        ba.fromValue = @(1.0);
        ba.toValue = @(4.0);
        ba.duration = KWHC_BtnSubLayerDismissDuring;
        ba.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [_btnSubLayer addAnimation:ba forKey:@"_btnSubLayerDismiss"];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(WHC_CircleView:clickIndex:)]){
        [_delegate WHC_CircleView:self clickIndex:sender.tag];
    }
}

- (void)addSubLayer{
    if(_btnSubLayer == nil){
        _btnSubLayer = [CAGradientLayer layer];
    }
    _btnSubLayer.frame = _numBtn.bounds;
    _btnSubLayer.colors = @[(id)KWHC_StartColor,(id)KWHC_EndColor];
    _btnSubLayer.locations = @[@(0.0),@(1.0)];
    [_numBtn.layer insertSublayer:_btnSubLayer atIndex:0];
}

#pragma mark - AnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_btnSubLayer removeFromSuperlayer];
}
@end
