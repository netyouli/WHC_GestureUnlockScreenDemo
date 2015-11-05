//
//  WHC_GestureDragPlateView.h
//  WHC_GestureUnlockScreenDemo
//
//  Created by 吴海超 on 15/6/23.
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

@class WHC_GestureDragPlateView;
@protocol  WHC_GestureDragPlateViewDelegate<NSObject>

@required
- (BOOL)WHC_GestureDragPlateView:(WHC_GestureDragPlateView *)gestureDragPlateView psw:(NSString *)strPsw  didFinish:(BOOL)finish;
@end

@interface WHC_GestureDragPlateView : WHC_PlateView

@property (nonatomic , assign)id<WHC_GestureDragPlateViewDelegate> delegate;

- (void)againSetGesturePath:(BOOL)bSet;
@end
