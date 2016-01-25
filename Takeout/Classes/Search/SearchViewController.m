//
//  SearchViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-2.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

enum
{
    kBtnFanCai = 301,
    kBtnFenMian,
    kBtnZhuShi,
    kBtnKuaiCan,
    kBtnXiaoChi,
    kBtnYinLiao,
    kBtnQiTa,
};

enum
{
    HeadBtnTag_Left = 321,
    HeadBtnTag_Right,
};

#define IMAGE_MIN_TAG 310

#import <AVOSCloud/AVOSCloud.h>
#import "SearchViewController.h"
#import "ConstValues.h"
#import "ImgSearchResultViewController.h"
#import "TFSearchTableViewCell.h"
#import "TFSearchResultTableView.h"

@interface SearchViewController ()<UITextFieldDelegate>
{
    NSMutableArray *_buttonsArray;
    NSArray *_imageNamesArray;
    
    
    UIScrollView *_scrollView;
    NSArray *_allKeywordsArray;
    NSMutableArray *_currentKeywordsArray;
    
    UIButton *_leftButton;
    UITextField *_searchTF;
    TFSearchResultTableView *_searchResultView;
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _buttonsArray = [NSMutableArray arrayWithObjects:@"饭菜",@"粉面",@"主食",@"快餐",@"小吃",@"饮料",@"其他", nil];
        
        _imageNamesArray = [NSArray arrayWithObjects:
                            @"chaocai",@"baozaifan",@"chaofan",
                            @"gaijiaofan",@"huifan",
                            @"fensifentiao",@"banmian",@"chaomian",
                            @"tangmian",
                            @"bing",@"shuijiao",@"zhou",
                            @"hundun",
                            @"hanbao",@"jipai",@"xishi",
                            @"xiaoshi",@"pisa",
                            @"shaokao",
                            @"yinliao", @"bingpin",@"naicha",
                            @"niunaidouru",
                            @"qita",
                            nil];
        
        _allKeywordsArray = [NSArray arrayWithObjects:
                             @"炒菜",@"煲仔",@"炒饭",@"盖浇饭",@"烩饭",
                             @"粉丝粉条",@"拌面",@"炒面",@"汤面",
                             @"饼",@"水饺",@"粥",@"馄饨",
                             @"汉堡",@"鸡排",@"西式",@"小食",@"披萨",
                             @"烧烤",
                             @"饮料",@"冰品",@"奶茶",
                             @"牛奶豆乳",
                             @"其他",nil];
        _currentKeywordsArray = [NSMutableArray array];
        
        //_scrollImagesArray = [NSMutableArray array];
        
    }
    return self;
}

#pragma mark - 创建 NavigationBar
-(void)initNavigationBar
{
    float offsetX = 5;
    float x = offsetX;
    float y = 0;
    float width = 60;
    float height = CVNaviBarHeight - 20;
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
//    label.text = @"搜索";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE];
//    [self.navigationController.navigationBar addSubview:label];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(x, y, width, height);
    [_leftButton setTitle:@"搜索" forState:UIControlStateNormal];
    [_leftButton setTitle:@"< 返回" forState:UIControlStateSelected];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _leftButton.titleLabel.font =[UIFont boldSystemFontOfSize:NAVI_FONTSIZE];
    _leftButton.tag = HeadBtnTag_Left;
    [_leftButton addTarget:self action:@selector(headBtnsClicked:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.userInteractionEnabled = NO;
    [self.navigationController.navigationBar addSubview:_leftButton];
    
    height = 30;
    width = height;
    y = (CVNaviBarHeight - 20- height)/2;
    x = CVScreenSize.width - width - y;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom]
    ;
    searchBtn.frame = CGRectMake(x, y, width, height);
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [searchBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ic_menu_search" ofType:@"png"]] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(headBtnsClicked:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.tag = HeadBtnTag_Right;
    [self.navigationController.navigationBar addSubview:searchBtn];
    
    x = CGRectGetMaxX(_leftButton.frame) + offsetX;
    y = 7;
    width = CGRectGetMinX(searchBtn.frame) - CGRectGetMaxX(_leftButton.frame) - 2*offsetX;
    height = CVNaviBarHeight - 20 - 2*y;
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _searchTF.borderStyle = UITextBorderStyleRoundedRect;
    _searchTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchTF.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchTF.placeholder = @"搜一下想吃的吧～";
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.keyboardAppearance = UIKeyboardAppearanceLight;
    //_searchTF.keyboardType = UIKeyboardTypeTwitter;
    _searchTF.delegate = self;
    [self.navigationController.navigationBar addSubview:_searchTF];

}

#pragma mark - 顶部搜索框两个按钮触发事件

-(void)headBtnsClicked:(UIButton *)button
{

    [_searchTF resignFirstResponder];
    
    switch (button.tag) {
        case HeadBtnTag_Left:
        {
            _leftButton.selected = NO;
            _leftButton.userInteractionEnabled = NO;
            
            _searchResultView.hidden = YES;
            _searchTF.text = nil;
        }
            break;
            
        case HeadBtnTag_Right:
        {
            _leftButton.selected = YES;
            _leftButton.userInteractionEnabled = YES;
            
            _searchResultView.hidden = NO;
            
            [_searchResultView searchKeyWords:_searchTF.text AndSequenceType:_searchResultView.sequenceBtn.titleLabel.text];
            
        }
            break;
        default:
            break;
    }
   
}


#pragma mark - 收键盘

-(void)tapScrollView:(UITapGestureRecognizer *)tapGesture
{
    [_searchTF resignFirstResponder];
}


#pragma mark - 底部图标
-(UITabBarItem *)tabBarItem
{
    UIImage *image = [UIImage imageNamed:@"tabbar_search_nor"];
    UIImage *selectedImage = [UIImage imageNamed:@"tabbar_search_sel"];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"搜索" image:image selectedImage:selectedImage];
    
    return item;
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
    
    [self prepareLeftButtonsView];
    
#pragma mark - 创建 查找出来的 tableview 视图
    _searchResultView = [[TFSearchResultTableView alloc] initWithFrame:CGRectMake(0, 0, CVScreenSize.width, CVScreenSize.height - CVNaviBarHeight - CVTabbarHeight)];
    [self.view addSubview:_searchResultView];
    _searchResultView.hidden = YES;
    
}

#pragma mark - 创建左边按钮视图, 右边scrollview
/**
 *  创建左边按钮视图
 */
-(void)prepareLeftButtonsView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_big"]];
    
    float boderWith = 0.2;
    float x = 0;
    float y = 0;  // CVNaviBarHeight
    float width = 100;
    float height = (CVContentSize.height*2/3) / _buttonsArray.count;
    
    UIButton *button = nil;
    for (int i = 0; i < _buttonsArray.count; i++) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, width, height - 2*boderWith);
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = boderWith;
        [button setTitle:_buttonsArray[i] forState:0];
        [button setTitleColor:CVMainColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(leftBtnsClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kBtnFanCai + i;
        [self.view addSubview:button];
        y = CGRectGetMaxY(button.frame);
        
        [_buttonsArray replaceObjectAtIndex:i withObject:button];
    }
    
    // 最后一个按钮底部少一条线
    UIView *lineViewBtnsBottom = [[UIView alloc] initWithFrame:CGRectMake(x,CGRectGetMaxY(button.frame), button.frame.size.width,0.5)];
    lineViewBtnsBottom.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineViewBtnsBottom];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 0, 0.5, CVContentSize.height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];

    x += width;
    y = 0;    //  64    CVNaviBarHeight
    width = CVContentSize.width - width;
    height = CVContentSize.height;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = NO;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView:)];
    [_scrollView addGestureRecognizer:tapGesture];
    
    
    //  设置初始状态
    [self leftBtnsClicked:_buttonsArray[0]];
    
}

#pragma mark - 选择不同按钮，获取 imageNames 并传出 imagenames 数组
/**
 *  选择不同按钮，获取 imageNames 并传出 imagenames 数组
 */
-(void)leftBtnsClicked:(UIButton *)button
{
    for (UIButton *button in _buttonsArray) {
        [button setBackgroundColor:[UIColor whiteColor]];
        button.selected = NO;
    }
    
    button.selected = YES;
    [button setBackgroundColor:CVMainTextColor];
    
    NSRange range ;
    switch (button.tag) {
            
        case kBtnFanCai:
            range = NSMakeRange(0, 5);
            break;
            
        case kBtnFenMian:
            range = NSMakeRange(5, 4);
            break;
            
        case kBtnZhuShi:
            range = NSMakeRange(9,4);
            break;
            
        case kBtnKuaiCan:
            range = NSMakeRange(13, 5);
            break;
            
        case kBtnXiaoChi:
            range = NSMakeRange(18,1);
            break;
            
        case kBtnYinLiao:
            range = NSMakeRange(19, 3);
            break;
            
        case kBtnQiTa:
            range = NSMakeRange(22, 1);
            break;
            
        default:
            break;
    }
    
    [_currentKeywordsArray removeAllObjects];
    [_currentKeywordsArray addObjectsFromArray:[_allKeywordsArray subarrayWithRange:range]];
    
    [self resetImages:[_imageNamesArray subarrayWithRange:range]];
    
}

#pragma mark - 右边选择的图片： 移除子视图，重绘视图
/**
 *  //移除子视图，重绘视图
 */
-(void)resetImages :(NSArray *)imagesArray
{
    //移除子视图，重绘视图
    for (UIView *view in [_scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    float offsetY = 10;
    
    float width = _scrollView.frame.size.width/2;
    float height = width * 2/3;
    float x = width/2;
    float y = offsetY;
    
    for (int i = 0; i < imagesArray.count; i++) {
        
        NSString *imagesPath = [[NSBundle mainBundle] pathForResource:imagesArray[i] ofType:@"png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10;
        imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        imageView.layer.borderWidth = 0.5;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageWithContentsOfFile:imagesPath];
        
        imageView.userInteractionEnabled = YES; //打开用户交互
        imageView.tag = IMAGE_MIN_TAG + i;
         UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [_scrollView addSubview:imageView];
        y += height+offsetY;
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, y);
    
}

#pragma mark - 右边图片手势触发 搜索事件
-(void)tapImageAction:(UITapGestureRecognizer *)tapGesture
{
    
    int index = tapGesture.view.tag - IMAGE_MIN_TAG;
    
    NSString *keywords = _currentKeywordsArray[index];
    
    //NSLog(@"===keyword:%@===",keywords);
    ImgSearchResultViewController *ivc = [[ImgSearchResultViewController alloc] initWithKeyWords:keywords];
    [self.navigationController pushViewController:ivc animated:YES];
    
    //[self.navigationController presentViewController:ivc animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
