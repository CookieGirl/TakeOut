//
//  RestaurantFoodViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-6.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

enum
{
    barBtnTag_Back = 290,
    barBtnTag_Detail ,
};

#define SegmentControlHeight  40
#define RestaurantName_FontSize 18

#import "CommentViewController.h"
#import "HomeFoodListView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "RestaurantFoodViewController.h"
#import "ConstValues.h"
#import "FoodModel.h"
#import "FoodDetailViewController.h"
#import "RestaurantDetailView.h"
#import "RestaurantModel.h"


@interface RestaurantFoodViewController ()<UIScrollViewDelegate>
{
    NSString *_restaurantID;
    
    UILabel *_restaurantNameLabel;
    UILabel *_sendAreaLabel;
    RestaurantDetailView *_detailView;
    
    NSMutableArray *_recommendModelsArray;
    NSMutableArray *_rank0ModelsArray;
    NSMutableArray *_rank1ModelsArray;
    NSMutableArray *_rank2ModelsArray;
    NSMutableArray *_rank3ModelsArray;
    
    NSMutableArray *_allModelsArray;
    //int segmentCount ;
    UISegmentedControl *_segmentedCtrl;
    UILabel *_moveLabel;
    UIScrollView *_scrollView;
    
    NSString *_priceRecommend;
    NSString *_priceRank0 ;
    NSString *_priceRank1;
    NSString *_priceRank2;
    NSString *_priceRank3;
    
    NSMutableArray *_segmentTitlesArray;
}
@end

@implementation RestaurantFoodViewController


-(id)initWithRestaurantID:(NSString *)restaurantID
{
    if (self = [super init]) {
        _restaurantID = restaurantID;
        
        _recommendModelsArray = [NSMutableArray array];
        _rank0ModelsArray = [NSMutableArray array]; // < 8
        _rank1ModelsArray = [NSMutableArray array]; // >=8 <10
        _rank2ModelsArray = [NSMutableArray array]; // >=10 < 15
        _rank3ModelsArray = [NSMutableArray array]; //  >= 15
        
        _priceRecommend = @"推荐";
        _priceRank0 = @"7以下";
        _priceRank1 = @"8-10";
        _priceRank2 = @"11-15";
        _priceRank3 = @"16以上";
        
        _segmentTitlesArray = [NSMutableArray array];
        
        _allModelsArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 顶部导航条
-(UIView *)createHeadView//WithRestaurantName:(NSString *)restaurantName AndSendArea:(NSString *)sendArea
{
    
    //  主视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CVScreenSize.width, HeadBarHeight)];
    view.backgroundColor = CVMainColor;
    [self.view addSubview:view];
    
    // 子视图 icon
    UIButton *iconBtnBack = [[UIButton alloc] initWithFrame:CGRectMake(-5, +5, HeadBarHeight - 5, HeadBarHeight -10)];
    NSString *iconBackPath = [[NSBundle mainBundle] pathForResource:@"ic_arrow_left" ofType:@"png"];
    [iconBtnBack setBackgroundImage:[UIImage imageWithContentsOfFile:iconBackPath] forState:UIControlStateNormal];
    iconBtnBack.tag = barBtnTag_Back;
    [iconBtnBack addTarget:self action:@selector(headBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:iconBtnBack];
    
    float x = CGRectGetMaxX(iconBtnBack.frame) + 5;
    float width = view.frame.size.width - 2*CGRectGetWidth(iconBtnBack.frame) - 10;
    // 添加标签
    _restaurantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0,width, HeadBarHeight*5/9)];
    _restaurantNameLabel.textColor = [UIColor whiteColor];
    _restaurantNameLabel.font = [UIFont boldSystemFontOfSize:RestaurantName_FontSize];
    _restaurantNameLabel.text = @"店名"; // restaurantName;
    [view addSubview:_restaurantNameLabel];
    
    _sendAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(_restaurantNameLabel.frame), width, HeadBarHeight*4/9)];
    _sendAreaLabel.textColor = [UIColor whiteColor];
    //_sendAreaLabel.backgroundColor = [UIColor blackColor];
    _sendAreaLabel.font = [UIFont boldSystemFontOfSize:RestaurantName_FontSize - 5];
    _sendAreaLabel.text = @"派送区"; // sendArea;
    [view addSubview:_sendAreaLabel];

    UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDetail.frame = CGRectMake(CGRectGetMaxX(_sendAreaLabel.frame), 5, CGRectGetWidth(iconBtnBack.frame), CGRectGetHeight(iconBtnBack.frame));
    [btnDetail setTitle:@"详情" forState:UIControlStateNormal];
    [btnDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDetail.tag = barBtnTag_Detail;
    [btnDetail addTarget:self action:@selector(headBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnDetail];
    
    return view;
}

#pragma mark - 导航条按钮事件:返回，详情
-(void)headBarBtnClicked:(UIButton *)button
{
    switch (button.tag) {
        case barBtnTag_Back:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case barBtnTag_Detail:
        {
            float offsetX = CGRectGetWidth(_detailView.frame);
            
            offsetX = (_detailView.center.x > CVScreenSize.width)? -offsetX: offsetX;
            NSLog(@"%f",offsetX);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            //[UIView setAnimationDelegate:self];
            _detailView.center = CGPointMake(_detailView.center.x+offsetX, _detailView.center.y);
            [UIView commitAnimations];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark -   左边隐藏的视图

-(void)createDetailView
{
    _detailView = [[RestaurantDetailView alloc] initWithOrignPoint:CGPointMake(CVScreenSize.width, HeadBarHeight+20)]; //AndCommentCount:objects.count];
    _detailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailView];

    __block NSString *restaurantID = _restaurantID;
    __block RestaurantFoodViewController *restVC = self;
    
    _detailView.backBtnTag = ^(int btnTag,NSString *teleString){
        
        if (btnTag == DetailBtnTag_Comment) {
            
            CommentViewController *cvc = [[CommentViewController alloc] initWithRestaurantID:restaurantID];
            [restVC.navigationController pushViewController:cvc animated:YES];
            
        }else{
            
            NSString *telephoneStr = [NSString stringWithFormat:@"tel://%@",teleString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneStr]];
        }
    };
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    if (_detailView && _detailView.frame.origin.x < CVScreenSize.width) {
        
        float offsetX = CGRectGetWidth(_detailView.frame);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        _detailView.center = CGPointMake(_detailView.center.x+offsetX, _detailView.center.y);
        [UIView commitAnimations];
    }
    
}

#pragma mark - 视图将要出现
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CVMainBgColor;
    
    // 顶部导航条
    UIView *view = [self createHeadView];
    view.frame = CGRectMake(0, 20, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    [self.view addSubview:view];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFoodCellCliked:) name:@"didRestaurantFoodCellCliked" object:nil];
    
    [self createDetailView];

    [self loadData];

}

#pragma mark - 通知中心触发，传入选中食物 ID
-(void)didFoodCellCliked:(NSNotification *)notification
{
    FoodDetailViewController *foodDetailController = [[FoodDetailViewController alloc] initWithFoodID:notification.object];
    [self presentViewController:foodDetailController animated:YES completion:nil];
    
    NSLog(@"%@",notification.object);
}


#pragma mark - 加载数据 ： 导航条 ＋ 食物列表 + 侧边店铺详情
-(void)loadData
{

#pragma mark - 食物列表数据
    // 食物列表
    AVQuery *query = [AVQuery queryWithClassName:@"Food"];
    [query whereKey:@"restaurantId" equalTo:_restaurantID];
    [query orderByAscending:@"price"];
    //query.limit = 6;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects) {
            FoodModel *foodModel = nil;
            NSMutableArray *foodModelsArray = nil;
            for (NSDictionary *foodDic in objects) {
                
                foodModel = [[FoodModel alloc] init];
                foodModel.foodID = [foodDic objectForKey:@"objectId"];
                foodModel.foodImgUrl = [foodDic objectForKey:@"img"];
                foodModel.foodRank = [[foodDic objectForKey:@"rank"] intValue];
                foodModel.foodPrice = [[foodDic objectForKey:@"price"] floatValue];

                foodModel.foodName = [foodDic objectForKey:@"name"];
                foodModel.foodRestaurant = [foodDic objectForKey:@"restaurant"];
                foodModel.soldAmount = [[foodDic objectForKey:@"hot"] intValue];
            
                // [foodDic objectForKey:@"specialty"]||([[foodDic objectForKey:@"favorites"] intValue] >= 5 && [[foodDic objectForKey:@"hot"] intValue] >= 5)
                if ([[NSNumber numberWithBool:YES] isEqual:[foodDic objectForKey:@"recommend"]] || [[foodDic objectForKey:@"hot"] intValue] >= 5) {
                    [_recommendModelsArray addObject:foodModel];
                    if (![_segmentTitlesArray containsObject:_priceRecommend]) {
                        [_segmentTitlesArray addObject:_priceRecommend];
                    }
                }

                switch (foodModel.foodRank) {
                    case 0:
                        foodModelsArray = _rank0ModelsArray;
                        if (![_segmentTitlesArray containsObject:_priceRank0]) {
                            [_segmentTitlesArray addObject:_priceRank0];
                        }
                        break;
                        
                    case 1:
                        foodModelsArray = _rank1ModelsArray;
                        if (![_segmentTitlesArray containsObject:_priceRank1]) {
                            [_segmentTitlesArray addObject:_priceRank1];
                        }
                        break;
                        
                    case 2:
                        foodModelsArray = _rank2ModelsArray;
                        if (![_segmentTitlesArray containsObject:_priceRank2]) {
                            [_segmentTitlesArray addObject:_priceRank2];
                        }
                        break;
                        
                    case 3:
                        foodModelsArray = _rank3ModelsArray;
                        if (![_segmentTitlesArray containsObject:_priceRank3]) {
                            [_segmentTitlesArray addObject:_priceRank3];
                        }
                        break;
                        
                    default:
                        break;
                        
                }
                
                [foodModelsArray addObject:foodModel];
                
            }
            
#pragma mark - 加载完数据后，创建segment,listView 的个数,详情页面最后加
            
            [self createCenterView];
            [self.view bringSubviewToFront:_detailView];
            
        }else{
            NSLog(@"查询出错: \n%@", [error description]);
        }
    }];
    
    
#pragma mark - 店铺详情数据
    //  店铺详情数据
    RestaurantModel *restaurantModel = [[RestaurantModel alloc] init];
    
    // 导航条数据 + 店铺详情
    AVQuery *queryRestaurant = [AVQuery queryWithClassName:@"Restaurant"];
    [queryRestaurant whereKey:@"objectId" equalTo:_restaurantID];
    [queryRestaurant findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSDictionary *restaurantDic = [objects firstObject];
        // 导航条数据
        _restaurantNameLabel.text = [restaurantDic objectForKey:@"name"];
        _sendAreaLabel.text = [restaurantDic objectForKey:@"area"];
        
        restaurantModel.restaurantName = [restaurantDic objectForKey:@"name"];
        restaurantModel.restaurantDetail = [restaurantDic objectForKey:@"details"];
        restaurantModel.KeyWords = [restaurantDic objectForKey:@"keywords"];
        restaurantModel.telephone1 = [restaurantDic objectForKey:@"tel1"];
        restaurantModel.telephone2 = [restaurantDic objectForKey:@"tel2"];
        restaurantModel.businessTime = [restaurantDic objectForKey:@"businessTime"];
        restaurantModel.others = [restaurantDic objectForKey:@"others"];
        restaurantModel.address = [restaurantDic objectForKey:@"address"];
        
        //NSLog(@"%@==%@==%@",restaurantModel.restaurantDetail,restaurantModel.address,restaurantModel.others);
        
        AVQuery *queryComment = [AVQuery queryWithClassName:@"Comment"];
        [queryComment whereKey:@"restaurantId" equalTo:_restaurantID];
        [queryComment findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects)
                restaurantModel.commentCount = objects.count;
            
            [_detailView setRestaurantDetailModel:restaurantModel];
            
        }];
        
    }];
    
    
}


#pragma mark - 创建 CenterView :segmentedCtrl + foodlistView
-(void)createCenterView
{
    if ([_segmentTitlesArray containsObject:_priceRecommend]) {
        [_segmentTitlesArray removeObject:_priceRecommend];
        [_segmentTitlesArray insertObject:_priceRecommend atIndex:0];
    }
    
    _segmentedCtrl = [[UISegmentedControl alloc] initWithItems:_segmentTitlesArray];
    _segmentedCtrl.frame = CGRectMake(-1, 20 + HeadBarHeight, CVScreenSize.width+2, SegmentControlHeight);
    _segmentedCtrl.tintColor = CVMainBgColor;
    _segmentedCtrl.backgroundColor = CVMainBgColor;
    _segmentedCtrl.momentary = YES;
    _segmentedCtrl.multipleTouchEnabled = NO;
    [_segmentedCtrl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [_segmentedCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName: CVMainColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:NAVI_FONTSIZE]} forState:UIControlStateNormal];
    [self.view addSubview:_segmentedCtrl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentedCtrl.frame), CVScreenSize.width, 1)];
    lineView.backgroundColor = CVMainColor;
    [self.view addSubview:lineView];
    
    _moveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), CVScreenSize.width/_segmentTitlesArray.count, 3)];
    _moveLabel.backgroundColor = CVMainColor;
    [self.view addSubview:_moveLabel];
    
    // 创建 foodlistView
    float x = 0;
    float y = CGRectGetMaxY(_moveLabel.frame);
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, CVScreenSize.width, CVScreenSize.height - y)];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * _segmentTitlesArray.count, CGRectGetHeight(_scrollView.frame));
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < _segmentTitlesArray.count; i++) {
        
        x = i*CGRectGetWidth(_scrollView.frame);
        
        HomeFoodListView *listView = [[HomeFoodListView alloc] initWithFrame:CGRectMake(x, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) AndkFoodCellType:CVkFoodCellType_Restaturant];
        [self.view addSubview:listView];
        
        if ([_priceRecommend isEqualToString:_segmentTitlesArray[i]])
            [listView setFoodModelsArray:_recommendModelsArray];
        
        else if ([_priceRank0 isEqualToString:_segmentTitlesArray[i]])
            [listView setFoodModelsArray:_rank0ModelsArray];
        
        else if ([_priceRank1 isEqualToString:_segmentTitlesArray[i]])
            [listView setFoodModelsArray:_rank1ModelsArray];
        
        else if ([_priceRank2 isEqualToString:_segmentTitlesArray[i]])
            [listView setFoodModelsArray:_rank2ModelsArray];
        
        else if ([_priceRank3 isEqualToString:_segmentTitlesArray[i]])
            [listView setFoodModelsArray:_rank3ModelsArray];
        
        [_scrollView addSubview:listView];
        
    }
}

#pragma SegmentedControlAction  触发事件: 选择不同的段，滑动到不同位置

-(void)segmentedControlAction:(UISegmentedControl *)segmentedControl
{
    
    float x = segmentedControl.selectedSegmentIndex * CGRectGetWidth(_scrollView.frame);
    CGRect rect = CGRectMake(x, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    [_scrollView scrollRectToVisible:rect animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        float centerX = segmentedControl.selectedSegmentIndex*_moveLabel.frame.size.width +_moveLabel.frame.size.width/2;
        _moveLabel.center = CGPointMake(centerX, _moveLabel.center.y);
        
    }];
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    CGSize size = scrollView.frame.size;
    float index = fabs(point.x/size.width);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        float centerX = index*_moveLabel.frame.size.width +_moveLabel.frame.size.width/2;
        _moveLabel.center = CGPointMake(centerX, _moveLabel.center.y);
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
