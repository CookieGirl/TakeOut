//
//  RootViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-1.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "RestaurantViewController.h"
#import "SearchViewController.h"
#import "MyViewController.h"
#import "ConstValues.h"

#import <AVOSCloud/AVOSCloud.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    // 设置 tabbar 图片透明显示部分
    [[UITabBar appearance] setTintColor:CVMainColor];
    NSArray *classArray = [NSArray arrayWithObjects:@"HomeViewController",@"RestaurantViewController",@"SearchViewController",@"MyViewController", nil];
    
    NSMutableArray *controllersArray = [NSMutableArray array];
    UINavigationController *navi = nil;
    UIViewController *vc = nil;
    
    for (NSString *className in classArray) {
        vc = [[NSClassFromString(className) alloc] init];
        [vc.navigationController.navigationBar setBackgroundColor:[UIColor orangeColor]];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
        
        //设置navigationbar
        /**
         *  系统默认 navigationBar 半透明，子视图的原点默认从 屏幕的（0，0）点为参考点，相当于整个视图中不存在navigationbar 这个视图。
         
         navi.navigationBar.translucent = NO; ／／ 设置为不透明，
         不透明之后，子视图的参考点，会以 navigationbar 左下方为参考点，即相对于屏幕的（0，64）计算，
         自定义 navigationbar 相当于自定义一个ui view ，它实质是一个 ui view。
         [navigationBar addSubview:view]便可;
         UIBarButtonItem 不是一个 view，它继承自：NSObject ，是一个对象；凡事可见的，才是view
         */
        navi.navigationBar.translucent = NO;
        
        UIImageView *naviView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CVScreenSize.width, CVNaviBarHeight - 20)];
        naviView.backgroundColor = CVMainColor;
        [navi.navigationBar addSubview:naviView];
        
        [controllersArray addObject:navi];
    }

    self.viewControllers = controllersArray;
    
    //[self testDataCreateClass];
   
}

-(void)testDataCreateClass
{
    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar1" forKey:@"foo"];
    [testObject save];
    NSLog(@"===================testobj%@=======",testObject);
    
    AVObject *gameScore = [AVObject objectWithClassName:@"GameScore"];
    [gameScore setObject:[NSNumber numberWithInt:1337] forKey:@"score"];
    [gameScore setObject:@"Steve" forKey:@"playerName"];
    [gameScore setObject:[NSNumber numberWithBool:NO] forKey:@"cheatMode"];
    [gameScore save];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
