//
//  RestaurantTableViewCell.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-3.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantModel.h"

@interface RestaurantTableViewCell : UITableViewCell


-(void)setRestaurantModel:(RestaurantModel *)restaurantModel;

@property (nonatomic,copy) void (^backRestaurantID)(NSString *);

@end
