//
//  ConstValues.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-2.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "ConstValues.h"



/**
 *  此处必须要先内部定义作为全局的变量,在.h文件中加 extern 关键字提供外部接口访问
 */
NSString *const CVTakeoutApplicationId = @"uy5pt942okfgyvylm4lrgtl3qly1fj003z2hih9qkb5qvwzv";
NSString *const CVTakeoutClientKey = @"jt5tdivgyywgci16516rszztw3vrzwx5p6wconetz7uhtidz";

NSString *const CVHomeHeadImageUrl = @"http://pager.u.qiniudn.com";
NSString *const CVFoodDetailTipsStr1 = @"图片仅供参考，请以实物为准";
NSString *const CVFoodDetailTipsStr2 = @"最终解释权归所有";
NSString * CVNoFoodImgPath;


CGSize CVScreenSize;  //320 * 568
CGSize CVTopRightFrameSize;
CGSize CVContentSize;
CGSize CVHomeHeadViewSize;
CGSize CVFoodViewSingleSize;
CGSize CVRestaurantViewSize;

float CVNaviBarHeight = 64;
float CVTabbarHeight = 49; //40
float CVFoodListCellOffsetY = 10;

UIColor * CVMainColor;
UIColor * CVMainBgColor;
UIColor * CVNaviTextColor;
UIColor * CVMainTextColor;
UIColor * CVFoodListBgColor;
UIColor * CVBlueColor;

@implementation ConstValues

+(ConstValues *)sharedConstInstance
{
    static dispatch_once_t onceToken;
    static ConstValues *sharedConstValues = nil;

    dispatch_once(&onceToken, ^{
        sharedConstValues = [[ConstValues alloc] init];
    });
    
    return sharedConstValues;
}

//初始化 常量数据
-(void)initConstValues
{
    CVNoFoodImgPath = [[NSBundle mainBundle] pathForResource:@"picture_not_available" ofType:@"png"];
    
    CVNaviTextColor = [UIColor whiteColor];
    CVMainTextColor = [UIColor colorWithRed:232/255.0 green:77/255.0 blue:35/255.0 alpha:1.0];
    CVMainColor = [UIColor colorWithRed:210/255.0 green:50/255.0 blue:18/255.0 alpha:1.0];
    CVMainBgColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
    CVFoodListBgColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0];
    CVBlueColor = [UIColor colorWithRed:109/255.0 green:174/255.0 blue:255/255.0 alpha:1.0];
    
    CVScreenSize = [[UIScreen mainScreen] bounds].size; // 320*568
    CVTopRightFrameSize = CGSizeMake(CVScreenSize.width/2, CVScreenSize.height/3);
    
    // 中部内容视图
    float contentHeight = CVScreenSize.height - CVNaviBarHeight - CVTabbarHeight;

    CVContentSize = CGSizeMake(CVScreenSize.width, contentHeight);
    CVHomeHeadViewSize = CGSizeMake(CVContentSize.width, CVContentSize.height/3);
    
    CVFoodViewSingleSize = CGSizeMake(150, 120);
    CVRestaurantViewSize = CGSizeMake(300, 70);
    
}


@end
