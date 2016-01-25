//
//  FoodDetailViewController.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-4.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "FoodModel.h"
#import <UIKit/UIKit.h>

@interface FoodDetailViewController : UIViewController

-(id)initWithFoodID:(NSString *) foodID;

@property (nonatomic,copy) FoodModel *foodModel;

@end
