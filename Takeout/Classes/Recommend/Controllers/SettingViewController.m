//
//  SettingViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-15.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

enum
{
    SettingBtnTag_CleanCash = 131,
    SettingBtnTag_SequenceType,
    SettingBtnTag_AutoCheck,
    SettingBtnTag_CheckNewVersion,
    SettingBtnTag_CheckBox,
};

#import "ConstValues.h"
#import "SettingViewController.h"
#import "NavigationView.h"


@interface SettingViewController ()
{
    NSArray *_titlesArr;
    NSArray *_subTitlesArr;
}
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titlesArr = [NSArray arrayWithObjects:@"清除缓存",@"搜索时默认排序方式",@"自动检测更更新",@"检查更新", nil];
        _subTitlesArr = [NSArray arrayWithObjects:@"删除手机上的文件和图片等",@"按价格排序",@" ",@"检查更新", nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CVMainBgColor;
    
    NavigationView *naviView = [[NavigationView alloc] init];
    [naviView setLeftButtonTitle:@"< 返回"];
    naviView.backBtnTag = ^(kMyNaviViewBtnTag btnTag){
        
        switch (btnTag) {
            case kBtnTag_Back:
            {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
        
    };
    
    [self.view addSubview:naviView];
    
    [self initView];
}

#pragma mark - 创建视图
-(void)initView
{
    UIButton *button = nil;
    float btnHeight = 65;
    float largeFontSize = NAVI_FONTSIZE - 1;
    float y = MyNaviViewHeight + 20;
    
    for (int i  = 0; i < _titlesArr.count; i++) {
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, y + i*btnHeight, CVScreenSize.width, CVScreenSize.height - MyNaviViewHeight);
       button.backgroundColor = CVMainBgColor;
       [self.view addSubview:button];
        
        button.tag = SettingBtnTag_CleanCash + i;
        [button addTarget:self action:@selector(settingChoiceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight - 1, CVScreenSize.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [button addSubview:lineView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CVScreenSize.width - 10, btnHeight/2)];
        titleLabel.text = _titlesArr[i];
        titleLabel.font = [UIFont boldSystemFontOfSize:largeFontSize];
        [button addSubview:titleLabel];
        
        if (i == 2) {
            titleLabel.frame = CGRectMake(10, 0, CVScreenSize.width - 10, btnHeight);
            
            float boxHeight =  btnHeight/2;
            UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
            checkBox.frame = CGRectMake(CVScreenSize.width - boxHeight*3/2, boxHeight/2, boxHeight, boxHeight);
            [checkBox setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checkbox_unchecked" ofType:@"png"]] forState:0];
            [checkBox setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checkbox_checked" ofType:@"png"]] forState:UIControlStateSelected];
            checkBox.tag = SettingBtnTag_CheckBox;
            checkBox.userInteractionEnabled = NO;
            //[checkBox addTarget:self action:@selector(checkBoxAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:checkBox];
            
            continue;
        }
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, btnHeight/2, CVScreenSize.width - 10, btnHeight/2 - 1)];
        subTitleLabel.text = _subTitlesArr[i];
        subTitleLabel.font = [UIFont systemFontOfSize:largeFontSize - 2];
        [button addSubview:subTitleLabel];
        
        
    }
    
}

-(void)settingChoiceBtnClicked:(UIButton *)button
{
    switch (button.tag) {
            
        case SettingBtnTag_CleanCash:
        {
            
        }
            break;
            
        case SettingBtnTag_SequenceType:
        {
            
        }
            break;
            
        case SettingBtnTag_AutoCheck:
        {
            UIButton *checkBoxBtn = (UIButton *)[self.view viewWithTag:SettingBtnTag_CheckBox];
            checkBoxBtn.selected = !checkBoxBtn.selected;
        }
            break;
            
        case SettingBtnTag_CheckNewVersion:
        {
            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -  复选框事件处理
-(void)checkBoxAction:(UIButton *)button
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
