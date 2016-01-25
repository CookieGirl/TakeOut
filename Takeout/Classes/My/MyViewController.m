//
//  MyViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-2.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

enum
{
    HeadBtnTag_Order = 401,
    HeadBtnTag_Comment,
    HeadBtnTag_Favorite,
};

enum
{
    CenterBtnTag_Campus = 411,
    CenterBtnTag_DormitoryBuilding,
    CenterBtnTag_Dormitory,
    CenterBtnTag_Email,
    CenterBtnTag_ToLogin,
    CenterBtnTag_ModifyInfo,
    CenterBtnTag_Exit,
    
};

#import <AVOSCloud/AVOSCloud.h>
#import "MyViewController.h"
#import "ConstValues.h"
#import "LoginViewController.h"


@interface MyViewController ()<UIAlertViewDelegate>
{
    UILabel *_promptLabel;
    UILabel *_userNameLabel;
    UILabel *_nickNameLabel;
    UIImageView *_genderImgView;
    
    UILabel *_campusLabel;
    UILabel *_dormitoryBuildingLabel;
    UILabel *_dormitoryLabel;
    UILabel *_emailLabel;
    
    UIScrollView *_scrollView;
    
    UIAlertView *_alertView;
}
@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(UITabBarItem *)tabBarItem
{
    UIImage *image = [UIImage imageNamed:@"tabbar_my_nor"];
    UIImage *selectedImage = [UIImage imageNamed:@"tabbar_my_sel"];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"我的" image:image selectedImage:selectedImage];
    
    return item;
}

#pragma mark - 创建图片&以下视图
-(void)initView
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CVContentSize.width, CVContentSize.height)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    
    UIColor *btnColorNor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];

    float x = 0;
    float y = 0;
    float width = CVContentSize.width;
    float height = CVContentSize.height/3;
    
    UIImageView *headimageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    headimageView.contentMode = UIViewContentModeScaleToFill;
    headimageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sunrise" ofType:@"png"]];
    [_scrollView addSubview:headimageView];
    
    x = 20;
    y = height/4 + 5;
    width = 140;
    height = 40;
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.font = [UIFont systemFontOfSize:NAVI_FONTSIZE];
    _userNameLabel.text = @"12345678901";
    [headimageView addSubview:_userNameLabel];
    
    x += width + 5;
    height = height/2;
    y += height/2;
    _genderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, height, height)];
    _genderImgView.contentMode = UIViewContentModeScaleToFill;
    [headimageView addSubview:_genderImgView];
    
    x = CGRectGetMinX(_userNameLabel.frame);
    y = CGRectGetMaxY(_userNameLabel.frame);
    width = CVScreenSize.width - 2*x;
    height = CGRectGetHeight(_userNameLabel.frame);
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _nickNameLabel.font = [UIFont systemFontOfSize:NAVI_FONTSIZE - 2];
    _nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel.text = @"昵称";
    [headimageView addSubview:_nickNameLabel];
    
    height = CGRectGetHeight(headimageView.frame)*2/5;
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height, width, 20)];
    _promptLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE + 2];
    _promptLabel.text = @"亲，您还没有登录哦";
    _promptLabel.textColor = [UIColor whiteColor];
    
    [headimageView addSubview:_promptLabel];
    
    
    NSArray *imgsArray = [NSArray arrayWithObjects:@"ic_order",@"ic_comment",@"ic_favorite", nil];
    NSArray *btnTitlesArray = [NSArray arrayWithObjects:@"订单",@"评论",@"收藏" ,nil];
    UIButton *button = nil;
    
    
    float fontSize = 15;
    width = (CVScreenSize.width - 6)/3;
    height = 40;
    y = CGRectGetMaxY(headimageView.frame) - height/2;
    
    for (int i = 0; i < 3; i++) {
        
        x = (width + 3)*i;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, width, height);
        button.backgroundColor = btnColorNor;
        
        // 图片
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(width/4, height/4, height/2, height/2)];
        imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgsArray[i] ofType:@"png"]];
        [button addSubview:imgView];
        
        // 标题
        [button setTitle:btnTitlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, CGRectGetMaxX(imgView.frame) - 5, 5, 0);
        button.tag = HeadBtnTag_Order + i;
        [button addTarget:self action:@selector(headBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }
    
    
    NSArray *titlesArray = [NSArray arrayWithObjects:@"校  区",@"宿舍楼",@"寝室号",@"邮  箱", nil];
    width = CVScreenSize.width - 2*20;
    height = 35;
    float offsetY = (CVContentSize.height - CGRectGetMaxY(button.frame) - 5*height)/6;
    x = 20;
    y = CGRectGetMaxY(button.frame) + offsetY;

    for (int i = 0; i < 4; i++) {
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, width, height);
        button.backgroundColor = btnColorNor;
        
        // 创建 左边 label
        NSAttributedString *redIcon = [[NSAttributedString alloc] initWithString:@"| " attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:10],NSForegroundColorAttributeName:[UIColor redColor]}];
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:titlesArray[i] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize]}];
        [titleStr insertAttributedString:redIcon atIndex:0];
        
        UILabel *leftTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/4, height)];
        leftTitleLabel.attributedText = titleStr;
        leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        [button addSubview:leftTitleLabel];
        
        //创建button 上中间显示的具体内容
        [button setTitle:@"暂无" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, CGRectGetMaxX(leftTitleLabel.frame), 0, height);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //右边icon
        UIImageView *iconRightView = [[UIImageView alloc] initWithFrame:CGRectMake(width - height,0,height, height)];
        //iconRightView.backgroundColor = [UIColor blackColor];
        iconRightView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ic_arrow_right" ofType:@"png"]];
        iconRightView.contentMode = UIViewContentModeScaleToFill;
        [button addSubview:iconRightView];
        
        button.tag = CenterBtnTag_Campus + i;
        [button addTarget:self action:@selector(centerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:button];
        
        y += height + offsetY;
    }
    
    NSArray *arrayBtnsTitle = [NSArray arrayWithObjects:@"去登录",@"修改信息",@"退出", nil];
    
    for (int i = 0; i < 3; i++) {
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, width, height);
        button.backgroundColor = CVMainColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:arrayBtnsTitle[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        button.tag = CenterBtnTag_ToLogin + i;
        [button addTarget:self action:@selector(centerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:button];
        
        if (i == 1) {
            button.backgroundColor = [UIColor orangeColor];
            y += height + offsetY;
        }

    }
    
    button = (UIButton *)[_scrollView viewWithTag:CenterBtnTag_ToLogin];
    [_scrollView bringSubviewToFront:button];
    
}


#pragma mark - 头部三个按钮事件,订单，评论，收藏

-(void)headBtnClicked:(UIButton *)headButton
{
    if (![AVUser currentUser]) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [_alertView show];
        return;
    }
    
//    UIButton *btn = nil;
//    btn = (UIButton *)[_scrollView viewWithTag:CenterBtnTag_ModifyInfo];
//    btn.hidden = YES;
//    btn = (UIButton *)[_scrollView viewWithTag:CenterBtnTag_Exit];
//    btn.hidden = YES;
    
}

#pragma mark - 中部信息按钮事件，底部操作按钮事件

-(void)centerBtnClicked:(UIButton *)centerButton
{
    _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    
    if (![AVUser currentUser]) {
        _alertView.message =@"暂未登录";
        [_alertView addButtonWithTitle:@"去登录"];
        [_alertView show];
        return;
    }
    
    switch (centerButton.tag) {
            
        case CenterBtnTag_Campus:
            
            break;
            
        case CenterBtnTag_DormitoryBuilding:
            
            break;

        case CenterBtnTag_Dormitory:
            
            break;

        case CenterBtnTag_Email:
            
            break;

        case CenterBtnTag_ToLogin:
        {
            LoginViewController *lvc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:lvc animated:YES];
        }
            break;
            
        case CenterBtnTag_ModifyInfo:
        {
        
        }
            break;
            
        case CenterBtnTag_Exit:
        {
            _alertView.message =@"退出？";
            [_alertView addButtonWithTitle:@"确定"];
            [_alertView show];

        }
            break;

        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    UIButton *button = (UIButton *)[_scrollView viewWithTag:CenterBtnTag_ToLogin];
    
#pragma mark - 判断当前用户，改变呈现视图
    if ([AVUser currentUser]) {
        
        _scrollView.contentSize = CGSizeMake(CVContentSize.width, CVContentSize.height + CGRectGetHeight(button.frame) - 20);
        button.hidden = YES;
        //buttonExit.hidden = NO;
        
        _promptLabel.hidden = YES;
        _userNameLabel.hidden = NO;
        _nickNameLabel.hidden = NO;
        _genderImgView.hidden = NO;
        
        [self loadUserInfo];
 
    }else{
        
        _scrollView.contentSize = CGSizeMake(CVContentSize.width, CVContentSize.height - CGRectGetHeight(button.frame) - 20);
        button.hidden = NO;
        
        _promptLabel.hidden = NO;
        _userNameLabel.hidden = YES;
        _nickNameLabel.hidden = YES;
        _genderImgView.hidden = YES;
    }
    
}


#pragma mark - 加载用户信息
-(void)loadUserInfo
{
    AVUser *user = [AVUser currentUser];
    _userNameLabel.text = user.username;
    //_nickNameLabel.text = user objectForKey:@"nick"
    //_promptLabel.text = user.username;
    
    AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
    [userQuery whereKey:@"username" equalTo:user.username];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            
            NSDictionary *userDic = [objects firstObject];
            
            _nickNameLabel.text = [userDic objectForKey:@"nickname"];
            NSString *imgStr = [[userDic objectForKey:@"gender"] isEqualToString:@"男"] ? @"ic_gender_male":@"ic_gender_female";
            _genderImgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgStr ofType:@"png"]];
            
            NSString *campusStr = [userDic objectForKey:@"locale"];
            NSString *dormitoryBuildingStr = [userDic objectForKey:@"dormitory"];
            NSString *dormitoryStr = [userDic objectForKey:@"bedroom"];
            NSString *emailStr = [userDic objectForKey:@"email"];
            

            _campusLabel.text = campusStr == nil ? @"暂无":campusStr;
            _dormitoryBuildingLabel.text = dormitoryBuildingStr == nil ? @"暂无":dormitoryBuildingStr;
            _dormitoryLabel.text = dormitoryStr == nil ? @"暂无":dormitoryStr;
            _emailLabel.text = emailStr == nil ? @"暂无":emailStr;
            
            
        }else{
            
        
        }
        
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CVMainBgColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"我的资料";
    [self.navigationController.navigationBar addSubview:titleLabel];
    
    [self initView];
    
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"暂未登录"]) {
        if (buttonIndex == 1) {
            LoginViewController *lvc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:lvc animated:YES];
        }
        
    }else if ([alertView.message isEqualToString:@"退出？"]) {
        if (buttonIndex == 1) {
            [AVUser logOut];
            
            [self.view reloadInputViews];
        }
        
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
