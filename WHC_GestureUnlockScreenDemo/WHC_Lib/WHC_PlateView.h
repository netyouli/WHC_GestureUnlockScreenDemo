//
//  WHC_PlateView.h
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

#import <UIKit/UIKit.h>
#import "WHC_CircleView.h"
#define KWHC_PlateRow                     (3)                  //数字盘行
#define KWHC_PlateColumn                  (3)                  //数字盘列

@interface WHC_PlateView : UIView

- (void)WHC_CircleView:(WHC_CircleView *)circleView clickIndex:(NSInteger)index;
- (void)updateUILayoutWithType:(WHCGestureUnlockType)type;
- (CGPoint)checkConnectPoint:(CGPoint)point;
+ (CGFloat)plateHeightWithType:(WHCGestureUnlockType)type;
- (NSString *)getGesturePswWithPoints:(NSArray *)pointArr;
@end
