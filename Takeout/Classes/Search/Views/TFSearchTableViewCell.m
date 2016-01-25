//
//  TFSearchTableViewCell.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-11.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#define FontSize 15

#import "TFSearchTableViewCell.h"
#import "ConstValues.h"
#import "UIImageView+WebCache.h"

@interface TFSearchTableViewCell ()
{
    UIImageView *_bgImgView;
    
    UILabel *_iconLabel;
    
    UILabel *_foodNameLabel;
    UILabel *_soldAmountLabel;
    UILabel *_priceLabel;

}
@end

@implementation TFSearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentView];
    }
    return self;
}

#pragma mark - 初始化界面
-(void)initContentView
{
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CVScreenSize.width, TFSearchCellHeight)];
    _bgImgView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_bgImgView];
    
    float width = 100;
    float height = 30;
    float x = CVScreenSize.width - width;
    float y = 20;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width+10, height)];
    iconImageView.contentMode = UIViewContentModeScaleToFill;
    iconImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"locale_tag" ofType:@"png"]];
    [self.contentView addSubview:iconImageView];
    
    _iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _iconLabel.text = @"店铺名";
    _iconLabel.textAlignment = NSTextAlignmentRight;
    _iconLabel.textColor = [UIColor whiteColor];
    _iconLabel.font = [UIFont boldSystemFontOfSize:FontSize];
    iconImageView.userInteractionEnabled = YES;
    [iconImageView addSubview:_iconLabel];
    
    width =CVScreenSize.width;
    height = 35;
    x = 0;
    y = TFSearchCellHeight - height;

    UIImageView *clearImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    clearImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"img_clear" ofType:@"png"]];
    clearImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:clearImageView];
                            
    
    float offsetX = 10;
    
    width = (CVScreenSize.width - 4*offsetX)/3;
    x = CVScreenSize.width/2 - width/2+20;
    
    _soldAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _soldAmountLabel.text = @"已售 0 份";
    _soldAmountLabel.font = [UIFont systemFontOfSize:FontSize];
    _soldAmountLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_soldAmountLabel];

    x = offsetX;
    y += 6;
    _foodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _foodNameLabel.text = @"食物名";
    _foodNameLabel.textAlignment = NSTextAlignmentLeft;
    _foodNameLabel.font = [UIFont boldSystemFontOfSize:FontSize + 3];
    [self.contentView addSubview:_foodNameLabel];
    
    x = CVScreenSize.width - width - offsetX;
    y -= 6;
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _priceLabel.textColor = CVBlueColor;
    _priceLabel.text = @"¥8.0";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = [UIFont systemFontOfSize:FontSize + 1];
    [self.contentView addSubview:_priceLabel];
    
    //_iconLabel.backgroundColor = [UIColor blackColor];
   // _soldAmountLabel.backgroundColor = [UIColor grayColor];
}

#pragma mark - 传递参数,填充数据

-(void)setFoodModel:(FoodModel *)foodModel
{
    NSString *placeholderPath = [[NSBundle mainBundle] pathForResource:@"picture_not_available" ofType:@"png"];
    [_bgImgView setImageWithURL:[NSURL URLWithString:foodModel.foodImgUrl] placeholderImage:[UIImage imageWithContentsOfFile:placeholderPath]];
    
    _iconLabel.text = foodModel.foodRestaurant;
    _foodNameLabel.text = foodModel.foodName;
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.1f",foodModel.foodPrice];
    
    // 右上角图标
    CGSize iconLabelSize = [foodModel.foodRestaurant boundingRectWithSize:CGSizeMake(999, _iconLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FontSize]} context:nil].size;
    
    UIImageView *iconImageView = (UIImageView *)_iconLabel.superview;
    _iconLabel.frame = CGRectMake(20, 0, iconLabelSize.width, 27);
    float x = CVScreenSize.width - CGRectGetWidth(_iconLabel.frame) - 30;
    iconImageView.frame = CGRectMake(x, 5, CGRectGetWidth(_iconLabel.frame) + 30, 27);
    
    // 食物名称
    CGSize foodNameSize = [foodModel.foodName boundingRectWithSize:CGSizeMake(999, _foodNameLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _foodNameLabel.font} context:nil].size;
    
    x = 5;
    _foodNameLabel.frame = CGRectMake(x, CGRectGetMinY(_soldAmountLabel.frame), foodNameSize.width, 35);

    //  颜色字符串处理
    NSMutableAttributedString *soldStr = [[NSMutableAttributedString alloc]
                                          initWithString:@"已售份"
                                          attributes:
                                          @{NSFontAttributeName:[UIFont systemFontOfSize:FontSize],
                                            NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *soldAmountStr = [[NSAttributedString alloc]
                                         initWithString:
                                         [NSString stringWithFormat:@" %d ",foodModel.soldAmount]
                                         attributes:
                                         @{NSFontAttributeName:[UIFont systemFontOfSize:FontSize],
                                           NSForegroundColorAttributeName:CVMainColor}];
    [soldStr insertAttributedString:soldAmountStr atIndex:2];
    _soldAmountLabel.attributedText = soldStr;

    
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
