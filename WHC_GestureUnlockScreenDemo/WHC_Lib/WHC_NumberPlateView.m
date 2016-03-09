//
//  WHC_NumberPlateView.m
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
#import "WHC_NumberPlateView.h"


@interface WHC_NumberPlateView (){
    NSInteger         _clickCount;       //单击次数
}

@end

@implementation WHC_NumberPlateView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self updateUILayout];
    }
    return self;
}

- (void)updateUILayout{
    _clickCount = 0;
    [self updateUILayoutWithType:ClickNumberType];
}

- (void)clearClickCount{
    _clickCount = 0;
}

- (void)decClickCount{
    _clickCount--;
    if (_clickCount < 0) {
        _clickCount = 0;
    }
}
#pragma mark - WHC_CircleViewDelegate
- (void)WHC_CircleView:(WHC_CircleView *)circleView clickIndex:(NSInteger)index{
    if(_clickCount >= KWHC_PlateColumn){
        _clickCount = 0;
        if(_delegate && [_delegate respondsToSelector:@selector(WHC_NumberPlateView:clickIndex:didFinish:)]){
            [_delegate WHC_NumberPlateView:self clickIndex:index didFinish:YES];
        }
    }else{
        if(_delegate && [_delegate respondsToSelector:@selector(WHC_NumberPlateView:clickIndex:didFinish:)]){
            [_delegate WHC_NumberPlateView:self clickIndex:index didFinish:NO];
        }
    }
    _clickCount++;
}
@end
