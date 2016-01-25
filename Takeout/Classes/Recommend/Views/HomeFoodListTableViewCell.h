//
//  HomeFoodListTableViewCell.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-3.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "ConstValues.h"
#import <UIKit/UIKit.h>
#import "FoodModel.h"


@interface HomeFoodListTableViewCell : UITableViewCell

-(void)setFoodModel:(FoodModel *)foodModel AndkFoodCellType:(CVkFoodCellType)kFoodCellType;

@end
