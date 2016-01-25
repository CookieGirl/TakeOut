//
//  ConstValues.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-2.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#define NAVI_FONTSIZE 18
#define HeadBarHeight  45

//#define <#macro#>

typedef enum : NSUInteger {
    CVkFoodCellType_Home = 221,
    CVkFoodCellType_Restaturant,
} CVkFoodCellType;


#import <Foundation/Foundation.h>

extern NSString *const CVTakeoutApplicationId;
extern NSString *const CVTakeoutClientKey;

extern NSString *const CVHomeHeadImageUrl; // URL

extern NSString *const CVFoodDetailTipsStr1;
extern NSString *const CVFoodDetailTipsStr2;

extern NSString *CVNoFoodImgPath;

extern CGSize CVScreenSize;
extern CGSize CVContentSize;        // 整个窗体中部内容大小
extern CGSize CVHomeHeadViewSize;   
extern CGSize CVTopRightFrameSize; //首页右上角设置弹出框大小
extern CGSize CVFoodViewSingleSize; //单个食物视图大小,cell里面的
extern CGSize CVRestaurantViewSize; //单个店铺 cell 大小

extern float CVNaviBarHeight;     // 整个窗体中部内容起始y坐标
extern float CVTabbarHeight;
extern float CVFoodListCellOffsetY;

extern UIColor * CVMainBgColor;
extern UIColor * CVMainColor;
extern UIColor * CVFoodListBgColor;

extern UIColor * CVMainTextColor;
extern UIColor * CVNaviTextColor;
extern UIColor * CVBlueColor;

@interface ConstValues : NSObject

#pragma mark - 程序是否第一次启动
@property (nonatomic, assign) BOOL isFirstRunning;

//+方法,外部可调用，用来获取一个单例对象
+(ConstValues *)sharedConstInstance;

-(void)initConstValues;

@end
