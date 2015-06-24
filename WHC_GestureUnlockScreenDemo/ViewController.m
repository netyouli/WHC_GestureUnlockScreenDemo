//
//  ViewController.m
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

#import "ViewController.h"
#import "WHC_GestureUnlockScreenVC.h"
@interface ViewController (){
    WHC_GestureUnlockScreenVC  * vc;
}
@property (nonatomic , strong)IBOutlet UIButton * btn1;
@property (nonatomic , strong)IBOutlet UIButton * btn2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XXX";
    _btn1.layer.cornerRadius = 10;
    _btn2.layer.cornerRadius = 10;
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickBtn:(UIButton *)sender{
    if(sender.tag == 0){
        [WHC_GestureUnlockScreenVC setUnlockScreen];
    }else{
        [WHC_GestureUnlockScreenVC setUnlockScreenWithType:GestureDragType];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
