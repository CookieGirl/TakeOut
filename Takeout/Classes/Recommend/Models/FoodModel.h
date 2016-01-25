//
//  FoodModel.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-3.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodModel : NSObject

@property (nonatomic,copy) NSString *foodID;

@property (nonatomic,copy) NSString *foodName;

@property (nonatomic,copy) NSString *foodImgUrl;

@property (nonatomic,copy) NSString *foodRestaurant;

@property (nonatomic,assign) float foodPrice;

@property (nonatomic,assign) int foodRank;

//@property (nonatomic,copy) NSString *soldAmount;

@property (nonatomic,assign) int soldAmount;

@property (nonatomic,assign) int favouriteAmmount;


@end
