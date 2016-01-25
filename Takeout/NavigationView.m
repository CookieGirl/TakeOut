//
//  NavigationView.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-15.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "NavigationView.h"
#import "ConstValues.h"

@interface NavigationView ()
{
    CGSize wholeSize;
}
@end

@implementation NavigationView

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 20, CVScreenSize.width, MyNaviViewHeight)];
    wholeSize = self.frame.size;
    
    if (self) {
        self.backgroundColor = CVMainColor;
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setLeftButtonTitle:(NSString *)leftTitleStr
{
    CGSize strSize = [leftTitleStr boundingRectWithSize:CGSizeMake(999, wholeSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:NAVI_FONTSIZE]} context:nil].size;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, strSize.width + 5, wholeSize.height);
    [backBtn setTitle:leftTitleStr forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE];
    backBtn.tag = kBtnTag_Back;
    [backBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, wholeSize.height-1, wholeSize.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self addSubview:lineView];
}

-(void)btnClicked:(UIButton *)button
{
    switch (button.tag) {
        case kBtnTag_Back:
            _backBtnTag(kBtnTag_Back);
            break;
            
        default:
            break;
    }
}


@end
