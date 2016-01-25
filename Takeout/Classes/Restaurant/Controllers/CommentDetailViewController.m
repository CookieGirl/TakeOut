//
//  CommentDetailViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-16.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "NavigationView.h"
#import "ConstValues.h"
#import <AVOSCloud/AVOSCloud.h>

@interface CommentDetailViewController ()
{
    NSString *_commentID;
    
    NSString *_restaurantName;
    float _totalPrice;
    
//    NSString *_foodNameStr;
//    NSString *_singlePrice;
//    NSString *_amountLabel;
    
    NSString *_remarkStr;
    NSString *_localeStr;

    NSString *_dataStr;
    NSMutableArray *_orderArray;
}
@end

@implementation CommentDetailViewController

-(id)initWithCommentID:(NSString *)commentID
{
    self = [super init];
    if (self) {
        _commentID = commentID;
        _orderArray = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - 创建视图
-(void)initView
{
    float x = 10;
    float y = 20 + MyNaviViewHeight + 5;
    float width = (CVScreenSize.width - x)/2;
    float height = 40;
    float fontSize = 18;
    
    UILabel  *restaurantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    restaurantNameLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    restaurantNameLabel.text = _restaurantName;
    [self.view addSubview:restaurantNameLabel];
    
    width = 80;
    x = CVScreenSize.width - width - 10;
    
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    totalPriceLabel.text = [NSString stringWithFormat:@"¥%.1f  ",_totalPrice];
    totalPriceLabel.textColor = CVBlueColor;
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    totalPriceLabel.font = [UIFont systemFontOfSize:fontSize - 1];
    [self.view addSubview:totalPriceLabel];
    
    x = 10;
    y = CGRectGetMaxY(restaurantNameLabel.frame) + 5;
    width = CVScreenSize.width - 2*x;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    fontSize -= 3;
    x = 15;
    y = CGRectGetMaxY(lineView.frame) + 10;
    width = (CVScreenSize.width - 2*x)/2;
    height -= 5;
    
    for (int i = 0; i < _orderArray.count; i++) {
        
        UILabel *foodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        foodNameLabel.font = [UIFont systemFontOfSize:fontSize];
        foodNameLabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:foodNameLabel];
        
        x = CVScreenSize.width/2;
        width = width/2 + 20;
        UILabel *singlePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        singlePriceLabel.font = [UIFont systemFontOfSize:fontSize];
        singlePriceLabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:singlePriceLabel];
        
        x += width ;
        width = CVScreenSize.width - x;
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        amountLabel.font = [UIFont systemFontOfSize:fontSize];
        amountLabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:amountLabel];
        
        x = CGRectGetMinX(lineView.frame);
        y += height;
        width = CGRectGetWidth(lineView.frame);
        lineView = [[UIView alloc] initWithFrame: CGRectMake(x, y, width, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:lineView];
        
        // 数据处理
        NSDictionary *orderDic = _orderArray[i];
        foodNameLabel.text = [orderDic objectForKey:@"name"];
        float price = [[orderDic objectForKey:@"price"] floatValue];
        singlePriceLabel.text = [NSString stringWithFormat:@"¥%.1f",price];
        
        amountLabel.text = [NSString stringWithFormat:@"%@份",[orderDic objectForKey:@"amount"]];
        
        //amountLabel.backgroundColor = [UIColor grayColor];
        
        y += height;
    }
    
    x = 10;
    width = CVScreenSize.width - 2*x;
    y = CGRectGetMaxY(lineView.frame) + 10;
    NSString *remarkStr = [NSString stringWithFormat:@"其他需求: %@",_remarkStr == nil ? @"  ":_remarkStr];
    
    CGSize remarkSize = [remarkStr boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    NSMutableAttributedString *remarkAttrStr = [[NSMutableAttributedString alloc] initWithString:remarkStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    NSRange attrRange = {0,5};
    [remarkAttrStr setAttributes:@{NSForegroundColorAttributeName: CVMainColor} range:attrRange];

    UILabel *remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, remarkSize.height)];
    remarkLabel.attributedText = remarkAttrStr;
    remarkLabel.numberOfLines = 0;
    [self.view addSubview:remarkLabel];
    
    y = CGRectGetMaxY(remarkLabel.frame) + 5;
    
    NSString *localeStr = [NSString stringWithFormat:@"送餐地址: %@",_localeStr == nil ? @"  ":_localeStr];
    
    CGSize localeSize = [remarkStr boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    NSMutableAttributedString *localeAttrStr = [[NSMutableAttributedString alloc] initWithString:localeStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    [localeAttrStr setAttributes:@{NSForegroundColorAttributeName: CVMainColor} range:attrRange];
    
    UILabel *localeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, localeSize.height)];
    localeLabel.attributedText = localeAttrStr;
    localeLabel.numberOfLines = 0;
    [self.view addSubview:localeLabel];

}

#pragma mark - 加载数据
-(void)loadDataWithCommentID:(NSString *)commentID
{
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
    [query whereKey:@"objectId" equalTo:commentID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects) {
            
            NSDictionary *commentObj = [objects firstObject];
            
            AVQuery *queryOrder = [AVQuery queryWithClassName:@"Order"];
            [queryOrder whereKey:@"commentId" equalTo:commentID];
            [queryOrder findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (objects) {
                    
                    NSDictionary *orderObj = [objects firstObject];
                    _restaurantName = [orderObj objectForKey:@"restaurantName"];
                    _totalPrice = [[orderObj objectForKey:@"totalPrice"] floatValue];
                    //_foodNameLabel.text = [orderObj objectForKey:@""];
                    
                    _remarkStr = [orderObj objectForKey:@"others"];
                    _localeStr = [orderObj objectForKey:@"locale"];
                    
                    //  解析字符串
                    _dataStr = [orderObj objectForKey:@"data"];
                    
//                    NSArray *array = [NSArray arrayWithObject:_dataStr];
//                    NSLog(@"array:%@",array);
                    
                    NSMutableArray *ordersArray = [NSMutableArray arrayWithArray: [_dataStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":[{\",']}"]]];
                    [ordersArray removeObject:@""];
                    
                    for (int i = 0; i < ordersArray.count;i += 6) {
                        
                        //NSLog(@"<#string#>")
                        NSMutableDictionary *orderDic = [[NSMutableDictionary alloc] initWithObjects:@[ordersArray[i+1],ordersArray[i+3],ordersArray[i+5]] forKeys:@[ordersArray[i],ordersArray[i+2],ordersArray[i+4]]];
                        
                        [_orderArray addObject:orderDic];
                        
                    }
                    
                    [self initView];
                }
                
            }];
        
            
        }else{
            NSLog(@"查询出错: \n%@", [error description]);
        }
    }];

    
    //_restaurantNameLabel.text =
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CVMainBgColor;
    
    NavigationView *view = [[NavigationView alloc] init];
    [view setLeftButtonTitle:@"< 返回"];
    [self.view addSubview:view];
    
    CommentDetailViewController *dvc = self;
    
    view.backBtnTag = ^(kMyNaviViewBtnTag naviBtnTag){
        [dvc.navigationController popViewControllerAnimated:YES];
    };
    
    [self loadDataWithCommentID:_commentID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
