//
//  ZipArchive.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-10.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipArchive : NSObject

+(id)shareManager;
-(void)synchronize;

@property(nonatomic,copy)NSString*userName;
@property(nonatomic,copy)NSString*passWord;


@property (nonatomic,retain)NSMutableDictionary * dic;
@property (nonatomic,copy)NSString *path;

+(BOOL)online;

@end
