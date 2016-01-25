//
//  HeadImageWebViewController.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-17.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadImageWebViewController : UIViewController

@property (nonatomic,copy) NSString *webUrlStr;

-(id)initWithWebUrl:(NSString *)url;

@end
