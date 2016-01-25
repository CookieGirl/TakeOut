//
//  CommentModel.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-8.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic,copy) NSString *commentID;

@property (nonatomic,copy) NSString *locale;

@property (nonatomic,copy) NSString *author;

@property (nonatomic,copy) NSString *gender;

@property (nonatomic,copy) NSString *commentStr;

@property (nonatomic,copy) NSString *replyStr;

@property (nonatomic,retain) NSDate *createDate;


@end
