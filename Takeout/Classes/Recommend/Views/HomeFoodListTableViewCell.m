//
//  HomeFoodListTableViewCell.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-3.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "HomeFoodListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface HomeFoodListTableViewCell ()
{
    UILabel *_topLeftLabel;
    UILabel *_topRightLabel;
    UIImageView *_middleImageView;
    UILabel *_bottomLeftLabel;
    UILabel *_bottomRightLabel;
    
    NSString *_foodID;
    CVkFoodCellType _foodCellType;
}
@end

@implementation HomeFoodListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 单个食物视图的参数
        float x = CVFoodListCellOffsetY/2;
        float y = CVFoodListCellOffsetY;
        
        UIButton *foodView = [self createSingleFoodView];
        foodView.frame = CGRectMake(x, y, foodView.frame.size.width, foodView.frame.size.height);
        //foodView.userInteractionEnabled = YES;
        [self.contentView addSubview:foodView];
        
        //  选中 cell 不改变背景色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor]; // 设置父视图背景色可见
        
    }
    return self;
}


#pragma mark - 创建食物视图
-(UIButton *)createSingleFoodView
{
    float view_width = CVFoodViewSingleSize.width;
    float view_height = CVFoodViewSingleSize.height;
    float fontSize = 13;
    
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view_width, view_height)];
    //view.userInteractionEnabled = NO;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [[UIColor grayColor] CGColor];
    view.layer.cornerRadius = 15.0;
    [view setBackgroundImage:[UIImage imageNamed:@"foodview_bg_nor"] forState:UIControlStateNormal];
    [view setBackgroundImage:[UIImage imageNamed:@"foodview_bg_high"] forState:UIControlStateHighlighted];
    [view addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //self.superview
    
    //view.layer.shadowColor = [UIColor blackColor].CGColor;
    //view.layer.shadowOffset = CGSizeMake(14, 24);
    //view.layer.shadowOpacity = 1.5;
    //view.layer.shadowRadius = 10.0;
    
    float offsetX = 7;
    float offsetY = 0;
    
    float x = offsetX;
    float y = offsetY;
    float width = (view_width - 2*offsetX)/2;
    float height = (view_height - 2*offsetY)*2/11;
    
    _topLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width*4/3, height)];
    _topLeftLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    _topLeftLabel.text = @"菜名";
    _topLeftLabel.textColor = CVMainTextColor;
    [view addSubview:_topLeftLabel];
    
    x += _topLeftLabel.frame.size.width - offsetX;
    _topRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width*2/3, height)];
    _topRightLabel.font = [UIFont systemFontOfSize:fontSize];
    _topRightLabel.text = @"¥";
    _topRightLabel.textAlignment = NSTextAlignmentRight;
    _topRightLabel.textColor = [UIColor blueColor];
    [view addSubview:_topRightLabel];
    
    x = offsetX;
    y = view_height - height;
    width = view_width;
    _bottomLeftLabel = [[UILabel alloc] initWithFrame: CGRectMake(x, y, width, height)];
    _bottomLeftLabel.font = [UIFont systemFontOfSize:fontSize];
    _bottomLeftLabel.text = @"restaurant";
    _bottomLeftLabel.textColor = [UIColor blackColor];
    [view addSubview:_bottomLeftLabel];
    
    x = 0;
    y = CGRectGetMaxY(_topLeftLabel.frame);
    height = CGRectGetMinY(_bottomLeftLabel.frame) - CGRectGetMaxY(_topLeftLabel.frame);
    _middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y+1, width, height-2)];
    _middleImageView.contentMode = UIViewContentModeScaleToFill;
    [view addSubview:_middleImageView];
    
    return view;
}

#pragma mark - 按下食物按钮，通知中心，传值
-(void)btnClicked:(UIButton *)button
{
    if (_foodCellType == CVkFoodCellType_Home) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didHomeFoodCellCliked" object:_foodID];
    }else if (_foodCellType == CVkFoodCellType_Restaturant){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didRestaurantFoodCellCliked" object:_foodID];
    }
    
}

#pragma mark - 传入 model 数据
-(void)setFoodModel:(FoodModel *)foodModel AndkFoodCellType:(CVkFoodCellType)kFoodCellType
{
//    _foodID = foodModel.foodID;
    _foodCellType = kFoodCellType;
//    
//    _topLeftLabel.text = foodModel.foodName;
//    _topRightLabel.text = [NSString stringWithFormat:@"¥ %.1f ",foodModel.foodPrice];
//    [_middleImageView setImageWithURL:[NSURL URLWithString:foodModel.foodImgUrl] placeholderImage:[UIImage imageNamed:@"img_loading"]];
//    _bottomLeftLabel.text = foodModel.foodRestaurant;
    
    _foodID = foodModel.foodID;
    
    _topLeftLabel.text = foodModel.foodName == nil ? @"食物名":foodModel.foodName;
    _topRightLabel.text = [NSString stringWithFormat:@"¥ %.1f ",foodModel.foodPrice];
    
    [_middleImageView setImageWithURL:[NSURL URLWithString:foodModel.foodImgUrl] placeholderImage:[UIImage imageNamed:@"img_loading"]];
    
    switch (kFoodCellType) {
        case CVkFoodCellType_Home:
        {
            _bottomLeftLabel.text = foodModel.foodRestaurant;
            //_bottomRightLabel.hidden = YES;
        }
            break;
            
        case CVkFoodCellType_Restaturant:
        {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"已售份" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
            NSAttributedString *subStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",foodModel.soldAmount]  attributes:@{NSForegroundColorAttributeName: CVMainColor}];
            [attrStr insertAttributedString:subStr atIndex:1];
            _bottomLeftLabel.attributedText = attrStr;
            
            //  价格视图下移  右上 -> 右下
            _topRightLabel.frame = CGRectMake(CGRectGetMinX(_topRightLabel.frame), CGRectGetMaxY(_middleImageView.frame), CGRectGetWidth(_topRightLabel.frame), CGRectGetHeight(_topRightLabel.frame));
            //_bottomRightLabel.text =
            //_topRightLabel.hidden = YES;
        }
            break;
            
        default:
            break;
    }

    
    
}

- (void)awakeFromNib
{
    
}

/**
 *  //  选中 cell 不改变背景色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    下面的方法将被屏蔽掉
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
