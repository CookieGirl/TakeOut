//
//  AppDelegate.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-1.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloud/AVAnalytics.h>
#import "AppDelegate.h"
#import "RootViewController.h"
#import "ConstValues.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId:CVTakeoutApplicationId
                      clientKey:CVTakeoutClientKey];
    
    //统计应用启动情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // 初始化全局数据
    ConstValues *constValuesInstance = [ConstValues sharedConstInstance];
    [constValuesInstance performSelectorOnMainThread:@selector(initConstValues) withObject:nil waitUntilDone:YES];
    
#if 0
    /*
        NSUserDefaults用于识别程序是否是第一次启动，从而判断是否呈现引导页
     */

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"isFirstLauch"]) {
        [userDefaults setObject:@"YES" forKey:@"isFirstLauch"];
        [userDefaults synchronize];
        
    }else{
        
    }
    
#endif
    
//    if (constValuesInstance.isFirstRunning) {
//        
//    }else{
//        
//    }
    
    //创建根视图控制器
    RootViewController *rvc = [[RootViewController alloc] init];
    
    self.window.rootViewController = rvc;
    
    self.window.backgroundColor = CVMainBgColor;
    [self.window makeKeyAndVisible];
    
    //设置状态条 格式，黑色状态条，白色字体
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //  加载最后才能显示，不然状态条全白,
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.window addSubview:view];
    NSLog(@"%@",NSHomeDirectory());
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
