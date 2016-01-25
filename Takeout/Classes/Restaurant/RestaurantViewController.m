//
//  RestaurantViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-2.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RestaurantTableViewCell.h"
#import "RestaurantModel.h"
#import "ConstValues.h"
#import "RestaurantFoodViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface RestaurantViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_modelsArray;
}
@end

@implementation RestaurantViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _modelsArray = [NSMutableArray array];
        
    }
    return self;
}

-(UITabBarItem *)tabBarItem
{
    UIImage *image = [UIImage imageNamed:@"tabbar_more_nor"];
    UIImage *selectedImage = [UIImage imageNamed:@"tabbar_more_sel"];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"店铺" image:image selectedImage:selectedImage];
    
    return item;
}

-(void)prepareDataSource
{
    AVQuery *query = [AVQuery queryWithClassName:@"Restaurant"];
    [query whereKeyExists:@"objectId"];
    [query orderByAscending:@"name"];
    //query.limit = 6;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects) {
            
            RestaurantModel *restaurantModel = nil;
            for (NSDictionary *restaurantDic in objects) {
                restaurantModel = [[RestaurantModel alloc] init];
                restaurantModel.restaurantImgUrl = [restaurantDic objectForKey:@"img"];
                restaurantModel.restaurantID = [restaurantDic objectForKey:@"objectId"];
                restaurantModel.restaurantName = [restaurantDic objectForKey:@"name"];
                restaurantModel.restaurantLocale = [restaurantDic objectForKey:@"locale"];
                restaurantModel.KeyWords = [restaurantDic objectForKey:@"keywords"];
                restaurantModel.businessTime = [restaurantDic objectForKey:@"businessTime"];
                
                [_modelsArray addObject:restaurantModel];
            }
            
            [_tableView reloadData];
            
        }else{
            NSLog(@"查询出错: \n%@", [error description]);
        }
    }];
    

}

/**
 *  初始化视图
 */
#pragma mark - 创建 UITableView
-(void)prepareTableView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_big"]];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , CVScreenSize.width, CVScreenSize.height - CVNaviBarHeight - CVTabbarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    //_tableView.backgroundColor = [UIColor blackColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView.hidden = YES;
    //_tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

/**
 *  视图将要出现
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float y = 0;
    float height = 44;
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, height)];
    leftLabel.text = @"店铺列表";
    leftLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE];
    leftLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:leftLabel];
    
    [self performSelectorOnMainThread:@selector(prepareTableView) withObject:nil waitUntilDone:YES];
    [self prepareDataSource];
    
}


#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CVRestaurantViewSize.height +20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cellID";
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    
    if (!cell) {
        cell = [[RestaurantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
#pragma mark - block 回传 restaurantID ，push 饭店详情界面
        cell.backRestaurantID = ^(NSString *restaurantID){
            
            RestaurantFoodViewController *restaurantVC = [[RestaurantFoodViewController alloc] initWithRestaurantID:restaurantID];
            [self.navigationController pushViewController:restaurantVC animated:YES];
            //[self presentViewController:restaurantVC animated:YES completion:nil];
            
        };
    }
    
    RestaurantModel *model = [_modelsArray objectAtIndex:indexPath.row];
    [cell setRestaurantModel:model];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
