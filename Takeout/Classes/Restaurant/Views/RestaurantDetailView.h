//
//  RestaurantDetailView.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-8.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#define DetailView_Width  220


enum
{
    DetailBtnTag_Tele1 = 391,
    DetailBtnTag_Tele2,
    DetailBtnTag_Comment,
};

#import <UIKit/UIKit.h>
#import "RestaurantModel.h"

@interface RestaurantDetailView : UIView

-(id)initWithOrignPoint:(CGPoint) orign ;// AndCommentCount:(NSInteger)count;

//-(void)setDetailDictionary:(NSMutableDictionary *)restaurantDetailDic;
-(void)setRestaurantDetailModel:(RestaurantModel *)restaurantModel;

@property (nonatomic,copy) void (^backBtnTag)(int,NSString *) ;//(NSString *);

@end
