//
//  RestaurantModel.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-3.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantModel : NSObject

// 详情界面
@property (nonatomic,copy) NSString *restaurantName;

@property (nonatomic,copy) NSString *restaurantDetail;

@property (nonatomic,copy) NSString *KeyWords;

@property (nonatomic,copy) NSString *telephone1;

@property (nonatomic,copy) NSString *telephone2;

@property (nonatomic,copy) NSString *businessTime;

@property (nonatomic,copy) NSString *others;

@property (nonatomic,copy) NSString *address;

//
@property (nonatomic,copy) NSString *restaurantLocale;

@property (nonatomic,copy) NSString *restaurantID;

@property (nonatomic,copy) NSString *restaurantImgUrl;

@property (nonatomic,assign) int commentCount;

@end
