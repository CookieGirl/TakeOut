//
//  ImgSearchResultViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-10.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

enum
{
    sectionBtnTag_Origin = 300,
};

#import "FoodDetailViewController.h"
#import "ConstValues.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ImgSearchResultViewController.h"
#import "FoodModel.h"
#import "ImgSearchResultTableViewCell.h"
#import "ImgSearchRetTreeModel.h"

@interface ImgSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    //NSMutableArray *_restaurantNamesArray;
    //NSMutableArray *_foodModelsArray;
    NSMutableArray *_sectionArray;
    
    NSString *_keywords;
}
@end

@implementation ImgSearchResultViewController

-(id)initWithKeyWords:(NSString *)keyWords
{
    self = [super init];
    if (self) {
        
        //_restaurantNamesArray = [NSMutableArray array];
        //_foodModelsArray = [NSMutableArray array];
        _sectionArray = [NSMutableArray array];
        _keywords = keyWords;
        
    }
    return self;
}

#pragma mark - 查询关键字，准备数据源
-(void)searchKeyWords:(NSString *)keywords
{
    //NSLog(@"////%@////",keywords);
    AVQuery *query = [AVQuery queryWithClassName:@"Food"];
    [query whereKey:@"name" containsString:keywords];
    [query orderByDescending:@"restaurant"];
    //query.limit = 6;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
#pragma mark -  自己总结的正确判断格式！！！ 判断 count
        if (objects.count > 0) {

            ImgSearchRetTreeModel *treeModel = nil;
            FoodModel *foodModel = nil;
            NSMutableArray *foodsArray = [NSMutableArray array];
            static NSString *restaurantName = @"";
            
            for (NSDictionary *foodDic in objects) {
                
                foodModel = [[FoodModel alloc] init];
                treeModel = [[ImgSearchRetTreeModel alloc] init];
                
                foodModel.foodRestaurant = [foodDic objectForKey:@"restaurant"];
                foodModel.foodID = [foodDic objectForKey:@"objectId"];
                foodModel.foodName = [foodDic objectForKey:@"name"];
                foodModel.soldAmount = [[foodDic objectForKey:@"hot"] intValue];
                foodModel.favouriteAmmount = [[foodDic objectForKey:@"favorites"] intValue];
                foodModel.foodPrice = [[foodDic objectForKey:@"price"] floatValue];
                
                [foodsArray addObject:foodModel];
            
                if (![foodModel.foodRestaurant isEqualToString:restaurantName]) {
                    
                    treeModel.sectionFoodsArray = foodsArray;
                    treeModel.restaurantName = foodModel.foodRestaurant;
                    
                    [_sectionArray addObject:treeModel];
                    restaurantName = foodModel.foodRestaurant;
                    [foodsArray removeAllObjects];
                }
                
                //[_foodModelsArray addObject:foodModel];
                NSLog(@"==%@==",_sectionArray);
            }
            
            [_tableView reloadData];
            
        }else if(objects.count < 1){
            
            NSLog(@"没有找到相关数据");
            
        }else{
        
            NSLog(@"查询出错");
        }
        
    }];
}

#pragma mark - 准备视图 
-(void)prepareTableView
{
    float x = 0;
    float y = CVNaviBarHeight;
    float width = CVScreenSize.width;
    float height = CVScreenSize.height - CVNaviBarHeight;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(x, y, width, height) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

    //_tableView.backgroundColor = [UIColor grayColor];
    _tableView.separatorInset = UIEdgeInsetsMake(10, 0, 10, 0);
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CVMainBgColor;
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, CVScreenSize.width, 44)];
    naviView.backgroundColor = CVMainColor;
    [self.view addSubview:naviView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 0, 70, 44);
    [backBtn setTitle:@"< 返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    [self prepareTableView];
    [self searchKeyWords:_keywords];
    
}

-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _sectionArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float height = 40;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, CVScreenSize.width, height);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ic_expand_arrow_nor" ofType:@"png"]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ic_collapse_arrow_sel" ofType:@"png"]] forState:UIControlStateSelected];
    float imgHeight = 20;
    [button setImageEdgeInsets:UIEdgeInsetsMake((height - imgHeight)/2, 5, (height - imgHeight)/2, CVScreenSize.width - imgHeight - 5)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, CVScreenSize.width - 30, height - 5)];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = CVMainColor;
    [button addSubview:titleLabel];
    button.tag = sectionBtnTag_Origin + section;
    [button addTarget:self action:@selector(sectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    ImgSearchRetTreeModel *treeModel = [_sectionArray objectAtIndex:section];
    titleLabel.text = treeModel.restaurantName ;
    
    //button.backgroundColor = [UIColor lightGrayColor];// 删除
    
    return button;
}

#pragma mark - 按钮事件触发  有问题
-(void)sectionBtnClicked:(UIButton *)button
{
    int section = button.tag - sectionBtnTag_Origin;
    
    //  有误
//    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:section];
//    //[_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
//    [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    ImgSearchRetTreeModel *treeModel = [_sectionArray objectAtIndex:section];
    treeModel.isOpen = !treeModel.isOpen;
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex: section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
    button.selected = !button.selected;//有问题
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ImgSearchRetTreeModel *treeModel = [_sectionArray objectAtIndex:section];
    
    if (treeModel.isOpen)
        return treeModel.sectionFoodsArray.count;
    else
        return 0;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cellID";
    
    ImgSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[ImgSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    
    ImgSearchRetTreeModel *treeModel = [_sectionArray objectAtIndex:indexPath.section];
    
    if (treeModel.sectionFoodsArray.count > indexPath.row) {
        
        FoodModel *foodModel = [treeModel.sectionFoodsArray objectAtIndex:indexPath.row];
        [cell setFoodModel:foodModel];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImgSearchRetTreeModel *treeModel = _sectionArray[indexPath.section];
    FoodModel *foodModel = nil;
    
    if ( treeModel.sectionFoodsArray.count > indexPath.row)
        foodModel = [treeModel.sectionFoodsArray objectAtIndex:indexPath.row];
    
    FoodDetailViewController *fvc = [[FoodDetailViewController alloc] initWithFoodID:foodModel.foodID];

    [self presentViewController:fvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
