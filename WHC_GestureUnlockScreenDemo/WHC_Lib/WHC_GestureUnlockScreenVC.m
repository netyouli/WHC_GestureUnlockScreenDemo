//
//  WHC_GestureUnlockScreenVC.m
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

#import "WHC_GestureUnlockScreenVC.h"
#import "UIView+WHC_ViewProperty.h"
#import "WHC_PswInputView.h"
#import "WHC_NumberPlateView.h"
#import "WHC_GestureDragPlateView.h"
#define KWHC_InputPswLabY            (30.0)               //输入密码标签y坐标
#define KWHC_InputPswLabHeight       (30.0)               //输入密码标签高度
#define KWHC_BottomHeight            (40.0)               //底部高度
#define KWHC_DelBtnWidth             (60.0)               //删除按钮宽度
#define KWHC_Iphone4Height           (480.0)              //iphone4高度

#define KWHC_inputOldPswLabTxt       (@"请输入旧密码")
#define KWHC_inputNewPswLabTxt       (@"请输入新密码")
#define KWHC_inputOldGestureLabTxt   (@"请输入旧手势")
#define KWHC_inputNewGestureLabTxt   (@"请输入新手势")

#define KWHC_InputPswLabTxt          (@"请输入密码")        //输入密码标签文字
#define KWHC_InputPswLabAgTxt        (@"请再次输入密码")     //输入密码标签文字
#define KWHC_InputPswLabReTxt        (@"请重新输入密码")     //输入密码标签文字
#define KWHC_InputPswLabGestureTxt   (@"请输入手势")         //输入密码标签文字
#define KWHC_InputPswLabGestureAgTxt (@"请再次输入手势")      //输入密码标签文字
#define KWHC_InputPswLabGestureReTxt (@"请重新输入手势")      //输入密码标签文字
#define KWHC_UnlockSuccessTxt        (@"正在进入系统")       //解锁成功提示
#define KWHC_SetUnlockSuccessTxt     (@"设置密码成功")       //解锁成功提示
#define KWHC_DelBtnTxt               (@"删除")             //删除按钮文字
#define KWHC_CancelBtnTxt            (@"取消")             //取消按钮文字
#define KWHC_ConfigurationKey        (@"ConfigurationKey")//配置信息key
#define KWHC_SetStateKey             (@"SetStateKey")     //状态key
#define KWHC_PswKey                  (@"PswKey")          //密码key

#define KWHC_BackStartColor          ((id)[UIColor colorWithRed:56.0 / 255.0 green:34.0 / 255.0 blue:80.0 / 255.0 alpha:1.0].CGColor)
#define KWHC_BackEndColor            ((id)[UIColor colorWithRed:56.0 / 255.0 green:34.0 / 255.0 blue:36.0 / 255.0 alpha:1.0].CGColor)
@interface WHC_GestureUnlockScreenVC ()<WHC_NumberPlateViewDelegate , WHC_GestureDragPlateViewDelegate>{
    NSMutableString             * _pswOnce;               //第一次密码
    NSMutableString             * _pswTwo;                //第二次密码
    NSString                    * _modifyPsw;             //修改的密码
    NSString                    * _didSavePsw;            //已经存储的密码
    UILabel                     * _inputPswLab;           //输入密码提示标签
    WHC_PswInputView            * _pswInputView;          //密码输入视图
    WHC_GestureDragPlateView    * _gestureInputView;      //手势密码输入视图
    WHC_NumberPlateView         * _numberPlateView;       //数字按钮视图
    UIButton                    * _delBtn;                //删除按钮
    UIButton                    * _cancelBtn;             //取消按钮
    CAGradientLayer             * _defaultBackgroudLayer; //默认背景层
    BOOL                          _setState;              //设置状态
    BOOL                          _isAgainSetPsw;         //是否再次设置密码
    BOOL                          _isModifyPassword;      //是否修改密码
    BOOL                          _isRemovePassword;      //是否删除密码
}

@end

@implementation WHC_GestureUnlockScreenVC

+ (void)setUnlockScreen{
    [WHC_GestureUnlockScreenVC setUnlockScreenWithSelf:[WHC_GestureUnlockScreenVC getCurrentVC]];
}

+ (void)setUnlockScreenWithSelf:(UIViewController *)sf{
    if([WHC_GestureUnlockScreenVC readDefaultUnlockType] != UnknownType){
        [WHC_GestureUnlockScreenVC setUnlockScreenWithType:UnknownType withSelf:sf];
    }
}

+ (void)setUnlockScreenWithType:(WHCGestureUnlockType)unlockType{
    [WHC_GestureUnlockScreenVC setUnlockScreenWithType:unlockType withSelf:[WHC_GestureUnlockScreenVC getCurrentVC]];
}

+ (void)setUnlockScreenWithType:(WHCGestureUnlockType)unlockType withSelf:(UIViewController *)sf{
    WHC_GestureUnlockScreenVC  * unlockVC = [WHC_GestureUnlockScreenVC new];
    unlockVC.unlockType = unlockType;
    [sf presentViewController:unlockVC animated:NO completion:nil];
}

+ (BOOL)modifyUnlockPasswrodWithVC:(UIViewController *)vc{
    if([WHC_GestureUnlockScreenVC readDefaultUnlockType] != UnknownType){
        WHC_GestureUnlockScreenVC * unlockVC = [WHC_GestureUnlockScreenVC new];
        unlockVC.unlockType = UnknownType;
        [unlockVC setModifyPasswordState:YES];
        [vc presentViewController:unlockVC animated:NO completion:nil];
        return YES;
    }
    return NO;
}

+ (BOOL)removeGesturePasswordWithVC:(UIViewController *)vc{
    if([WHC_GestureUnlockScreenVC readDefaultUnlockType] != UnknownType){
        WHC_GestureUnlockScreenVC * unlockVC = [WHC_GestureUnlockScreenVC new];
        unlockVC.unlockType = UnknownType;
        [unlockVC setRemoveGesturePassword:YES];
        [vc presentViewController:unlockVC animated:NO completion:nil];
        return YES;
    }
    return NO;
}

+ (void)removeGesturePassword{
    NSUserDefaults  * ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:KWHC_ConfigurationKey];
    [ud synchronize];
}

+ (UIViewController *)getCurrentVC{
    UIViewController  * currentVC = nil;
    UIViewController  * rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    if([rootVC isKindOfClass:[UINavigationController class]]){
        currentVC = ((UINavigationController *) rootVC).topViewController;
    }else if ([rootVC isKindOfClass:[UITabBarController class]]){
        UIViewController  * tabBarVC = ((UITabBarController *)rootVC).selectedViewController;
        if([tabBarVC isKindOfClass:[UINavigationController class]]){
            currentVC = ((UINavigationController *) tabBarVC).topViewController;
        }else{
            currentVC = tabBarVC;
        }
    }else{
        currentVC = rootVC;
    }
    return currentVC;
}

- (instancetype)init{
    self = [super init];
    if(self){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultBackgroud];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if(_unlockType == UnknownType){
        _unlockType = [WHC_GestureUnlockScreenVC readDefaultUnlockType];
    }
    [self updateUILayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    _pswOnce = [NSMutableString string];
    _pswTwo = [NSMutableString string];
}

+ (WHCGestureUnlockType)readDefaultUnlockType{
    WHCGestureUnlockType  unlockType;
    NSUserDefaults   * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary  * dict = [ud objectForKey:KWHC_ConfigurationKey];
    if(dict && dict.count > 0){
        NSArray * keyArr = [dict allKeys];
        if(keyArr && keyArr.count > 0){
            unlockType = [keyArr[0] integerValue];
        }else{
            unlockType = UnknownType;
        }
    }else{
        unlockType = UnknownType;
    }
    return unlockType;
}

- (void)readConfigurationInfo{
    NSUserDefaults   * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary  * dict = [ud objectForKey:KWHC_ConfigurationKey];
    if(dict && dict.count > 0){
        NSDictionary  * typeDict = dict[@(_unlockType).stringValue];
        if(typeDict && typeDict.count > 0){
            _setState = [typeDict[KWHC_SetStateKey] boolValue];
            _setState = !_setState;
            _didSavePsw = typeDict[KWHC_PswKey];
        }else{
            _setState = YES;
            _didSavePsw = @"";
        }
    }else{
        _setState = YES;
        _didSavePsw = @"";
    }
}

- (void)setModifyPasswordState:(BOOL)state{
    _isModifyPassword = state;
}

- (void)setRemoveGesturePassword:(BOOL)state{
    _isRemovePassword = state;
}

- (void)saveConfigurationInfo{
    NSString  * gesturePsw = nil;
    if(_isModifyPassword){
        gesturePsw = _modifyPsw;
    }else{
        gesturePsw = _pswOnce;
    }
    _setState = YES;
    NSUserDefaults  * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary    * dict = @{@(_unlockType).stringValue:@{KWHC_SetStateKey:@(_setState),KWHC_PswKey:gesturePsw}};
    [ud setObject:dict forKey:KWHC_ConfigurationKey];
    [ud synchronize];
}

- (void)setDefaultBackgroud{
    _defaultBackgroudLayer = [CAGradientLayer layer];
    _defaultBackgroudLayer.frame = self.view.bounds;
    _defaultBackgroudLayer.colors = @[KWHC_BackStartColor,KWHC_BackEndColor];
    _defaultBackgroudLayer.locations = @[@(0.0),@(1.0)];
    [self.view.layer insertSublayer:_defaultBackgroudLayer atIndex:0];
}

- (void)updateUILayout{
    [self readConfigurationInfo];
    for (UIView * subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat   ratioHeight = [UIScreen mainScreen].bounds.size.height / KWHC_Iphone4Height;
    if(_unlockType == ClickNumberType){
        _inputPswLab = [[UILabel alloc]initWithFrame:CGRectMake(0.0, KWHC_InputPswLabY * ratioHeight, self.view.width, KWHC_InputPswLabHeight)];
        _inputPswLab.backgroundColor = [UIColor clearColor];
        _inputPswLab.textAlignment = NSTextAlignmentCenter;
        if(_isModifyPassword){
            _inputPswLab.text = KWHC_inputOldPswLabTxt;
        }else{
            _inputPswLab.text = KWHC_InputPswLabTxt;
        }
        _inputPswLab.textColor = [UIColor whiteColor];
        [self.view addSubview:_inputPswLab];
        
        _pswInputView = [[WHC_PswInputView alloc]initWithFrame:CGRectMake(0.0, _inputPswLab.maxY, self.view.width, KWHC_InputPswLabHeight)];
        [self.view addSubview:_pswInputView];
        
        CGFloat    numberPlateViewY = self.view.height - KWHC_BottomHeight - [WHC_PlateView plateHeightWithType:ClickNumberType];
        _numberPlateView = [[WHC_NumberPlateView alloc]initWithFrame:CGRectMake(0.0, numberPlateViewY, self.view.width, [WHC_PlateView plateHeightWithType:ClickNumberType])];
        _numberPlateView.delegate = self;
        [self.view addSubview:_numberPlateView];
        
        _delBtn = [self createButtonWithFrame:CGRectMake(self.view.width - KWHC_DelBtnWidth * 1.5, _numberPlateView.maxY, KWHC_DelBtnWidth, KWHC_BottomHeight) txt:KWHC_DelBtnTxt];
        [_delBtn addTarget:self action:@selector(clickDelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_delBtn];
        
    }else if (_unlockType == GestureDragType){
        _inputPswLab = [[UILabel alloc]initWithFrame:CGRectMake(0.0, KWHC_InputPswLabY * ratioHeight * 2.0, self.view.width, KWHC_InputPswLabHeight)];
        _inputPswLab.backgroundColor = [UIColor clearColor];
        _inputPswLab.textAlignment = NSTextAlignmentCenter;
        if(_isModifyPassword){
            _inputPswLab.text = KWHC_inputOldGestureLabTxt;
        }else{
            _inputPswLab.text = KWHC_InputPswLabGestureTxt;
        }
        _inputPswLab.textColor = [UIColor whiteColor];
        [self.view addSubview:_inputPswLab];
        
        CGFloat    numberPlateViewY = _inputPswLab.maxY * 1.5;
        _gestureInputView = [[WHC_GestureDragPlateView alloc]initWithFrame:CGRectMake(0.0, numberPlateViewY, self.view.width, [WHC_PlateView plateHeightWithType:GestureDragType])];
        _gestureInputView.delegate = self;
        [self.view addSubview:_gestureInputView];
    }
    
    if(_setState || _isModifyPassword || _isRemovePassword){
        _cancelBtn = [self createButtonWithFrame:CGRectMake(KWHC_DelBtnWidth / 2.0, self.view.height - KWHC_BottomHeight, KWHC_DelBtnWidth, KWHC_BottomHeight) txt:KWHC_CancelBtnTxt];
        [_cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelBtn];
    }
}

- (UIButton *)createButtonWithFrame:(CGRect)frame txt:(NSString *)txt{
    UIButton  * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitle:txt forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}

- (void)setUnlockType:(WHCGestureUnlockType)unlockType{
    if(unlockType != _unlockType){
        _unlockType = unlockType;
        [self updateUILayout];
    }
}

- (void)setBackgroudImage:(UIImage *)image{
    if(image){
        if(_defaultBackgroudLayer){
            [_defaultBackgroudLayer removeFromSuperlayer];
            _defaultBackgroudLayer = nil;
        }
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    }
}

- (void)clickDelBtn:(UIButton *)sender{
    [_pswInputView clearPswCircle];
    [_numberPlateView decClickCount];
    if(_pswOnce.length > 0) {
        [_pswOnce deleteCharactersInRange:NSMakeRange(_pswOnce.length - 1, 1)];
    }
}

- (void)clickCancelBtn:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WHC_NumberPlateViewDelegate
- (void)WHC_NumberPlateView:(WHC_NumberPlateView *)numberPlateView clickIndex:(NSInteger)index  didFinish:(BOOL)finish{
    if(_isAgainSetPsw){
        [_pswTwo appendString:@(index).stringValue];
    }else{
        [_pswOnce appendString:@(index).stringValue];
    }
    if(finish){
        __weak typeof(self)  sf = self;
        [_pswInputView addPswCircleFinish:^{
            if(_isAgainSetPsw){
                if(_isModifyPassword){
                    if(_modifyPsw){
                        if([_pswTwo isEqualToString:_modifyPsw]){
                            _inputPswLab.text = KWHC_SetUnlockSuccessTxt;
                            [_pswInputView clearAllPswCircle];
                            [sf saveConfigurationInfo];
                            [sf dismissViewControllerAnimated:YES completion:nil];
                        }else{
                            [_pswInputView showMistakeMsg];
                            [_numberPlateView clearClickCount];
                            if(_isModifyPassword){
                                _inputPswLab.text = KWHC_inputOldPswLabTxt;
                            }else{
                                _inputPswLab.text = KWHC_InputPswLabTxt;
                            }
                            _modifyPsw = nil;
                            [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                            [_pswTwo deleteCharactersInRange:NSMakeRange(0, _pswTwo.length)];
                            _isAgainSetPsw = NO;
                        }
                    }else{
                        _modifyPsw = _pswTwo.copy;
                        [_pswInputView clearAllPswCircle];
                        [_numberPlateView clearClickCount];
                        _inputPswLab.text = KWHC_InputPswLabTxt;
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                        [_pswTwo deleteCharactersInRange:NSMakeRange(0, _pswTwo.length)];
                    }
                }else{
                    if([_pswTwo isEqualToString:_pswOnce]){
                        _inputPswLab.text = KWHC_SetUnlockSuccessTxt;
                        [_pswInputView clearAllPswCircle];
                        [sf saveConfigurationInfo];
                        [sf dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [_pswInputView showMistakeMsg];
                        [_numberPlateView clearClickCount];
                        if(_isModifyPassword){
                            _inputPswLab.text = KWHC_inputOldPswLabTxt;
                        }else{
                            _inputPswLab.text = KWHC_InputPswLabTxt;
                        }
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                        [_pswTwo deleteCharactersInRange:NSMakeRange(0, _pswTwo.length)];
                        _isAgainSetPsw = NO;
                    }
                }
            }else{
                if(_setState || _isModifyPassword){
                    _isAgainSetPsw = YES;
                    if(_isModifyPassword){
                        if([_didSavePsw isEqualToString:_pswOnce]){
                            _inputPswLab.text = KWHC_inputNewPswLabTxt;
                        }else{
                            _isAgainSetPsw = NO;
                            [_pswInputView showMistakeMsg];
                            _inputPswLab.text = KWHC_inputOldPswLabTxt;
                            [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                        }
                    }else{
                        _inputPswLab.text = KWHC_InputPswLabAgTxt;
                    }
                    [_pswInputView clearAllPswCircle];
                    [_numberPlateView clearClickCount];
                }else{
                    if([_didSavePsw isEqualToString:_pswOnce]){
                        _inputPswLab.text = KWHC_InputPswLabGestureReTxt;
                        [_pswInputView clearAllPswCircle];
                        [sf dismissViewControllerAnimated:YES completion:nil];
                        if(_isRemovePassword){
                            [WHC_GestureUnlockScreenVC removeGesturePassword];
                        }
                    }else{
                        [_pswInputView showMistakeMsg];
                        [_numberPlateView clearClickCount];
                        if(_isModifyPassword){
                            _inputPswLab.text = KWHC_inputOldPswLabTxt;
                        }else{
                            _inputPswLab.text = KWHC_InputPswLabReTxt;
                        }
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                    }
                }
            }
        }];
    }else{
        [_pswInputView addPswCircleFinish:nil];
    }
}

#pragma mark - WHC_GestureDragPlateViewDelegate
- (BOOL)WHC_GestureDragPlateView:(WHC_GestureDragPlateView *)gestureDragPlateView psw:(NSString *)strPsw  didFinish:(BOOL)finish{
    BOOL  isSuccess = NO;
    if(finish){
        if(_isAgainSetPsw){
            if(_isModifyPassword){
                if(_modifyPsw){
                    if([_modifyPsw isEqualToString:strPsw]){
                        isSuccess = YES;
                        _inputPswLab.text = KWHC_SetUnlockSuccessTxt;
                        [self saveConfigurationInfo];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        _modifyPsw = nil;
                        [_gestureInputView againSetGesturePath:NO];
                        _inputPswLab.text = KWHC_inputOldGestureLabTxt;
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                        _isAgainSetPsw = NO;
                    }
                }else{
                    isSuccess = YES;
                    _modifyPsw = strPsw.copy;
                    [_gestureInputView againSetGesturePath:YES];
                }
                [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
            }else{
                if([strPsw isEqualToString:_pswOnce]){
                    isSuccess = YES;
                    _inputPswLab.text = KWHC_SetUnlockSuccessTxt;
                    [self saveConfigurationInfo];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [_gestureInputView againSetGesturePath:NO];
                    _inputPswLab.text = KWHC_InputPswLabGestureTxt;
                    [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                    _isAgainSetPsw = NO;
                }
            }
        }else{
            if(_setState || _isModifyPassword){
                _pswOnce = [NSMutableString stringWithString:strPsw];
                _isAgainSetPsw = YES;
                if(_isModifyPassword){
                    if([strPsw isEqualToString:_didSavePsw]){
                        isSuccess = YES;
                        _inputPswLab.text = KWHC_inputNewGestureLabTxt;
                    }else{
                        _inputPswLab.text = KWHC_inputOldGestureLabTxt;
                        _isAgainSetPsw = NO;
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                    }
                }else{
                    _inputPswLab.text = KWHC_InputPswLabGestureAgTxt;
                }
                [_gestureInputView againSetGesturePath:_isAgainSetPsw];
            }else{
                if([strPsw isEqualToString:_didSavePsw]){
                    isSuccess = YES;
                    _inputPswLab.text = KWHC_UnlockSuccessTxt;
                    [self dismissViewControllerAnimated:YES completion:nil];
                    if(_isRemovePassword){
                        [WHC_GestureUnlockScreenVC removeGesturePassword];
                    }
                }else{
                    _inputPswLab.text = KWHC_InputPswLabGestureReTxt;
                }
            }
        }
    }
    return isSuccess;
}
@end
