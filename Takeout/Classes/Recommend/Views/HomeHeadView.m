//
//  HomeHeadView.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-2.
//  Copyright (c) 2014年 geowind. All rights reserved.
//


#import <AVOSCloud/AVOSCloud.h>
#import "HomeHeadView.h"
#import "ConstValues.h"
#import "UIImageView+WebCache.h"


@interface HomeHeadView ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageCtl;
    
    NSArray * _imageUrlsArray;
    NSArray *_imageLinksArray;
    
    NSMutableArray *_sectionBtnsArray;
}
@end

@implementation HomeHeadView

-(id)init
{
    //  ??? y 起始： 64 还是 0 ？
    self = [super initWithFrame:CGRectMake(0, 0, CVHomeHeadViewSize.width, CVHomeHeadViewSize.height*5/6)];
    if (self) {
        
//        _imageUrlsArray = [NSMutableArray array];
//        _imageLinksArray = [NSMutableArray array];
        
    }
    return self;
}
 
-(void)setImageUrlsArray:(NSArray *)imageUrlsArray linksArray:(NSArray *)imageLinksArray
{
    _imageUrlsArray = [NSArray arrayWithArray:imageUrlsArray];
    _imageLinksArray = [NSArray arrayWithArray:imageLinksArray];
    
    [self prepareScrollView];
    [self preparePageControl];
    
}

/**
 *  顶部广告 视图
 */
#pragma mark - 顶部广告 视图
-(void)prepareScrollView
{
    _scrollView.backgroundColor= [UIColor whiteColor];
    _scrollView.bounces = NO;

    float x = 0;
    float y = 0;
    float width = CVHomeHeadViewSize.width;
    float height = CVHomeHeadViewSize.height*5/6;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(x, y, width, height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    for (int i = 0; i < _imageUrlsArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView setImageWithURL:[NSURL URLWithString:_imageUrlsArray[i]]];
        [_scrollView addSubview:imageView];
        
        imageView.tag = kImageTag_Orign + i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImgAction:)];
        [imageView addGestureRecognizer:tapGesture];
        
        x += width;
    }
    
    _scrollView.contentSize = CGSizeMake(x, height);
    [self addSubview:_scrollView];
    
}

#pragma mark - 点击图片???  执行两次
-(void)tapHeadImgAction:(UITapGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    _backImageChoice(_imageLinksArray[imageView.tag - kImageTag_Orign]);
}

#pragma mark - 创建 PageControl
-(void)preparePageControl
{
    float x = 0;
    float y = _scrollView.frame.size.height - 30;
    
    _pageCtl = [[UIPageControl alloc] initWithFrame:CGRectMake(x, y,self.frame.size.width, 30)];
    //设置page点的颜色
    _pageCtl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //设置当前page点的颜色
    _pageCtl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageCtl.numberOfPages = _imageUrlsArray.count;
    [self addSubview:_pageCtl];
}


#pragma mark - UIScrollView

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageCtl.currentPage = _scrollView.contentOffset.x/self.frame.size.width;
    
}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, CVHomeHeadViewSize.height*5/6) ;
//}


@end
