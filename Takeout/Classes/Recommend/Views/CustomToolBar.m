//
//  CustomToolBar.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-6.
//  Copyright (c) 2014年 geowind. All rights reserved.
//



#import "CustomToolBar.h"
#import "ConstValues.h"

@implementation CustomToolBar

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, CVScreenSize.width,ToolBarHeight)];
    if (self) {
        
        self.backgroundColor = CVMainColor;
        
        [self prepareView];
    }
    return self;
}

#pragma mark - 创建视图  用button 创建
-(void)prepareView
{
    // 左边箭头
    UIButton *backArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backArrowBtn.frame = CGRectMake(0, 0, ToolBarHeight+10, ToolBarHeight);
    NSString *backArrowPath = [[NSBundle mainBundle] pathForResource:@"ic_back_nor" ofType:@"png"];
    [backArrowBtn setBackgroundImage:[UIImage imageWithContentsOfFile:backArrowPath] forState:UIControlStateNormal];
    backArrowBtn.tag = kToolBarChooseType_Back;
    [backArrowBtn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backArrowBtn];
    
    // 右边
    NSArray *titlesArray = [NSArray arrayWithObjects:@"分享",@"收藏",@"去结算", nil];
    NSArray *imagesName = [NSArray arrayWithObjects:@"share_nor",@"star_nor", @"shopcart_nor",@"share_nor",@"star_sel",@"shopcart_sel",nil];
    
    float width;
    float height = ToolBarHeight;
    float x  = self.frame.size.width;
    
    //UIButton *toolBarItem;
    for (int i = 0; i < titlesArray.count; i++) {
        
        CGSize titleStrSize = [titlesArray[i] boundingRectWithSize:CGSizeMake(9999, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size;
        
        width = titleStrSize.width + 2*IconHeight + IconHeight/2;
        x -= width ;
        
        // 1. 三个 item 整体
        UIButton *toolBarItem = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, height)];
        [toolBarItem setTitle:[NSString stringWithFormat:@"  %@", titlesArray[i]] forState:UIControlStateNormal];
        toolBarItem.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
        toolBarItem.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:toolBarItem];
        
        // 2. 图标显示
        NSString *imageNorPath = [[NSBundle mainBundle] pathForResource:imagesName[i] ofType:@"png"];
        NSString *imageSelPath = [[NSBundle mainBundle] pathForResource:imagesName[i+3] ofType:@"png"];
        
        UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - IconHeight*3/2, IconHeight/2, IconHeight, IconHeight)];
        
        iconBtn.tag = kToolBarChooseType_Share - i;
        toolBarItem.tag = kToolBarChooseType_Share - i;
        
        [iconBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imageNorPath] forState:UIControlStateNormal];
        if (toolBarItem.tag == kToolBarChooseType_Favourite) {
            [iconBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imageSelPath] forState:UIControlStateSelected];
            
        }else{
            [iconBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imageSelPath] forState:UIControlStateHighlighted];
        }
       
        [iconBtn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [toolBarItem addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        toolBarItem.userInteractionEnabled = YES;
        [toolBarItem addSubview:iconBtn];
        
    }
    
}

#pragma mark - 点击toolbar item ，触发事件

-(void)itemBtnClicked:(UIButton *)button
{
    self.backToolBarChoose(button.tag);
    
    if (button.tag == kToolBarChooseType_Favourite)
        button.selected = !button.selected;

}


/*
 #pragma mark - 创建视图
 
 -(void)prepareView2 // 用lable 写的
 {
 // 左边箭头
 UIButton *backArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 backArrowBtn.frame = CGRectMake(0, 0, ToolBarHeight+10, ToolBarHeight);
 NSString *backArrowPath = [[NSBundle mainBundle] pathForResource:@"ic_back_nor" ofType:@"png"];
 [backArrowBtn setBackgroundImage:[UIImage imageWithContentsOfFile:backArrowPath] forState:UIControlStateNormal];
 [backArrowBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
 [self addSubview:backArrowBtn];
 
 // 右边
 NSArray *titlesArray = [NSArray arrayWithObjects:@"分享",@"收藏",@"去结算", nil];
 NSArray *imagesName = [NSArray arrayWithObjects:@"share_nor",@"star_nor", @"shopcart_nor",@"share_nor",@"star_sel",@"shopcart_sel",nil];
 
 float width;
 float height = ToolBarHeight;
 float x  = self.frame.size.width;
 
 UILabel *labelItem;
 for (int i = 0; i < titlesArray.count; i++) {
 
 CGSize titleStrSize = [titlesArray[i] boundingRectWithSize:CGSizeMake(9999, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size;
 
 width = titleStrSize.width + 2*IconHeight + IconHeight/2;
 x -= width ;
 
 // 1. 三个 item 整体
 labelItem = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width, height)];
 labelItem.textAlignment = NSTextAlignmentLeft;
 labelItem.text = [NSString stringWithFormat:@"  %@", titlesArray[i]];
 labelItem.textColor = [UIColor whiteColor];
 labelItem.tag = 901 +i;
 
 // 添加手势
 labelItem.userInteractionEnabled = YES;
 UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemDidTaped:)];
 [labelItem addGestureRecognizer:tapGesture];
 [self addSubview:labelItem];
 
 // 2. 图标显示
 NSString *imageNorPath = [[NSBundle mainBundle] pathForResource:imagesName[i] ofType:@"png"];
 NSString *imageSelPath = [[NSBundle mainBundle] pathForResource:imagesName[i+3] ofType:@"png"];
 
 UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - IconHeight*3/2, IconHeight/2, IconHeight, IconHeight)];
 [iconBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imageNorPath] forState:UIControlStateNormal];
 
 if (labelItem.tag == kToolBarChooseType_ShopCart) {
 [iconBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imageSelPath] forState:UIControlStateSelected];
 }else{
 [iconBtn setBackgroundImage:[UIImage imageWithContentsOfFile:imageSelPath] forState:UIControlStateHighlighted];
 iconBtn.tag = kToolBarChooseType_Share;
 }
 
 [iconBtn addTarget:self action:@selector(testBtn:) forControlEvents:UIControlEventTouchUpInside];
 iconBtn.userInteractionEnabled = NO;
 [labelItem addSubview:iconBtn];
 
 }
 
 }


#pragma mark - 点击toolbar item ，触发事件
-(void)itemDidTaped:(UITapGestureRecognizer *)tapGestuerRecognizer
{
    UILabel *tapedLabel = (UILabel *)tapGestuerRecognizer.view;
    
    switch (tapedLabel.tag) {
            
        case kToolBarChooseType_ShopCart:
            
            break;
            
        case kToolBarChooseType_Favourite:
        {
            UIButton *button = (UIButton *)[self viewWithTag:IconTag_Share];
            button.selected = !button.selected;
        }
            break;
            
        case kToolBarChooseType_Share:
            
            break;
            
        default:
            break;
    }
}
 */


@end
