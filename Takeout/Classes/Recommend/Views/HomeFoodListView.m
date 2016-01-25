//
//  HomeFoodListView.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-3.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "HomeFoodListView.h"
#import "HomeFoodListTableViewCell.h"
#import "FoodModel.h"

@interface HomeFoodListView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    NSMutableArray *_leftModelsArray;
    NSMutableArray *_rightModelsArray;
    
    HomeFoodListTableViewCell *_selectedCell ;
    
    CVkFoodCellType _kFoodCellType;
}
@end

@implementation HomeFoodListView

static NSString *cellIde = @"cellID";

- (id)initWithFrame:(CGRect)frame AndkFoodCellType:(CVkFoodCellType) kFoodCellType
{
    _kFoodCellType = kFoodCellType;
    self = [super initWithFrame:frame];
    if (self) {
        
        _leftModelsArray = [NSMutableArray array];
        _rightModelsArray = [NSMutableArray array];
        
        //float offsetX = 3;
        float x = 0;
        float y = 0 ;
        float width = frame.size.width/2.0;
        float height = frame.size.height;
        
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(x, y, width, height) style:UITableViewStylePlain];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.bounces = NO;
        _leftTableView.backgroundColor = CVMainBgColor;
        [self addSubview:_leftTableView];
        
        x += width;
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(x, y, width, height) style:UITableViewStylePlain];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.showsHorizontalScrollIndicator = NO;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.bounces = NO;
        _rightTableView.backgroundColor = CVMainBgColor;
        [self addSubview:_rightTableView];
    }
    
    return self;
}

-(void)setFoodModelsArray:(NSMutableArray *)foodModelsArray
{
    for (int i = 0; i < foodModelsArray.count; i++) {
        if (i%2 == 0) {
            [_leftModelsArray addObject:foodModelsArray[i]];
        }else{
            [_rightModelsArray addObject:foodModelsArray[i]];
        }
    }
    
    [_leftTableView reloadData];
    [_rightTableView reloadData];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _leftTableView) {
        return _leftModelsArray.count;
    }else{
        return _rightModelsArray.count;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return CVFoodCellSingleSize.height; //183.0
    return CVFoodViewSingleSize.height + CVFoodListCellOffsetY*2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    HomeFoodListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        
        cell = [[HomeFoodListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    
    FoodModel *model ;
    if (tableView == _leftTableView) {
        model = [_leftModelsArray objectAtIndex:indexPath.row];
    }else{
        model = [_rightModelsArray objectAtIndex:indexPath.row];
    }
    [cell setFoodModel:model AndkFoodCellType:_kFoodCellType];

    return cell;
}

/**
 *      选中  cell    回传主页面foodID
 */
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray *array = (tableView == _leftTableView)?_leftModelsArray:_rightModelsArray;
//    FoodModel *model = [array objectAtIndex:indexPath.row];
//    
//    
//}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     if(scrollView==_rightTableView){
        _leftTableView.contentOffset = scrollView.contentOffset;
     }else if (scrollView==_leftTableView) {
         _rightTableView.contentOffset = scrollView.contentOffset;
     }
}

@end
