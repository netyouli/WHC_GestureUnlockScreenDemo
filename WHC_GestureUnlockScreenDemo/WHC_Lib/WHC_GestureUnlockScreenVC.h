//
//  WHC_GestureUnlockScreenVC.h
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
#import "WHC_PlateView.h"

@interface WHC_GestureUnlockScreenVC : UIViewController

@property (nonatomic , assign)WHCGestureUnlockType unlockType;
//! 设置背景图片
- (void)setBackgroudImage:(UIImage *)image;
//! 设置屏幕锁(默认当前VC)
+ (void)setUnlockScreen;
//! 设置屏幕锁(自定义当前VC)
+ (void)setUnlockScreenWithSelf:(UIViewController *)sf;
//! 设置屏幕锁(自定义类型默认当前VC)
+ (void)setUnlockScreenWithType:(WHCGestureUnlockType)unlockType;
//! 设置屏幕锁(自定义类型和VC)
+ (void)setUnlockScreenWithType:(WHCGestureUnlockType)unlockType withSelf:(UIViewController *)sf;
//! 修改解锁密码(自定义当前VC) 可以修改返回yes 否则no
+ (BOOL)modifyUnlockPasswrodWithVC:(UIViewController *)vc;
//! 删除手势密码(自定义当前VC) 可以删除返回yes 否则no
+ (BOOL)removeGesturePasswordWithVC:(UIViewController *)vc;

//！强制删除手势密码,不需要用户输入现有手势密码
+ (void)removeGesturePassword;
@end
