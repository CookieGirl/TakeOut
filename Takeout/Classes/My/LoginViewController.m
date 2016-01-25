//
//  LoginViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-9.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#define HeadViewHeight 40

enum
{
    BtnTag_Login = 451,
    BtnTag_ForgetPassword,
    BtnTag_ToRegister,
    BtnTag_Back,
};

#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"
#import "ConstValues.h"
#import "RegisterViewController.h"
#import "ZipArchive.h"
#import "AFNetworking.h"

@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *_acountTF;
    UITextField *_passwordTF;
    
    //UIView *_centerView;
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


#pragma mark - 返回栏视图
-(void)initHeadView
{
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
    [backBtn addTarget:self action:@selector(btnsClicked:) forControlEvents:UIControlEventTouchUpInside];
    //backBtn.backgroundColor = [UIColor grayColor];
    [headView addSubview:backBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y+HeadViewHeight-1, CVScreenSize.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.view addSubview:lineView];
}

#pragma mark - 创建视图
-(void)initCenterView
{
    float width = CVScreenSize.width*7/10;
    float height = 40;
    float x = (CVScreenSize.width - width)/2;
    float y = self.view.frame.size.height/3 - 20;
    
    //  账户
    _acountTF = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _acountTF.backgroundColor = [UIColor whiteColor];
    _acountTF.layer.cornerRadius = 8;
    _acountTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _acountTF.layer.borderWidth = 0.5;
    _acountTF.placeholder = @"请输入手机号";
    _acountTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _acountTF.keyboardType = UIKeyboardTypeNumberPad;
    _acountTF.keyboardAppearance = UIKeyboardAppearanceDark;
    _acountTF.returnKeyType = UIReturnKeyNext;
    _acountTF.delegate = self;
    [self.view addSubview:_acountTF];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, height+10, height)];
    leftLabel.text = @"账号";
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.textColor = CVMainColor;
    _acountTF.leftView = leftLabel;
    _acountTF.leftViewMode = UITextFieldViewModeAlways;
    
    //  密码
    y += height +10;
    
    _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _passwordTF.backgroundColor = [UIColor whiteColor];
    _passwordTF.layer.cornerRadius = 8;
    _passwordTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _passwordTF.layer.borderWidth = 0.5;
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.secureTextEntry = YES;
    _passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _passwordTF.keyboardAppearance = UIKeyboardAppearanceDark;
    _passwordTF.returnKeyType = UIReturnKeyDone;
    _passwordTF.delegate = self;
    [self.view addSubview:_passwordTF];
    
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, height+10, height)];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.text = @"密码";
    leftLabel.textColor = CVMainColor;
    _passwordTF.leftView = leftLabel;
    _passwordTF.leftViewMode = UITextFieldViewModeAlways;

    width /= 2;
    x += width/2;
    y += height*2;
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(x, y, width, height);
    loginBtn.layer.cornerRadius = 8;
    loginBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    loginBtn.layer.borderWidth = 0.8;
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:CVMainColor forState:UIControlStateNormal];
    loginBtn.tag = BtnTag_Login;
    [loginBtn addTarget:self action:@selector(btnsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    width = 110;
    height = 20;
    x = 0;
    y = self.view.frame.size.height - height - 10;
    // 最下方
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(x, y, width, height);
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    bottomBtn.tag = BtnTag_ForgetPassword;
    [bottomBtn addTarget:self action:@selector(btnsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    
    x = self.view.frame.size.width - width;
    bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(x, y, width, height);
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    bottomBtn.tag = BtnTag_ToRegister;
    [bottomBtn addTarget:self action:@selector(btnsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
}

#pragma mark - 按钮事件
-(void)btnsClicked:(UIButton *)button
{
    NSLog(@"%d",button.tag);
    switch (button.tag) {
            
        case BtnTag_Login:
        {
            [self loginClick];
        }
            break;
            
        case BtnTag_ForgetPassword:
            
            break;
            
        case BtnTag_ToRegister:
        {
            RegisterViewController *rvc = [[RegisterViewController alloc] init];
            [self presentViewController:rvc animated:YES completion:nil];
            
        }
            break;
            
        case BtnTag_Back:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 登录事件
/**
 *登陆
 */
-(void)loginClick
{
    
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [AVUser logInWithUsernameInBackground:_acountTF.text password:_passwordTF.text block:^(AVUser *user, NSError *error) {
        
        NSString *str;
        
        if (user) {
            alert.title = nil;
            alert.message = @"登陆成功";
            alert.delegate = self;
            [alert show];
            
            NSString* path=[NSString stringWithFormat:@"%@/Documents/userInfo.plist",NSHomeDirectory()];
            NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:path];
            //NSLog(@"~~%@",dic);
            
            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
            [user setObject:@(YES) forKey:@"status"];
            [user synchronize];
            
            ZipArchive *manager =[ZipArchive shareManager];
            [manager.dic setObject:_acountTF.text forKey:@"username"];
            [manager.dic setObject:_passwordTF.text forKey:@"password"];
            [manager synchronize];
        
            str = [NSString stringWithFormat:@"当前用户 %@",[[AVUser currentUser] username]];
            //  创建
            ///[UserModel createUserWithUserName:_acountTF.text AndPassword:_passwordTF.text];
            
            AVUser *currentUser = [AVUser currentUser];
            currentUser.username = _acountTF.text;
            currentUser.password = _passwordTF.text;
            [currentUser setObject:_acountTF.text forKey:@"nickname"];
            
//            [currentUser setValue:_acountTF.text forKey:@"userName"];
//            [currentUser setValue:_passwordTF.text forKey:@"password"];
            
           //[self.navigationController popToRootViewControllerAnimated:YES];
            
            //[self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            switch (error.code) {
                    
                case 210:
                {
                    [self lockAnimationForView:_passwordTF];
                    alert.message = @"密码不正确";
                    [alert show];
                }
                    break;
                    
                case 211:
                {
                    [self lockAnimationForView:_acountTF];
                    alert.message = @"该用户不存在";
                    [alert show];
                }
                    break;
                    
                default:
                    break;
            }
            
            //str =[NSString stringWithFormat:@"登陆出错 %@",[error description]];
        }
        
        
    }];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //if ([alertView.message isEqualToString:@"登陆成功"])
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


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


#pragma mark - navigationBarHidden，tabBar 隐藏
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, CVContentSize.width, CVScreenSize.height - 20)];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_bg" ofType:@"png"]];
    [self.view addSubview:bgImageView];
    
    [self initCenterView];
    
    [self initHeadView];

}


#pragma mark - 收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
