//
//  CommentTableViewCell.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-8.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell


-(void)setCommentModel:(CommentModel *) commentModel;

@property (nonatomic,assign) float cellHeight;

@end
