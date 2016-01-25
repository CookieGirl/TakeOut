//
//  FoodDetailViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-4.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#define CenterHight 100
#define CenterClearImgViewHeight 40
#define IsSpecailView_Tag 201
#define CenterFontSize  16

#import <AVOSCloud/AVOSCloud.h>
#import "FoodDetailViewController.h"
#import "ConstValues.h"
#import "PopUpView.h"
#import "CustomToolBar.h"
#import "UIImageView+WebCache.h"
#import "OrderComfirmView.h"
#import "OrderComfirmViewController.h"

@interface FoodDetailViewController ()<UIScrollViewDelegate>
{
    NSString *_foodID;
    // 上
    UIImageView *_foodImageView;
    UILabel *_foodNameLabel;
    // 中
    UILabel *_foodPriceBigLabel;
    
    UIButton *_priceChooseBtn;
    PopUpView *_priceChoosePopView;
    UILabel *_foodAmmountLabel;
    UILabel *_soldAmmountLabel;
    UILabel *_favouriteAmmountLabel;
    
    //下
    UILabel *_restaurantNameLabel;
    
}
@end

@implementation FoodDetailViewController

-(id)initWithFoodID:(NSString *) foodID
{
    if (self = [super init]) {
        _foodID = foodID;

    }
    
    return self;
}

#pragma mark - 创建头部视图
-(void)createHeadViewWithImgUrl:(NSString *)imgUrlStr AndFoodName:(NSString *)foodName
{
    //self.navigationController.navigationBar.hidden = YES;
    float x = 0;
    float y = 0;
    float width = CVScreenSize.width;
    float height = (CVScreenSize.height - CVTabbarHeight)/2; // - CVNaviBarHeight
    
     _foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _foodImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_foodImageView];
    
    [_foodImageView setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageWithContentsOfFile:CVNoFoodImgPath]];
    
    //  大图片底部，透明图片
    height = CenterClearImgViewHeight;
    y = _foodImageView.frame.size.height - height;
    UIImageView *imgViewClearCenter = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    imgViewClearCenter.contentMode = UIViewContentModeScaleToFill;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"img_clear" ofType:@"png"];
    imgViewClearCenter.image = [UIImage imageWithContentsOfFile:imagePath];
    imgViewClearCenter.userInteractionEnabled = YES;
    [_foodImageView addSubview:imgViewClearCenter];
    
    //  食物名称， 是否为特色
    float offsetX = 10;

    x = offsetX;
    y = 0;
    width = (CVScreenSize.width - 2*offsetX)*21/33;
    _foodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _foodNameLabel.textColor = [UIColor blackColor];
    _foodNameLabel.text = foodName;
    _foodNameLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE];
    [imgViewClearCenter addSubview:_foodNameLabel];
    
    //  中部,右边，“＊本店特色＊”
    x = CGRectGetMaxX(_foodNameLabel.frame);
    width = CVScreenSize.width - offsetX - x;
    
    UIView *view = [self createCenterSpecailView:CGRectMake(x, y, width, height)];
    [imgViewClearCenter addSubview:view];
    
}


#pragma mark - 中部,右边，“＊本店特色＊”
-(UIView *)createCenterSpecailView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.tag = IsSpecailView_Tag;
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    // 两个星星
    float offsetX = 0;
    float offsetY = frame.size.height/3;
    float x = offsetX;
    float y = offsetY;
    float height = frame.size.height - 2*offsetY;;
    float width = height;
    
    UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    NSString *starImagePaht = [[NSBundle mainBundle] pathForResource:@"star_sel" ofType:@"png"];
    starView.image = [UIImage imageWithContentsOfFile:starImagePaht];
    starView.backgroundColor = [UIColor clearColor];
    [view addSubview:starView];
    
    x = view.frame.size.width - width - offsetX;
    starView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    starView.image = [UIImage imageWithContentsOfFile:starImagePaht];
    starView.backgroundColor = [UIColor clearColor];
    [view addSubview:starView];
    
    width = view.frame.size.width - 4*offsetX - 2*width;
    height = view.frame.size.height;
    x = CGRectGetMinX(starView.frame) - width - offsetX;
    y = 0;
    UILabel *specailLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    specailLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE - 1];
    specailLabel.text = @"本店特色";
    specailLabel.textColor = CVMainColor;
    specailLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:specailLabel];
    
    return view;
}


#pragma mark - 创建 中间，横线上方，价格展示视图
-(void)createCenterPriceViewWithPrice:(float)price AndSoldAmmount:(int)soldAmount AndFavouriteAmmount:(int)favouriteAmmount
{
    float x = 0;
    float y = CGRectGetMaxY(_foodImageView.frame);
    float width = CVScreenSize.width;
    float height = _foodImageView.frame.size.height/2;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.view addSubview:view];
    
    x = 5;
    y = 5;
    width /= 4;
    height = width;
    _foodPriceBigLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _foodPriceBigLabel.backgroundColor = CVMainColor;
    _foodPriceBigLabel.textAlignment = NSTextAlignmentCenter;
    _foodPriceBigLabel.textColor = [UIColor whiteColor];
    _foodPriceBigLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE+10];
    _foodPriceBigLabel.text = [NSString stringWithFormat:@"¥%.1f",price]; //@"¥8.0"
    [view addSubview:_foodPriceBigLabel];
    

    height = view.frame.size.height/4 ;
    width = 2*height;
    y = 10;
    x = CVScreenSize.width - width - 10;
    NSString *ammountImagePathNor = [[NSBundle mainBundle] pathForResource:@"ammount_btn_nor" ofType:@"png"];
    NSString *ammountImagePathSel = [[NSBundle mainBundle] pathForResource:@"ammount_btn_sel" ofType:@"png"];
    _priceChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _priceChooseBtn.backgroundColor = [UIColor clearColor];
    _priceChooseBtn.layer.borderColor = [UIColor colorWithRed:212 green:213 blue:213 alpha:1].CGColor;
    _priceChooseBtn.layer.borderWidth = 1;
    _priceChooseBtn.layer.cornerRadius = 5;
    _priceChooseBtn.layer.masksToBounds = YES;
    
    [_priceChooseBtn setBackgroundImage:[UIImage imageWithContentsOfFile:ammountImagePathNor] forState:UIControlStateNormal];
    [_priceChooseBtn setBackgroundImage:[UIImage imageWithContentsOfFile:ammountImagePathSel] forState:UIControlStateHighlighted];
    [_priceChooseBtn addTarget:self action:@selector(priceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_priceChooseBtn];

    _foodAmmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width*2/3, height)];
    _foodAmmountLabel.textColor = [UIColor blackColor];
    _foodAmmountLabel.textAlignment = NSTextAlignmentCenter;
    _foodAmmountLabel.font = [UIFont systemFontOfSize:13];
    _foodAmmountLabel.text = @"1";
    [_priceChooseBtn addSubview:_foodAmmountLabel];
    
    // 两排 文字
    NSMutableAttributedString * soldAttrStr = [[NSMutableAttributedString alloc] initWithString: @"已售  份"];
    NSMutableAttributedString * favouriteAttrStr = [[NSMutableAttributedString alloc] initWithString: @" 人收藏"];
    
    NSAttributedString * attrString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",soldAmount] attributes:@{NSForegroundColorAttributeName:CVMainColor}];
    NSAttributedString * attrString2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",favouriteAmmount] attributes:@{NSForegroundColorAttributeName:CVMainColor}];
    
    [soldAttrStr insertAttributedString:attrString1 atIndex:3];
    [favouriteAttrStr insertAttributedString:attrString2 atIndex:0];

    float offsetX = 15;
    height = 30;
    x = CGRectGetMaxX(_foodPriceBigLabel.frame) + offsetX;
    width = (CVScreenSize.width - x - offsetX)/2;
    y = CGRectGetMaxY(_foodPriceBigLabel.frame) - height - 5;

    _soldAmmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, height)];
    _soldAmmountLabel.attributedText = soldAttrStr;
    _soldAmmountLabel.font = [UIFont systemFontOfSize:CenterFontSize];
    [view addSubview:_soldAmmountLabel];
    
    x = CVScreenSize.width - offsetX - width;
    _favouriteAmmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, height)];
    _favouriteAmmountLabel.textAlignment = NSTextAlignmentRight;
    _favouriteAmmountLabel.attributedText = favouriteAttrStr;
    _favouriteAmmountLabel.font = [UIFont systemFontOfSize:CenterFontSize];
    [view addSubview:_favouriteAmmountLabel];
    

}

#pragma mark - 价格选择事件，创建视图
-(void)priceBtnClicked:(UIButton *)button
{
    if (!_priceChoosePopView) {
        
        float x = CGRectGetMinX(_priceChooseBtn.frame);
        float y = CGRectGetMaxY(_foodImageView.frame) +  CGRectGetMaxY(_priceChooseBtn.frame) ;
        _priceChoosePopView = [[PopUpView alloc] initWithViewType:kPopUpView_Price];
        
        // block 回传选中订单数量
        UILabel *foodAmmountLabel = _foodAmmountLabel; // 消除block块中强引用
        PopUpView *view = _priceChoosePopView;
        _priceChoosePopView.backFoodOrderNumber = ^(NSString *foodOrderNumber){
            foodAmmountLabel.text = foodOrderNumber;
            view.hidden = YES;
        };
        _priceChoosePopView.frame = CGRectMake(x, y, _priceChoosePopView.frame.size.width, _priceChoosePopView.frame.size.height);
        [self.view addSubview:_priceChoosePopView];
        
    }else{
        _priceChoosePopView.hidden = !_priceChoosePopView.hidden;
    }
}


#pragma mark - 分割线以下视图
-(void)createFootViewWithRestaurantName:(NSString *)restuarantName
{
    float x = 10 ;
    float y = CGRectGetMaxY(_foodImageView.frame) + CGRectGetHeight(_foodImageView.frame)/2 - 20;
    float width = CVScreenSize.width - 20;
    float height = 1;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    lineView.backgroundColor = CVMainColor;
    [self.view addSubview:lineView];
    
    // 根据分割线，创建视图
    
    float offsetX = 40;
    float offsetY = 10;
    x = offsetX;
    y += offsetY;
    width = (width - 3*offsetX)/2 ;
    height = 30;
    UILabel *toStoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    toStoreLabel.text = @"去店铺";
    toStoreLabel.textColor = [UIColor blackColor];
    toStoreLabel.font = [UIFont systemFontOfSize:CenterFontSize];
    toStoreLabel.textAlignment = NSTextAlignmentRight;
    toStoreLabel.userInteractionEnabled = YES;
    [self.view addSubview:toStoreLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    NSString *toStorePath = [[NSBundle mainBundle] pathForResource:@"to_store" ofType:@"png"];
    imageView.image = [UIImage imageWithContentsOfFile:toStorePath];
    [toStoreLabel addSubview:imageView];
    
    x = CVScreenSize.width - offsetX - width;
    UILabel *toCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    toCommentLabel.text = @"看评论";
    toCommentLabel.font = [UIFont systemFontOfSize:CenterFontSize ];
    toCommentLabel.textAlignment = NSTextAlignmentRight;
    toCommentLabel.userInteractionEnabled = YES;
    [self.view addSubview:toCommentLabel];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    NSString *toCommentPath = [[NSBundle mainBundle] pathForResource:@"to_comment" ofType:@"png"];
    imageView.image = [UIImage imageWithContentsOfFile:toCommentPath];
    [toCommentLabel addSubview:imageView];
    
    //
    x = 0;
    y = CGRectGetMaxY(toStoreLabel.frame) + 15;
    width = CVScreenSize.width;
    height = 15;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, width, height)];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = CVFoodDetailTipsStr1;
    label.font = [UIFont systemFontOfSize:CenterFontSize - 2];
    [self.view addSubview:label];
    
    y += height + 3;
    _restaurantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    NSAttributedString *restaurantNameAttrStr = [[NSAttributedString alloc] initWithString:restuarantName attributes:@{NSForegroundColorAttributeName:CVMainColor}];
    NSMutableAttributedString *tipStr2 = [[NSMutableAttributedString alloc] initWithString:CVFoodDetailTipsStr2 attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [tipStr2 insertAttributedString:restaurantNameAttrStr atIndex:6];
    _restaurantNameLabel.attributedText = tipStr2;
    _restaurantNameLabel.textAlignment = NSTextAlignmentCenter;
    _restaurantNameLabel.font = [UIFont systemFontOfSize:CenterFontSize -2];
    
    [self.view addSubview:_restaurantNameLabel];
    
}

/*
#pragma mark - 自定义底部视图,事件触发， block 块

-(void)createBottomView
{

    float height = CVScreenSize.height - 20 ;
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, CVScreenSize.width,height)];
    bottomScrollView.backgroundColor = [UIColor clearColor];
    bottomScrollView.contentSize = CGSizeMake(CVScreenSize.width, height *2 - ToolBarHeight);
    bottomScrollView.bounces = NO;
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.delegate = self;
    [self.view addSubview:bottomScrollView];

    OrderComfirmView *bottomView = [[OrderComfirmView alloc] initWithFrame:CGRectMake(0, CVScreenSize.height - ToolBarHeight - 20, CVScreenSize.width, CVScreenSize.height - 20)];
    [bottomScrollView addSubview:bottomView];

    //[self.view bringSubviewToFront:_priceChooseBtn];
}

#pragma mark - UIScrollViewDelegate  处理背景透明度变化
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

-(void)createBottomBarItems
{

    CustomToolBar *toolBar = [[CustomToolBar alloc] init];
    toolBar.frame = CGRectMake(0, CVScreenSize.height - CGRectGetHeight(toolBar.frame), CGRectGetWidth(toolBar.frame), CGRectGetHeight(toolBar.frame));
    
    toolBar.backToolBarChoose = ^(kToolBarChooseType toolBarChooseType) {
        NSLog(@"%u",toolBarChooseType);
        switch (toolBarChooseType) {
            case kToolBarChooseType_Back:
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
                
            case kToolBarChooseType_ShopCart:
                
                break;
                
            case kToolBarChooseType_Favourite:
            
                break;
                
            case kToolBarChooseType_Share:
                
                break;
                
            default:
                break;
        }

    };
    
    [self.view addSubview:toolBar];
    
}

 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CVMainBgColor;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    NSString *bgImagePath = [[NSBundle mainBundle] pathForResource:@"bg_big" ofType:@"png"];
    bgView.image = [UIImage imageWithContentsOfFile:bgImagePath];
    [self.view addSubview:bgView];
    
    //[self createBottomBarItems];
    
    [self performSelectorOnMainThread:@selector(loadAndSetData) withObject:nil waitUntilDone:YES];
    
    //[self loadAndSetData];
    
    //[self.view bringSubviewToFront:bottomView];
    
    
    
    
//    NSArray *array = [self.navigationController viewControllers ];
//    
//    NSArray *chirld = self.navigationController.childViewControllers;
    
    
    //[self.view bringSubviewToFront:ovc.view];
}


//-(void)viewWillAppear:(BOOL)animated
//{
//   self.wantsFullScreenLayout = YES;
//    self.navigationController.navigationBar.hidden = NO;
//}


#pragma mark - 请求数据,加载视图
-(void)loadAndSetData
{
    AVQuery *query = [AVQuery queryWithClassName:@"Food"];
    [query whereKey:@"objectId" equalTo:_foodID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects) {
            
            NSDictionary *foodDic = [objects firstObject];
            
            NSString *foodName = [foodDic objectForKey:@"name"];
            NSString *restaurantName = [foodDic objectForKey:@"restaurant"];
            NSString *imgUrlStr = [foodDic objectForKey:@"img"];
            float foodPrice = [[foodDic objectForKey:@"price"] floatValue];
            
            int soldAmount = [[foodDic objectForKey:@"hot"] intValue];
            int favouriteAmmount = [[foodDic objectForKey:@"favorites"] intValue];
            
            
#pragma mark - 得到数据后，加载视图
            
            [self createHeadViewWithImgUrl:imgUrlStr AndFoodName:foodName];
            [self createCenterPriceViewWithPrice:foodPrice AndSoldAmmount:soldAmount AndFavouriteAmmount:favouriteAmmount];
            [self createFootViewWithRestaurantName:restaurantName];
            
            OrderComfirmViewController *orderVC = [[OrderComfirmViewController alloc] init];
            orderVC.view.frame = CGRectMake(0, 100, 320, 200);
            
            OrderComfirmViewController *ovc = orderVC;
            
            orderVC.backMoveDistance = ^(float distance){
                
                float center = (CGRectGetMinY(ovc.view.frame) + CGRectGetMaxY(ovc.view.frame))/2;
                ovc.view.center = CGPointMake(CVScreenSize.width/2, center + distance);
                NSLog(@"%f",center);
                //ovc.view.frame = CGRectMake(0, CGRectGetMinY(self.view.frame)-distance, CVScreenSize.width, 200);
            };
            
            orderVC.view.backgroundColor = [UIColor lightGrayColor];
            [self.navigationController addChildViewController:orderVC];
            
            [self.view addSubview:orderVC.view];
            
            
        }else{
            
            NSLog(@"查询出错: \n%@", [error description]);
        }
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
