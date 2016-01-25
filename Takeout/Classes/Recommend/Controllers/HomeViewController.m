//
//  HomeViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-2.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "HeadImageWebViewController.h"
#import "PopUpView.h"
#import "HomeViewController.h"
#import "FoodDetailViewController.h"
#import "ConstValues.h"
#import "HomeHeadView.h"
#import "HomeFoodListView.h"
#import "FoodModel.h"
#import <AVOSCloud/AVOSCloud.h>

#import "OrderComfirmViewController.h"
#import "SettingViewController.h"
#import "FeedBackViewController.h"
#import "LoginViewController.h"


@interface HomeViewController ()<UIScrollViewDelegate>
{
    PopUpView *_popUpView;
    HomeHeadView *_headerView;
    
    UITableView *_tableView;
    NSMutableArray *_modelsArray;
    
    UIScrollView *_scrollView;
    NSMutableArray *_sectionBtnsArray;
    
    UIView *lineView;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


#pragma mark - 初始化  NavigationBar
-(void)initNavigationBar
{
    // leftTitle
    float y = 0;
    float height = 44;
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, height, height)];
    leftLabel.text = @"首页";
    leftLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE];
    leftLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:leftLabel];
    
    //right barbuttonitem
    height = height*3/5 + 2;
    y = height/5;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(CVScreenSize.width - height - 10, y, height, height);
    rightBtn.contentMode = UIViewContentModeScaleToFill;
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"navi_more_nor"] forState:0];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightBtn];
    
}

#pragma mark - 右上角弹出视图框,创建＋事件处理
-(void)rightBarButtonItemAction
{
    
    if (!_popUpView) {
        
        // rightBarButtonItem 弹出框  ,最后添加
        float x = CVScreenSize.width - CVTopRightFrameSize.width - 10;
        _popUpView = [[PopUpView alloc] initWithViewType:kPopUpView_Setting];
        _popUpView.frame = CGRectMake(x, 0, _popUpView.frame.size.width, _popUpView.frame.size.height);
        
        __block HomeViewController *hvc = self;
        __block PopUpView *popView = _popUpView;
        _popUpView.backSettingChoice = ^(NSString *choice){
            
            
            if ([choice isEqualToString:@"设置"]) {
                
                popView.hidden = YES;
                
                SettingViewController *svc = [[SettingViewController alloc] init];
                [hvc.navigationController pushViewController:svc animated:YES];
                
                
            }else if ([choice isEqualToString:@"反馈"]) {
                
                if ([AVUser currentUser]) {
                    
                    FeedBackViewController *fvc = [[FeedBackViewController alloc] init];
                    [hvc.navigationController pushViewController:fvc animated:YES];
                    
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未登录" delegate:hvc cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
                    [alertView show];
                }
                
            }else if ([choice isEqualToString:@"关于"]) {
                
            }else if ([choice isEqualToString:@"招商合作"]) {
                
            }
            
        };
        [self.view addSubview:_popUpView];
        _popUpView.hidden = YES;
    }
    
    _popUpView.hidden = _popUpView.isHidden ? NO:YES;
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}



#pragma mark - 初始状态，选中第一个 tabbaritem
-(void)initTabBar
{
    UIImage *image = [UIImage imageNamed:@"tabbar_home_nor"];
    UIImage *selectedImage = [UIImage imageNamed:@"tabbar_home_sel"];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"首页" image:image selectedImage:selectedImage];
    self.tabBarItem = item;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavigationBar];
    [self initTabBar];

    [self prepareHeadView];
    [self prepareFoodListView];
    
//    UITapGestureRecognizer *tapGsture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
//    [_scrollView addGestureRecognizer:tapGsture];
//
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
//    [_scrollView addGestureRecognizer:panGesture];
////    [self.view addGestureRecognizer:panGesture];
    
}

#pragma mark - 灵敏度低？,与左上角点击接收事件冲突,未解决
-(void)gestureAction:(UIGestureRecognizer *)gesture
{
    
//    if (gesture.view.) {
//        
//        
//    }
//    _popUpView.hidden = YES;
    
}


#pragma mark -  准备顶部视图   可否在block 中 push ？？？
-(void)prepareHeadView
{
    _headerView = [[HomeHeadView alloc] init];
    HomeViewController *hvc = self;
    
    _headerView.backImageChoice = ^(NSString *imageLinks){
        //  打开下一个网页
        HeadImageWebViewController *wvc = [[HeadImageWebViewController alloc] initWithWebUrl:imageLinks];
        [hvc.navigationController pushViewController:wvc animated:YES];
        
    };
    [self.view addSubview:_headerView];

    NSArray *array = [NSArray arrayWithObjects:@"推荐",@"其他", nil];

    float x = 0;
    float y = CGRectGetMaxY(_headerView.frame);
    float width = CVScreenSize.width/2;
    float height = 30;
    
    _sectionBtnsArray = [NSMutableArray array];
    
    UIButton *btn = nil;
    for (int i = 0; i < array.count; i++) {
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, width, height-1);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:CVMainTextColor forState:UIControlStateSelected];
        //btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = i == 0 ? YES:NO;
        [self.view addSubview:btn];
        [_sectionBtnsArray addObject: btn];
        x += width;
        
    }
    
    lineView = [[UIView alloc] initWithFrame: CGRectMake(0, CGRectGetMaxY(btn.frame), CVScreenSize.width, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    AVQuery *query = [AVQuery queryWithClassName:@"Pager"];
    [query whereKey:@"img" hasPrefix:CVHomeHeadImageUrl];
    
    // Sorts the results in ascending order by the score field
    [query orderByAscending:@"position"];
    
    NSMutableArray *imageUrlsArray = [NSMutableArray array];
    NSMutableArray *imageLinksArray = [NSMutableArray array];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (AVObject *obj in objects) {
            [imageUrlsArray addObject:[obj objectForKey:@"img"]];
            [imageLinksArray addObject:[obj objectForKey:@"data"]];
        }
        
        [_headerView setImageUrlsArray:imageUrlsArray linksArray:imageLinksArray];
    }];
    
}

#pragma mark 推荐，摇一摇  按钮事件，切换界面
-(void)btnClicked:(UIButton *)button
{
    for (UIButton *btn in _sectionBtnsArray) {
        btn.selected = NO;
    }
    button.selected = YES;
    
    int index = [_sectionBtnsArray indexOfObject:button];
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*index, 0);
}


#pragma mark - 推荐食物列表
-(void)prepareFoodListView
{
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFoodCellCliked:) name:@"didHomeFoodCellCliked" object:nil];
    
    float y = CGRectGetMaxY(lineView.frame);
    float width = CVScreenSize.width;
    float height = CVContentSize.height - y;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, width, height)];
    _scrollView.contentSize = CGSizeMake(2*width, height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    HomeFoodListView *homeFoodListView = [[HomeFoodListView alloc ] initWithFrame:CGRectMake(0,0, width, height) AndkFoodCellType:CVkFoodCellType_Home];
    [_scrollView addSubview:homeFoodListView];

    float sideOffset = 20;
    
    UIImageView *shakeView = [[UIImageView alloc] initWithFrame:CGRectMake(width + sideOffset , sideOffset, width - 2*sideOffset, height - 2*sideOffset)];
    shakeView.contentMode = UIViewContentModeScaleToFill;
    shakeView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_shake_hand" ofType:@"png"]];
    [_scrollView addSubview:shakeView];
    
    AVQuery *query = [AVQuery queryWithClassName:@"Food"];
    [query whereKey:@"recommend" equalTo:[NSNumber numberWithBool:YES]];
    [query orderByDescending:@"hot"];
    query.limit = 6;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSMutableArray *foodModelsArray = [NSMutableArray array];
        if (objects) {
            
            FoodModel *foodModel = nil;
            for (NSDictionary *foodDic in objects) {
                foodModel = [[FoodModel alloc] init];
                foodModel.foodID = [foodDic objectForKey:@"objectId"];
                foodModel.foodName = [foodDic objectForKey:@"name"];
                foodModel.foodPrice = [[foodDic objectForKey:@"price"] floatValue];
                foodModel.foodRestaurant = [foodDic objectForKey:@"restaurant"];
                foodModel.foodImgUrl = [foodDic objectForKey:@"img"];
                
                [foodModelsArray addObject:foodModel];
            }
            
            //[listView setModelsArray:foodModelsArray];
            //[self.view addSubview:listView];
            
            [homeFoodListView setFoodModelsArray:foodModelsArray];
            
        }else{
            NSLog(@"查询出错: \n%@", [error description]);
        }
    }];

    
    
}

#pragma mark - 通知中心触发，传入选中食物 ID
-(void)didFoodCellCliked:(NSNotification *)notification
{
    
    if ([notification.name  isEqualToString: @"didHomeFoodCellCliked"]) {
        FoodDetailViewController *foodDetailController = [[FoodDetailViewController alloc] initWithFoodID:notification.object];
        foodDetailController.view.frame = CGRectMake(0, CVNaviBarHeight, CVScreenSize.width, 300);
        
        OrderComfirmViewController *ovc = [[OrderComfirmViewController alloc] init];
        [self.navigationController addChildViewController:ovc];

        ovc.view.backgroundColor = [UIColor blackColor];
        ovc.view.frame = CGRectMake(0, 300, 320, 100);
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:ovc.view.bounds];
        bgImageView.image = [UIImage imageNamed:@"bg_shake_hand"];
        [ovc.view addSubview:bgImageView];
        
        [self.navigationController.view addSubview:ovc.view];
        //[foodDetailController.view addSubview:ovc.view];

        [self presentViewController:foodDetailController animated:YES completion:nil];
        //[self.navigationController pushViewController:foodDetailController animated:YES];
        //    [self.navigationController setToolbarHidden:NO animated:YES];
        //    [self.navigationController.toolbar setBarTintColor:[UIColor blackColor]];
        //[foodDetailController.view bringSubviewToFront:ovc.view];
        
        [self.navigationController.view bringSubviewToFront:ovc.view];
    }
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    UIButton *button = _sectionBtnsArray[index];
    
    for (UIButton *btn in _sectionBtnsArray) {
        btn.selected = NO;
    }
    
    button.selected = YES;
}

@end
