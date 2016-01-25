//
//  HeadImageWebViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-17.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "HeadImageWebViewController.h"
#import "ConstValues.h"
#import "NavigationView.h"

@interface HeadImageWebViewController ()
{
    //NSString *_webUrlStr;
}
@end

@implementation HeadImageWebViewController

-(id)initWithWebUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _webUrlStr = url;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    NavigationView *naviView = [[NavigationView alloc] init];
    [naviView setLeftButtonTitle:@"< 返回"];
    
    naviView.backBtnTag = ^(kMyNaviViewBtnTag btnTag){
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:naviView];
    
    [self loadView];
}

-(void)loadWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CVNaviBarHeight, CVScreenSize.width,CVContentSize.height)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrlStr]];
    [self.view addSubview:webView];
    
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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
