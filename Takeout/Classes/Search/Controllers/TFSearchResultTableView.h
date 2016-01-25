//
//  TFSearchResultTableView.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-11.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

//typedef enum : NSUInteger {
//    kSequenceType_Default = 330,
//    kSequenceType_Price,
//    kSequenceType_Hot,
//} kSequenceType;

#import <UIKit/UIKit.h>

@interface TFSearchResultTableView : UITableView

-(void)searchKeyWords:(NSString *)keywords AndSequenceType:(NSString *)sequenceTypeStr;

@property (nonatomic,retain) UIButton *sequenceBtn;

@end
