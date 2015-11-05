//
//  WHC_NumberPlateView.h
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

@class WHC_NumberPlateView;
@protocol  WHC_NumberPlateViewDelegate<NSObject>

@required
- (void)WHC_NumberPlateView:(WHC_NumberPlateView *)numberPlateView clickIndex:(NSInteger)index  didFinish:(BOOL)finish;
@end

@interface WHC_NumberPlateView : WHC_PlateView

@property (nonatomic , assign)id<WHC_NumberPlateViewDelegate> delegate;

- (void)updateUILayout;

- (void)clearClickCount;

- (void)decClickCount;
@end
