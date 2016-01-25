//
//  TFSearchResultTableView.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-11.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#define HeaderViewHeight  60

#import "PopUpView.h"
#import "TFSearchResultTableVIew.h"
#import "ConstValues.h"
#import <AVOSCloud/AVOSCloud.h>
#import "FoodModel.h"
#import "TFSearchResultTableView.h"
#import "TFSearchTableViewCell.h"


@interface TFSearchResultTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_foodModelsArray;
    
    NSString *_keywords;
    
    UILabel *_resultNumLabel;
    //UIButton *_sequenceBtn;
    
    PopUpView *_sequencePopView;
}
@end

@implementation TFSearchResultTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _foodModelsArray = [NSMutableArray array];
        
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = CVMainBgColor;
        
        [self initTableHeaderView];
        
//        _resultNumLabel.backgroundColor = [UIColor redColor];
//        _sequenceBtn.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}

#pragma mark - 创建 tableView 头视图
-(void)initTableHeaderView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CVScreenSize.width, HeaderViewHeight)];
    self.tableHeaderView = headView;
    
    float offsetX = 10;
    float width = 100;
    float height = 40;
    float x = CVScreenSize.width - width - offsetX;
    float y = (HeaderViewHeight - height)/2;
    _sequenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sequenceBtn.frame = CGRectMake(x, y, width, height);
    [_sequenceBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"item_more" ofType:@"png"]] forState:UIControlStateNormal];
    _sequenceBtn.imageEdgeInsets = UIEdgeInsetsMake(height - 15, width - 15, 0, 0);
    _sequenceBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 7);
    [_sequenceBtn setTitle:@"按价格排序" forState:UIControlStateNormal];
    [_sequenceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _sequenceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_sequenceBtn addTarget:self action:@selector(sequenceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_sequenceBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height-2, width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_sequenceBtn addSubview:lineView];
    
    
    x = offsetX;
    width = CGRectGetMinX(_sequenceBtn.frame) - x;
    _resultNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [headView addSubview:_resultNumLabel];
    
}


#pragma mark - 选择搜索排序方式
-(void)sequenceBtnClicked
{
    if (_sequencePopView == nil) {
        
        float x = CGRectGetMinX(_sequenceBtn.frame);
        float y = CGRectGetMaxY(_sequenceBtn.frame);
        
        _sequencePopView = [[PopUpView alloc] initWithViewType:kPopUpView_SequenceType];
        _sequencePopView.frame = CGRectMake(x, y, CGRectGetWidth(_sequencePopView.frame), CGRectGetHeight(_sequencePopView.frame));
        
        __block UIButton *btn = _sequenceBtn;
        __block TFSearchResultTableView *selfView = self;
        __block PopUpView *popUpView = _sequencePopView;
        __block NSString *keyWords = _keywords;
        
        _sequencePopView.backSequenceTypeStr = ^(NSString *sequenceTypeStr){
            
            [btn setTitle:sequenceTypeStr forState:UIControlStateNormal];
            popUpView.hidden = YES;
            
            [selfView searchKeyWords:keyWords AndSequenceType:sequenceTypeStr];
            
        };
        // [self.tableHeaderView addSubview:_sequencePopView];
        //  无效，会导致弹出的选择视图失去tableview的代理方法响应，不能选择排序方式
        [self addSubview:_sequencePopView];
        _sequencePopView.hidden = YES;
    }
    
    _sequencePopView.hidden = !_sequencePopView.hidden;
    
}

#pragma mark - 查询关键字，准备数据源

-(void)searchKeyWords:(NSString *)keywords AndSequenceType:(NSString *)sequenceTypeStr
{
    _keywords =  keywords==nil? @"无":keywords;
    [_foodModelsArray removeAllObjects];
    //NSString *sequenceStr = @"price";

    AVQuery *query = [AVQuery queryWithClassName:@"Food"];
    [query whereKey:@"name" containsString:keywords];
    
    if ([sequenceTypeStr isEqualToString:@"按人气排序"])
        [query orderByDescending:@"hot"];
    else
        [query orderByAscending:@"price"];
    //query.limit = 6;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
#pragma mark -  自己总结的正确判断格式！！！ 判断 count
        if (objects.count > 0) {
            
            FoodModel *foodModel = nil;
            for (NSDictionary *foodDic in objects) {
                
                foodModel = [[FoodModel alloc] init];
                foodModel.foodImgUrl = [foodDic objectForKey:@"img"];
                foodModel.foodRestaurant = [foodDic objectForKey:@"restaurant"];
                foodModel.foodName = [foodDic objectForKey:@"name"];
                foodModel.soldAmount = [[foodDic objectForKey:@"hot"] intValue];
                foodModel.foodPrice = [[foodDic objectForKey:@"price"] floatValue];
                foodModel.foodID = [foodDic objectForKey:@"objectId"];
                
                [_foodModelsArray addObject:foodModel];
                NSLog(@"==%@==",foodModel.foodName);
            }
            
            [self reloadData];
            
            NSMutableAttributedString *searchResultStr = [[NSMutableAttributedString alloc]
                                                          initWithString:@"共搜索到条数据"
                                                          attributes:
                                                          @{NSFontAttributeName :[UIFont boldSystemFontOfSize:16]}];
                                                                       
           NSAttributedString *countStr = [[NSAttributedString alloc]
                                           initWithString:
                                           [NSString stringWithFormat:@"%d",_foodModelsArray.count]
                                           attributes:
                                            @{NSForegroundColorAttributeName: CVMainColor}];
         [searchResultStr insertAttributedString:countStr atIndex:4];
            _resultNumLabel.attributedText = searchResultStr;
                                                                                                                                   
            
        }else if(objects.count < 1){
            
            NSLog(@"没有找到相关数据");
            
        }else{
            
            NSLog(@"查询出错");
        }
        
    }];
    
    
}


#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _foodModelsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TFSearchCellHeight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cellID";
    
    TFSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[TFSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    
    if (_foodModelsArray.count > indexPath.row) {
        
        FoodModel *foodModel = [_foodModelsArray objectAtIndex:indexPath.row];
        [cell setFoodModel:foodModel];
    }
    
    return cell;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _sequencePopView.hidden = YES;

}




@end

