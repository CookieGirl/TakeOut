//
//  HomeFoodListView.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-3.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "ConstValues.h"
#import <UIKit/UIKit.h>


@interface HomeFoodListView : UIView

- (id)initWithFrame:(CGRect)frame AndkFoodCellType:(CVkFoodCellType) kFoodCellType;

-(void)setFoodModelsArray:(NSMutableArray *)foodModelsArray;


@end
