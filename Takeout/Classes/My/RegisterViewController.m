//
//  RegisterViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-9.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

enum
{
    BtnTag_Back = 431,
    BtnTag_SendVerification,
    BtnTag_Register,
};

#define HeadViewHeight 40
#define NUMBERS @"0123456789\n"

#import "RegisterViewController.h"
#import "ConstValues.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LeafNotification.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIView *_contentView ;
    
//    UITextField *_campusTF;
//    UITextField *_dormitoryBuildingTF;
//    UITextField *_dormitoryTF;
    
    UITextField *_acountTF;
    UITextField *_verificationTF;
    UITextField *_passwordTF;
    UITextField *_passwordComfirmTF;
}
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - 创建注册界面

-(void)initView
{
    float height = CVScreenSize.height - 20 - HeadViewHeight;
    float width = CVScreenSize.width;
    float x = 0;
    float y = 20;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.view addSubview:_contentView];
    
    //  创建 textField ,注册项, 先全部分配空间地址，防止取出来循环操作时，崩溃
    _acountTF = [[UITextField alloc] initWithFrame:CGRectZero];
    _verificationTF = [[UITextField alloc] initWithFrame:CGRectZero];
    _passwordTF = [[UITextField alloc] initWithFrame:CGRectZero];
    _passwordComfirmTF = [[UITextField alloc] initWithFrame:CGRectZero];

    NSArray *textFieldsArray = [NSArray arrayWithObjects:_acountTF,_verificationTF,_passwordTF,_passwordComfirmTF, nil];
    NSArray *iconNamesArray = [NSArray arrayWithObjects:@"reg_iphone",@"reg_verification",@"reg_password",@"reg_password", nil];
    NSArray *placeholdersArray = [NSArray arrayWithObjects:@"请输入您的手机号码",@"请输入验证码 ",@"请输入您的密码",@"请重新确认您的密码", nil];
    
    float offsetX = 10;
    float offsetY = 20;
    x = offsetX;
    y = 4*offsetY + 5;
    width = _contentView.frame.size.width - offsetX*2;
    height = 35;
    UITextField *tf = nil;
    
#pragma mark - 循环创建输入框
    for (int i = 0; i < 4; i ++) {
        
        tf = (UITextField *)textFieldsArray[i];
        tf.frame = CGRectMake(x, y, width, height);
        tf.backgroundColor = [UIColor whiteColor];
        tf.layer.cornerRadius = 5;
        tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tf.layer.borderWidth = 0.5;
        tf.placeholder = placeholdersArray[i];
        [tf setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        tf.delegate = self;
        tf.keyboardAppearance = UIKeyboardAppearanceDark;
        
        if (i == 0 || i == 1)
            tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        else
            tf.keyboardType = UIKeyboardTypeDefault;
        
        if (i <= 2)
            tf.returnKeyType = UIReturnKeyNext;
        else
            tf.returnKeyType = UIReturnKeyDone;
        
        if (i == 1) {
            tf.frame = CGRectMake(x, y, width-90, height);
            UIButton *verificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            verificationBtn.frame = CGRectMake(CGRectGetMaxX(tf.frame)+ 5, y, 80, height);
            verificationBtn.layer.cornerRadius = 8;
            verificationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            verificationBtn.layer.borderWidth = 0.8;
            verificationBtn.backgroundColor = [UIColor whiteColor];
            [verificationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            verificationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [verificationBtn setTitleColor:CVMainColor forState:UIControlStateNormal];
            verificationBtn.tag = BtnTag_Register;
            [verificationBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:verificationBtn];
            
        }else if (i == 2||i==3){
            tf.secureTextEntry = YES;
        }
        
        [_contentView addSubview:tf];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height + 10, height)];
        leftView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        leftView.layer.borderWidth = 0.3;
        leftView.contentMode = UIViewContentModeCenter;
        
        UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, height-10, height - 10)];
        leftImgView.contentMode = UIViewContentModeScaleToFill;
        leftImgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:iconNamesArray[i] ofType:@"png"]];
        [leftView addSubview:leftImgView];
        
        tf.leftView = leftView;
        tf.leftViewMode = UITextFieldViewModeAlways;
        
        y += height + offsetY;
    }
    
    y += offsetY;
    width = width/2;
    x += width/2;
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(x, y, width, height);
    registerBtn.layer.cornerRadius = 8;
    registerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    registerBtn.layer.borderWidth = 0.8;
    registerBtn.backgroundColor = [UIColor whiteColor];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:CVMainColor forState:UIControlStateNormal];
    registerBtn.tag = BtnTag_Register;
    [registerBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:registerBtn];
    
}

#pragma mark - 按钮事件
-(void)btnClicked:(UIButton *)button
{
    switch (button.tag) {
            
        case BtnTag_Back:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case BtnTag_SendVerification:
        {
            
        }
            break;
            
        case BtnTag_Register:
        {
            if ([self isBasiclyEnabledToRegister]) {
                [self judgeAndRegisterToServer];
            }
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 本地基本判断是否可以注册,文本输入格式等
-(BOOL)isBasiclyEnabledToRegister
{
    //UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    if (_acountTF.text.length != 11){
        [LeafNotification showInController:self withText: @"手机号码不正确"];
        return NO;
    }
    
    if (_passwordTF.text.length < 6) {
        
        [LeafNotification showInController:self withText: @"密码长度不能小于6位"];
        return NO;

    }
    
    if (![_passwordTF.text isEqualToString:_passwordComfirmTF.text]) {
        [LeafNotification showInController:self withText: @"两次输入的密码不同"];
        return NO;
        
    }

    return YES;
}


#pragma mark - , 服务器数据判断，成功则 ：注册数据
-(void)judgeAndRegisterToServer
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    AVUser *user = [AVUser user];
    user.username=_acountTF.text;
    user.password=_passwordTF.text;
    [user setObject:_acountTF.text forKey:@"nickname"];
    NSLog(@"%@",[user objectForKey:@"nickname"]);
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            alertView.message = @"注册成功";
            [alertView addButtonWithTitle:@"去登录"];
            //注册成功后也可以直接通过currentUser获取当前登陆用户
            NSLog(@"currentuser:%@",[NSString stringWithFormat:@"当前用户 %@",[[AVUser currentUser] username]]);
        }else{
            
            switch (error.code) {
                case 202:
                {
                    alertView.message = @"手机号已注册";
                    [alertView addButtonWithTitle:@"去登录"];
                }
                    break;
                case -1009:
                    alertView.message = @"网络不给力";
                    break;
                default:
                    break;
            }
        }
        
        [alertView show];

    }];

}

#pragma mark - 抖动某个视图
-(void)lockAnimationForView:(UIView*)view
{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_bg" ofType:@"png"]];
    [self.view addSubview:bgImageView];
    
#pragma mark - 必须创建在返回按钮之前
    [self initView];

    // 返回按钮
    float y = 20;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, y, CVScreenSize.width, HeadViewHeight)];
    headView.backgroundColor = CVMainColor;
    [self.view addSubview:headView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, HeadViewHeight+30, HeadViewHeight);
    [backBtn setTitle:@" < 返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE];
    backBtn.tag = BtnTag_Back;
    [backBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y+HeadViewHeight-1, CVScreenSize.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.view addSubview:lineView];
    
}

#pragma mark - 抬起键盘 UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_contentView.frame.origin.y == 20) {
        
        _contentView.center = CGPointMake(_contentView.center.x, _contentView.center.y - 40);
    }
    return YES;
}


#pragma mark - 收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if (_contentView.frame.origin.y == -20) {
        
        _contentView.center = CGPointMake(_contentView.center.x, _contentView.center.y + 40);
    }
    
}

#pragma mark - 键盘事件： Return 键触发
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _acountTF) {
        [_verificationTF  becomeFirstResponder];
    }
    else if(textField == _verificationTF){
        [_passwordTF becomeFirstResponder];
        
    }else if(textField == _passwordTF){
        
        [_passwordComfirmTF becomeFirstResponder];
        
    }else{
        
        [self.view endEditing:YES];
        if (_contentView.frame.origin.y == -20) {
            
            _contentView.center = CGPointMake(_contentView.center.x, _contentView.center.y + 40);
        }

        if ([self isBasiclyEnabledToRegister]) {
            [self judgeAndRegisterToServer];
        }
        
    }

    return YES;
}

#pragma mark - 动态检测输入格式是否正确
/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    
    if (![string isEqualToString:filtered])
        [LeafNotification showInController:self withText: @"请输入数字"];
    
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (_acountTF == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:11];
            
            [LeafNotification showInController:self withText: @"超过最大字数不能输入了"];
            
            return NO;
        }
    }
    
    
    return YES;
}

 */

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
