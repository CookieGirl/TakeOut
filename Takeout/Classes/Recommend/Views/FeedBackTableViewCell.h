//
//  FeedBackTableViewCell.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-15.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedBackModel.h"

@interface FeedBackTableViewCell : UITableViewCell

-(void)setFeedBackModel:(FeedBackModel *) feedBackModel;

@property (nonatomic,assign) float cellHeight;


@end
