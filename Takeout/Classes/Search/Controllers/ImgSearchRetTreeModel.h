//
//  ImgSearchRetTreeModel.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-16.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgSearchRetTreeModel : NSObject

@property (nonatomic,copy) NSString *restaurantName;

@property (nonatomic,strong) NSMutableArray *sectionFoodsArray;

@property (nonatomic,assign) BOOL isOpen;

@end
