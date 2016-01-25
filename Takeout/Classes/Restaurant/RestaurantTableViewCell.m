//
//  RestaurantTableViewCell.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-3.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "RestaurantTableViewCell.h"
#import "RestaurantModel.h"
#import "UIImageView+WebCache.h"
#import "ConstValues.h"

@interface RestaurantTableViewCell ()
{
    // 视图
    UIImageView *_imageView ;
    UILabel *_restaurantNameLabel;
    UILabel *_keyWordsLabel;
    UILabel *_localeLabel;
    UILabel *_businessTimeLabel;
    
    // 数据
    NSString *_restaurantID;

}
@end

@implementation RestaurantTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float offsetX = 3;
        float offsetY = 10;
        
        UIButton *view = [self createSingleView];
        view.frame = CGRectMake(offsetX, offsetY, view.frame.size.width, view.frame.size.height);
        [self.contentView addSubview:view];
        
        //self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_big"]];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 定制单个cell 内部视图
-(UIButton *)createSingleView
{
    float view_width = CVRestaurantViewSize.width;
    float view_height = CVRestaurantViewSize.height;
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view_width,view_height)];
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [view setBackgroundImage:[UIImage imageNamed:@"foodview_bg_nor"] forState:UIControlStateNormal];
    [view setBackgroundImage:[UIImage imageNamed:@"foodview_bg_high"] forState:UIControlStateHighlighted];
    [view addTarget:self action:@selector(restaurantDidSelected:) forControlEvents:UIControlEventTouchUpInside];

    // 添加子视图
    float offsetX = 2;
    
    float x = offsetX;
    float y = view_height/5;
    float height = view_height - 2*y;
    float width = height * 2;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 8;
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [view addSubview:_imageView];
    
    // 右上角图标
    width = 50;
    height = 20;
    x = view_width - width;
    y = 0;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    imgView.image = [UIImage imageNamed:@"locale_tag"];
    [view addSubview:imgView];
    
    
    _localeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x , y, width - 2*offsetX, height)];
    _localeLabel.font = [UIFont systemFontOfSize:NAVI_FONTSIZE-7];
    _localeLabel.textAlignment = NSTextAlignmentRight;
    _localeLabel.text = @"弘辰";
    _localeLabel.textColor = [UIColor whiteColor];
    [view addSubview:_localeLabel];
    
    // 文字视图
    float offsetY = 2;
    x = CGRectGetMaxX(_imageView.frame)+2*offsetX;
    y = offsetY;
    width = CGRectGetMinX(imgView.frame) - x;
    height = (view_height-2*offsetY)/3;
    _restaurantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _restaurantNameLabel.font = [UIFont boldSystemFontOfSize:NAVI_FONTSIZE];
    _restaurantNameLabel.text = @"店铺名称";
    _restaurantNameLabel.textColor = CVMainTextColor;
    [view addSubview:_restaurantNameLabel];
    
    y = CGRectGetMaxY(_restaurantNameLabel.frame);
    width = view_width - x - offsetX;
    _keyWordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _keyWordsLabel.text = @"简介";
    _keyWordsLabel.font = [UIFont systemFontOfSize:NAVI_FONTSIZE - 5.5];
    _keyWordsLabel.textColor = [UIColor blackColor];
    _keyWordsLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_keyWordsLabel];
    
    y = CGRectGetMaxY(_keyWordsLabel.frame);
    _businessTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _businessTimeLabel.text = @"营业时间：";
    _businessTimeLabel.font = [UIFont systemFontOfSize:NAVI_FONTSIZE - 4];
    _businessTimeLabel.textColor = [UIColor lightGrayColor];
    _businessTimeLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_businessTimeLabel];

    return view;
}

-(void)restaurantDidSelected:(UIButton *)button
{
    if (!_restaurantID)
        return;
    _backRestaurantID(_restaurantID);
}


#pragma mark - 加载完数据后，设置数据
-(void)setRestaurantModel:(RestaurantModel *)restaurantModel
{
    _restaurantID = restaurantModel.restaurantID;
    [_imageView setImageWithURL:[NSURL URLWithString:restaurantModel.restaurantImgUrl] placeholderImage:[UIImage imageNamed:@"img_loading"]];
    _restaurantNameLabel.text = restaurantModel.restaurantName;
    _localeLabel.text = restaurantModel.restaurantLocale;
    _keyWordsLabel.text = restaurantModel.KeyWords;
    _businessTimeLabel.text = [NSString stringWithFormat:@"营业时间：%@",restaurantModel.businessTime];
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
