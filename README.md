# WHC_GestureUnlockScreenDemo
/*
*  qq:712641411
*  iOS大神qq群:460122071
*/
目前最牛逼的屏幕解锁开源项目

屏幕解锁(android类型手势拖拽解锁和iphone数字键盘解锁两种类型)采用动态渐变的色彩绘制整个UI,对于想学习动态和渐变绘图的开发者很有帮助。

##运行效果
![image](https://github.com/netyouli/WHC_GestureUnlockScreenDemo/tree/master/WHC_GestureUnlockScreenDemo/gif/a.gif)
![image](https://github.com/netyouli/WHC_GestureUnlockScreenDemo/tree/master/WHC_GestureUnlockScreenDemo/gif/b.gif)
![image](https://github.com/netyouli/WHC_GestureUnlockScreenDemo/tree/master/WHC_GestureUnlockScreenDemo/gif/c.gif)
##接口使用实例
####Use Example
```objective-c
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

```
