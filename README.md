# WHC_GestureUnlockScreenDemo
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
    if(sender.tag == 0){
        [WHC_GestureUnlockScreenVC setUnlockScreen];
    }else{
        [WHC_GestureUnlockScreenVC setUnlockScreenWithType:GestureDragType];
    }
}

```
