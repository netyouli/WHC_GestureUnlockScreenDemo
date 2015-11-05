//
//  WHC_CircleView.h
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

#import <UIKit/UIKit.h>
#import "UIView+WHC_ViewProperty.h"
#define KWHC_SolidCircleRaduis                    (15.0)            //中心实心圆半径
#define KWHC_StartColor      ([UIColor colorWithRed:136.0 / 255.0  green:112.0 / 255.0 blue:151.0 / 255.0 alpha:1.0].CGColor)
#define KWHC_EndColor        ([UIColor colorWithRed:176.0 / 255.0 green:114.0 / 255.0 blue:135.0 / 255.0 alpha:1.0].CGColor)
typedef enum _GestureUnlockType:NSInteger{
    UnknownType = 0 ,            //未知类型
    ClickNumberType,             //点击数字键盘解锁
    GestureDragType              //手势路径拖拽解锁
}WHCGestureUnlockType;

@class WHC_CircleView;
@protocol WHC_CircleViewDelegate <NSObject>

@required
- (void)WHC_CircleView:(WHC_CircleView *)circleView clickIndex:(NSInteger)index;

@end

@interface WHC_CircleView : UIView

@property (nonatomic , assign)id<WHC_CircleViewDelegate> delegate;
@property (nonatomic , assign)WHCGestureUnlockType  circleType;
@property (nonatomic , assign)NSInteger number;

- (void)setFailBackgroundWithStartColor:(CGColorRef)startColor endColor:(CGColorRef)endColor;
- (void)resetBackground;
@end
