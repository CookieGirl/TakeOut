//
//  NavigationView.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-15.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

typedef enum : NSUInteger {
    kBtnTag_Back= 261,
    kBtnTag_Right,

} kMyNaviViewBtnTag;

#define MyNaviViewHeight   (CVNaviBarHeight - 20)

#import <UIKit/UIKit.h>

@interface NavigationView : UIView

@property (nonatomic,copy) void (^backBtnTag)(kMyNaviViewBtnTag);

-(void)setLeftButtonTitle:(NSString *)leftTitleStr;


@end
