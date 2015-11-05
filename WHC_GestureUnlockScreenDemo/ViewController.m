//
//  ViewController.m
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

#import "ViewController.h"
#import "WHC_GestureUnlockScreenVC.h"
@interface ViewController (){
    WHC_GestureUnlockScreenVC  * vc;
}
@property (nonatomic , strong)IBOutlet UIButton * btn1;     //设置数字解锁按钮
@property (nonatomic , strong)IBOutlet UIButton * btn2;     //设置手势路径解锁按钮

@property (nonatomic , strong)IBOutlet UIButton * btn3;     //修改手势密码按钮
@property (nonatomic , strong)IBOutlet UIButton * btn4;     //删除手势密码锁
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WHC";
    _btn1.layer.cornerRadius = 10;
    _btn2.layer.cornerRadius = 10;
    _btn3.layer.cornerRadius = 10;
    _btn4.layer.cornerRadius = 10;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)alert:(NSString *)msg{
    UIAlertView  * alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)clickBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 0://设置数字解锁
            [WHC_GestureUnlockScreenVC setUnlockScreenWithType:ClickNumberType];
            break;
        case 1://设置手势路径解锁
            [WHC_GestureUnlockScreenVC setUnlockScreenWithType:GestureDragType];
            break;
        case 2://修改手势密码
            if(![WHC_GestureUnlockScreenVC modifyUnlockPasswrodWithVC:self]){
                [self alert:@"先设置手势密码再修改"];
            }
            break;
        case 3://删除手势密码锁
            if(![WHC_GestureUnlockScreenVC removeGesturePasswordWithVC:self]){
                [self alert:@"先设置手势密码再删除"];
            }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
