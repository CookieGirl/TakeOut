//
//  HomeHeadView.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-2.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

enum
{
    kImageTag_Orign = 101,
    
};

#import <UIKit/UIKit.h>

@interface HomeHeadView : UIView <UIScrollViewDelegate>

@property (nonatomic,copy) void (^backImageChoice)(NSString *);

-(void)setImageUrlsArray:(NSArray *)imageUrlsArray linksArray:(NSArray *)imageLinksArray;



@end
