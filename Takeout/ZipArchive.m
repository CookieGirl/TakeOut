//
//  ZipArchive.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-10.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "ZipArchive.h"

@implementation ZipArchive

static ZipArchive * manager=nil;

+(id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[ZipArchive alloc]init];
    });
    
    return manager;
}

-(id)init
{
    if (self=[super init]) {
        self.path=[NSString stringWithFormat:@"%@/Documents/userInfo.plist",NSHomeDirectory()];
        self.dic=[NSMutableDictionary dictionaryWithContentsOfFile:self.path];
        if (self.dic ==nil) {
            self.dic =[NSMutableDictionary dictionaryWithCapacity:0];
        }
    }
    return self;
    
}
-(void)synchronize
{
    
    [self.dic writeToFile:self.path atomically:YES];
    
}
+(BOOL)online
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    return [user boolForKey: @"status"];
}

@end
