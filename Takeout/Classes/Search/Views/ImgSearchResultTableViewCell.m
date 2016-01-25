//
//  ImgSearchResultTableViewCell.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-10.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#define FontSize 13

#import "ConstValues.h"
#import "ImgSearchResultTableViewCell.h"

@interface ImgSearchResultTableViewCell ()
{
    UILabel *_foodNameLabel;
    UILabel *_soldAmountLabel;
    UILabel *_favoriteLabel;
    UILabel *_priceLabel;
    
}
@end

@implementation ImgSearchResultTableViewCell

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
    float x = 10;
    float y = 10;
    float width = CVScreenSize.width - 2*x - 50;
    float height = 25;
    
    _foodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _foodNameLabel.text = @"食物名";
    _foodNameLabel.font = [UIFont boldSystemFontOfSize:FontSize + 3];
    [self.contentView addSubview:_foodNameLabel];
    
    width = 45;
    x = CVScreenSize.width - width - 10;
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _priceLabel.textColor = CVBlueColor;
    _priceLabel.text = @"¥8.0";
    _priceLabel.font = [UIFont systemFontOfSize:FontSize + 2];
    [self.contentView addSubview:_priceLabel];
    
    x = 10;
    y += height ;
    width = (CVScreenSize.width - 2*10)/3;
    height -= 5;
    _soldAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _soldAmountLabel.text = @"已售 0 份";
    [self.contentView addSubview:_soldAmountLabel];
    
    x = CVScreenSize.width/2 - width/2;
    _favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _favoriteLabel.text = @"0 人收藏";
    _favoriteLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_favoriteLabel];
    
    
//    _foodNameLabel.backgroundColor = [UIColor grayColor];
//    _soldAmountLabel.backgroundColor = [UIColor lightGrayColor];
//    _favoriteLabel.backgroundColor = [UIColor redColor];
//    _priceLabel.backgroundColor = [UIColor blackColor];
    
    
}

#pragma mark - 传递参数,填充数据
-(void)setFoodModel:(FoodModel *)foodModel
{
    _foodNameLabel.text = foodModel.foodName;
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.1f",foodModel.foodPrice];
    
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
    
    NSMutableAttributedString *favoriteStr = [[NSMutableAttributedString alloc]
                                          initWithString:@" 人收藏"
                                          attributes:
                                          @{NSFontAttributeName:[UIFont boldSystemFontOfSize:FontSize],
                                            NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *favoriteAmountStr = [[NSAttributedString alloc]
                                         initWithString:
                                         [NSString stringWithFormat:@"%d",foodModel.favouriteAmmount]
                                         attributes:
                                         @{NSFontAttributeName:[UIFont boldSystemFontOfSize:FontSize],
                                           NSForegroundColorAttributeName:CVMainColor}];
    [favoriteStr insertAttributedString:favoriteAmountStr atIndex:0];
    
    
    _soldAmountLabel.attributedText = soldStr;
    _favoriteLabel.attributedText = favoriteStr;
    
    
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
