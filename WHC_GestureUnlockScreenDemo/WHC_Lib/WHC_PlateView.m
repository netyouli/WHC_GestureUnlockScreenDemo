//
//  WHC_PlateView.m
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

#import "WHC_PlateView.h"

#define KWHC_CircleMargin                 (30.0)               //圈之间的间隙


@interface WHC_Rect : NSObject

@property (nonatomic , assign)NSInteger number;

@property (nonatomic , assign)CGRect    rect;

@end

@implementation WHC_Rect

- (instancetype)init{
    self = [super init];
    if(self){
        _number = 0;
        _rect = CGRectZero;
    }
    return self;
}

@end
@interface WHC_PlateView ()<WHC_CircleViewDelegate>{
    NSMutableArray             *    _rectArr;                  //区域数组
    NSMutableArray             *    _circleViewArr;            //圈视图数组
}

@end

@implementation WHC_PlateView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _rectArr = [NSMutableArray array];
        _circleViewArr = [NSMutableArray array];
    }
    return self;
}

+ (CGFloat)plateHeightWithType:(WHCGestureUnlockType)type{
    CGFloat   screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat   circleWidth = (screenWidth - (KWHC_PlateColumn + 1) * KWHC_CircleMargin) / (CGFloat)KWHC_PlateColumn;
    CGFloat   circleSumWidth = KWHC_PlateRow * circleWidth + KWHC_PlateRow * KWHC_CircleMargin;
    circleSumWidth += circleWidth;
    if(type == GestureDragType){
        circleSumWidth -= circleWidth;
    }
    return circleSumWidth;
}

- (void)updateUILayoutWithType:(WHCGestureUnlockType)type{
    NSArray  * subArr = self.subviews;
    if(subArr){
        for (UIView * subView in subArr) {
            [subView removeFromSuperview];
        }
    }
    [_rectArr removeAllObjects];
    [_circleViewArr removeAllObjects];
    self.backgroundColor = [UIColor clearColor];
    CGFloat   circleWidth = (self.width - (KWHC_PlateColumn + 1) * KWHC_CircleMargin) / (CGFloat)KWHC_PlateColumn;
    CGFloat   circleSumWidth = KWHC_PlateColumn * circleWidth + (KWHC_PlateColumn - 1) * KWHC_CircleMargin;
    CGFloat   oneCircleX = (self.width - circleSumWidth) / 2.0;
    for (NSInteger i = 0; i < KWHC_PlateRow; i++) {
        for (NSInteger j = 0; j < KWHC_PlateColumn; j++) {
            NSInteger  number = i * KWHC_PlateRow + j + 1;
            CGFloat  x = oneCircleX + circleWidth / 2.0 * (j + 1) + j * (KWHC_CircleMargin + circleWidth / 2.0);
            WHC_CircleView  * circleView = [WHC_CircleView new];
            circleView.delegate = self;
            circleView.size = CGSizeMake(circleWidth, circleWidth);
            circleView.center = CGPointMake(x, (i + 1) * circleWidth / 2.0 + i * (KWHC_CircleMargin + circleWidth / 2.0));
            circleView.circleType = type;
            [circleView setNumber:number];
            [self addSubview:circleView];
            [_circleViewArr addObject:circleView];
            if(type == GestureDragType){
                WHC_Rect   * rectObject = [WHC_Rect new];
                CGRect     rect  = {circleView.x, circleView.y , circleWidth, circleWidth};
                rectObject.rect = rect;
                rectObject.number = number;
                [_rectArr addObject:rectObject];
            }
        }
    }
    if(type == ClickNumberType){
        WHC_CircleView  * circleView = [WHC_CircleView new];
        circleView.delegate = self;
        circleView.size = CGSizeMake(circleWidth, circleWidth);
        circleView.center = CGPointMake(self.centerX, (KWHC_PlateRow + 1) * circleWidth / 2.0 + KWHC_PlateRow * (KWHC_CircleMargin + circleWidth / 2.0));
        circleView.circleType = ClickNumberType;
        [circleView setNumber:0];
        [self addSubview:circleView];
    }
}

- (CGPoint)checkConnectPoint:(CGPoint)point{
    CGPoint     resultPoint = CGPointZero;
    for (WHC_Rect * rectObject in _rectArr) {
        CGRect  rect = rectObject.rect;
        if(CGRectContainsPoint(rect, point)){
            resultPoint = CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) / 2.0, CGRectGetMinY(rect) + CGRectGetHeight(rect) / 2.0);
            break;
        }
    }
    return resultPoint;
}

- (NSString *)getGesturePswWithPoints:(NSArray *)pointArr{
    NSMutableString  * strPsw = [NSMutableString string];
    NSInteger          count = _rectArr.count;
    for (NSValue * value in pointArr) {
        CGPoint  point = [value CGPointValue];
        for (NSInteger i = 0; i < count; i++) {
            WHC_Rect * rectObject = _rectArr[i];
            CGRect  rect = rectObject.rect;
            if(CGRectContainsPoint(rect, point)){
                [strPsw appendString:@(rectObject.number).stringValue];
            }
        }
    }
    return strPsw;
}


- (NSInteger)checkDidConnectIndexPoint:(CGPoint)point{
    NSInteger  index = -1;
    for (WHC_Rect * rectObject in _rectArr) {
        CGRect  rect = rectObject.rect;
        if(CGRectContainsPoint(rect, point)){
            index = rectObject.number;
            break;
        }
    }
    return index;
}

- (WHC_CircleView *)getCircleViewWithIndex:(NSInteger)index{
    WHC_CircleView * circleView = nil;
    if(_circleViewArr){
        for (WHC_CircleView * tempCircleView in _circleViewArr) {
            if(index == tempCircleView.number){
                circleView = tempCircleView;
                break;
            }
        }
    }
    return circleView;
}

- (void)resetCircleBackgroundWithPoints:(NSArray *)points{
    [self setFailBackgroundWithStartColor:NULL endColor:NULL isFail:NO  points:points];
}

- (void)setFailBackgroundWithStartColor:(CGColorRef)startColor endColor:(CGColorRef)endColor points:(NSArray *)points{
    [self setFailBackgroundWithStartColor:startColor endColor:endColor isFail:YES points:points];
}

- (void)setFailBackgroundWithStartColor:(CGColorRef)startColor endColor:(CGColorRef)endColor isFail:(BOOL)isFail points:(NSArray *)points{
    
    for (NSValue * pointValue in points) {
        CGPoint  point = [pointValue CGPointValue];
        NSInteger  index = [self checkDidConnectIndexPoint:point];
        if(index != -1){
            WHC_CircleView  * circleView = [self getCircleViewWithIndex:index];
            if(circleView){
                if(isFail){
                    [circleView setFailBackgroundWithStartColor:startColor endColor:endColor];
                }else{
                    [circleView resetBackground];
                }
            }
        }
    }
}

#pragma mark - WHC_CircleViewDelegate
- (void)WHC_CircleView:(WHC_CircleView *)circleView clickIndex:(NSInteger)index{
    //空实现
}
@end
