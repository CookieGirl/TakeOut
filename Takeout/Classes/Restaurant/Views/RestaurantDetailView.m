//
//  RestaurantDetailView.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-8.
//  Copyright (c) 2014年 geowind. All rights reserved.
//


#import "RestaurantDetailView.h"
#import "ConstValues.h"

@interface RestaurantDetailView ()
{
    UILabel *_resNameLabel;
    UILabel *_detailLabel;
    UILabel *_keyWordsLabel;
    UILabel *_telephoneLabel1;
    UILabel *_telephoneLabel2;
    UILabel *_businessTimeLabel;
    UILabel *_othersLabel;
    UILabel *_addressLabel;
    
    UIButton *_commentBtn;
    
    //UILabel *teleLabel;
    UIView *_centerView;
    float _viewWidth;
    float fontSize ;
    
}
@end

@implementation RestaurantDetailView

-(id)initWithOrignPoint:(CGPoint) orign // AndCommentCount:(NSInteger)count
{
    self = [super initWithFrame:CGRectMake(orign.x, orign.y, DetailView_Width, CVScreenSize.height - 20 - HeadBarHeight)];
    if (self) {
        fontSize = 14;
        [self createConstView];
    }
    return self;
}

-(void)createConstView
{
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 3, self.frame.size.height)];
    leftView.contentMode = UIViewContentModeScaleToFill;
    leftView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"res_detail_left" ofType:@"png"]];
    [self addSubview:leftView];
    
    _viewWidth = self.frame.size.width - CGRectGetWidth(leftView.frame);
    
    _resNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _viewWidth,40)];
    _resNameLabel.textAlignment = NSTextAlignmentCenter;
    _resNameLabel.font = [UIFont boldSystemFontOfSize:18];
    _resNameLabel.textColor = CVMainColor;
    _resNameLabel.text = @"餐厅名";
    [self addSubview:_resNameLabel];

#pragma mark - 横线以下，中间固定高度部分
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, 100)];
    [self addSubview:_centerView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, _viewWidth - 10, 2)];
    lineView.backgroundColor = [UIColor grayColor];
    [_centerView addSubview:lineView];
    
    //  横线以下
    float offsetX = 5 ;
    float offsetY = 5;
    float x = offsetX;
    float y = offsetY;
    float width = 45;
    float height = 30;
    
    NSString *teleImgPath = [[NSBundle mainBundle] pathForResource:@"ic_call" ofType:@"png"];
    
     UILabel *teleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    teleLabel.text = @"电 话:";
    teleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_centerView addSubview:teleLabel];
    
    x = CGRectGetMaxX(teleLabel.frame) + offsetX;
    width = 100;
    _telephoneLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _telephoneLabel1.font = [UIFont systemFontOfSize:fontSize];
    _telephoneLabel1.text = @"01234567891";
    [_centerView addSubview:_telephoneLabel1];
    
    y = CGRectGetMaxY(_telephoneLabel1.frame);
    _telephoneLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _telephoneLabel2.font = _telephoneLabel1.font;
    _telephoneLabel2.text = @"01234567891";
    [_centerView addSubview:_telephoneLabel2];
    
    x = CGRectGetMaxX(_telephoneLabel1.frame);
    y = CGRectGetMinY(_telephoneLabel1.frame);
    UIButton *telephoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telephoneBtn.frame = CGRectMake(x, y +5, height - 10, height - 10);
    [telephoneBtn setBackgroundImage:[UIImage imageWithContentsOfFile:teleImgPath] forState:UIControlStateNormal];
    telephoneBtn.contentMode = UIViewContentModeScaleToFill;
    telephoneBtn.tag = DetailBtnTag_Tele1;
    [telephoneBtn addTarget:self action:@selector(didBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:telephoneBtn];
    
    y = CGRectGetMaxY(_telephoneLabel1.frame);
    telephoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telephoneBtn.frame = CGRectMake(x, y + 5, height - 10, height -10);
    [telephoneBtn setBackgroundImage:[UIImage imageWithContentsOfFile:teleImgPath] forState:UIControlStateNormal];
    telephoneBtn.contentMode = UIViewContentModeScaleToFill;
    telephoneBtn.tag = DetailBtnTag_Tele2;
    [telephoneBtn addTarget:self action:@selector(didBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:telephoneBtn];
    
    x = CGRectGetMinX(teleLabel.frame);
    y = CGRectGetMaxY(_telephoneLabel2.frame) + offsetY;
    UILabel *businessTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 70, height)];
    businessTimeLabel.text = @"营业时间:";
    businessTimeLabel.font = teleLabel.font;
    [_centerView addSubview:businessTimeLabel];
    
    x = CGRectGetMaxX(businessTimeLabel.frame);
    _businessTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _businessTimeLabel.font = _telephoneLabel1.font;
    _businessTimeLabel.textColor = [UIColor greenColor];
    _businessTimeLabel.text = @"01:00 - 01:00";
    [_centerView addSubview:_businessTimeLabel];
    
#pragma mark - 底部按钮
    height = 40;
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(CGRectGetMaxX(leftView.frame), self.frame.size.height - height, _viewWidth, height - 1);
    [_commentBtn setTitle:[NSString stringWithFormat:@"已有0条评论"] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_commentBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"res_item_nor" ofType:@"png"]] forState:UIControlStateNormal];
    [_commentBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"res_item_sel" ofType:@"png"]] forState:UIControlStateHighlighted];
    _commentBtn.tag = DetailBtnTag_Comment;
    [_commentBtn addTarget:self action:@selector(didBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentBtn];
    
    UIImageView *rightArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - height - 7, 0, height, height)];
    rightArrowView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ic_arrow_right" ofType:@"png"]];
    rightArrowView.contentMode = UIViewContentModeScaleToFill;
    [_commentBtn addSubview:rightArrowView];
    
}


#pragma mark - Button 按钮时间，打电话，查看评论
-(void)didBtnClicked:(UIButton *)button
{
    switch (button.tag) {
        case DetailBtnTag_Tele1:
            _backBtnTag(DetailBtnTag_Tele1,_telephoneLabel1.text);

            break;
            
        case DetailBtnTag_Tele2:
            _backBtnTag(DetailBtnTag_Tele2,_telephoneLabel2.text);
            
            break;
            
        case DetailBtnTag_Comment:
            _backBtnTag(DetailBtnTag_Tele1,@" ");
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 传入参数
-(void)setRestaurantDetailModel:(RestaurantModel *)restaurantModel
{
    _resNameLabel.text = restaurantModel.restaurantName;
    _telephoneLabel1.text = restaurantModel.telephone1;
    _telephoneLabel2.text = restaurantModel.telephone2;
    _businessTimeLabel.text = restaurantModel.businessTime;
    
    NSString *commentStr = [NSString stringWithFormat:@"已有%d条评论",restaurantModel.commentCount];
    [_commentBtn setTitle:commentStr forState:UIControlStateNormal];
    
    NSString *detailStr = restaurantModel.restaurantDetail;
    NSString *keywordsStr = restaurantModel.KeyWords;
    NSString *othersStr = restaurantModel.others;
    NSString *addressStr = restaurantModel.address;
    
    float width = _viewWidth - 20;
    float height = 20;
    
    //  详情
    CGSize detailSize = [detailStr boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    // 关键字
    CGSize keyWordsSize =[keywordsStr boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    width -= 50;
    //  其他
    CGSize othersSize = [othersStr boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;

    // 地址
    CGSize addressSize = [addressStr boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    float x = 10;
    float y = CGRectGetMaxY(_resNameLabel.frame);
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, detailSize.width, detailSize.height)];
    _detailLabel.center = CGPointMake(_viewWidth/2, y + detailSize.height/2);
    _detailLabel.font = [UIFont systemFontOfSize:fontSize - 1];
    _detailLabel.textColor = [UIColor blueColor];
    _detailLabel.text = restaurantModel.restaurantDetail;// @"餐厅详情";
    _detailLabel.numberOfLines = 0;
    _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [self addSubview:_detailLabel];
    
    y = CGRectGetMaxY(_detailLabel.frame) + 5;
    _keyWordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, keyWordsSize.width, keyWordsSize.height)];
    _keyWordsLabel.center = CGPointMake(_viewWidth/2, y + keyWordsSize.height/2);
    _keyWordsLabel.font = [UIFont boldSystemFontOfSize:14];
    _keyWordsLabel.textColor = [UIColor grayColor];
    _keyWordsLabel.text = restaurantModel.KeyWords; // @"关键词";
    _keyWordsLabel.numberOfLines = 0;
    _keyWordsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self addSubview:_keyWordsLabel];

    x = 3;
    y = CGRectGetMaxY(_keyWordsLabel.frame) + 5;
    _centerView.frame = CGRectMake(x, y, _centerView.frame.size.width, _centerView.frame.size.height);
    
    x = 5;
    y = CGRectGetMaxY(_centerView.frame) + 5;
    width = 50;
    height = 20;
    
    UILabel *othersLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width,height)];
    othersLabel.text = @"其他:";
    othersLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:othersLabel];
    
    x = CGRectGetMaxX(othersLabel.frame);
    _othersLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, othersSize.width, othersSize.height)];
    _othersLabel.text = restaurantModel.others; //@"(others ******)";
    _othersLabel.numberOfLines = 0;
    _othersLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _othersLabel.font = [UIFont systemFontOfSize:fontSize];
    _othersLabel.textColor = [UIColor grayColor];
    [self addSubview:_othersLabel];
    
    x = 5;
    y = CGRectGetMaxY(_othersLabel.frame) + 5;
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    addressLabel.text =  @"地址:";
    addressLabel.font = othersLabel.font;
    //addressLabel.textColor = [UIColor grayColor];
    [self addSubview:addressLabel];
    
    x = CGRectGetMaxX(addressLabel.frame) ;
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, addressSize.width, addressSize.height)];
    _addressLabel.text = restaurantModel.address; //@"(others ******)";
    _addressLabel.numberOfLines = 0;
    _addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _addressLabel.font = [UIFont systemFontOfSize:fontSize];
    _addressLabel.textColor = [UIColor grayColor];
    [self addSubview:_addressLabel];
}


@end
