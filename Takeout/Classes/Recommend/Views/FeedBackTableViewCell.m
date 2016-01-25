//
//  FeedBackTableViewCell.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-15.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "FeedBackTableViewCell.h"
#import "ConstValues.h"

@interface FeedBackTableViewCell ()
{
    UILabel *_authorLabel;
    UIImageView *_genderImgView;
    
    UILabel *_userCommentLabel;
    UILabel *_teamReplyLabel;
    
}
@end

@implementation FeedBackTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentView];
        
    }
    return self;
}

#pragma mark - 创建视图
-(void)initContentView
{
    float fontSize = 14;
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _authorLabel.textColor = CVMainColor;
    _authorLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.contentView addSubview:_authorLabel];
    
    _genderImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _genderImgView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_genderImgView];
    
    _userCommentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _userCommentLabel.font = [UIFont systemFontOfSize:fontSize];
    _userCommentLabel.numberOfLines = 0;
    [self.contentView addSubview:_userCommentLabel];
    
    _teamReplyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _teamReplyLabel.numberOfLines = 0;
    _teamReplyLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    _teamReplyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //_teamReplyLabel.backgroundColor = CVMainBgColor;
    [self.contentView addSubview:_teamReplyLabel];

    
}

#pragma mark - 设置数据
-(void)setFeedBackModel:(FeedBackModel *)feedBackModel
{
    float x = 10;
    float y = 5;
    float height = 30;
    
    CGSize authorSize = [feedBackModel.author boundingRectWithSize:CGSizeMake(999,height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    _authorLabel.frame = CGRectMake(x, y, authorSize.width, height);
    _authorLabel.text = feedBackModel.author;
    
    
    float width = 20;
    height = 20;
    x = CGRectGetMaxX(_authorLabel.frame) + 10;
    y = y + (CGRectGetHeight(_authorLabel.frame) -height)/2;
    
    NSString *icStr = [feedBackModel.userGender isEqualToString:@"男"]?@"ic_boy":@"ic_girl";
    _genderImgView.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:icStr ofType:@"png"]];
    _genderImgView.frame = CGRectMake(x, y, width, height);
    
    x = 10;
    y = CGRectGetMaxY(_authorLabel.frame) + 7;
    width = CVScreenSize.width - 2*x;
    
    CGSize commentSize = [feedBackModel.userComment boundingRectWithSize:CGSizeMake(width,999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_userCommentLabel.font} context:nil].size;
    _userCommentLabel.frame = CGRectMake(x, y, width, commentSize.height);
    _userCommentLabel.text = feedBackModel.userComment;

    if (feedBackModel.teamReply.length <= 0) {
        _teamReplyLabel.hidden = YES;
        _cellHeight = CGRectGetMaxY(_userCommentLabel.frame) + 10 ;
        return;
    }
    
    _teamReplyLabel.hidden = NO;
    x += 5;
    y += commentSize.height + 10;
    width -= 10;
    
    NSString *teamReplyStr = [@"团队回复: " stringByAppendingString:feedBackModel.teamReply];
    CGSize replySize = [teamReplyStr boundingRectWithSize:CGSizeMake(width,999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_teamReplyLabel.font} context:nil].size;
    _teamReplyLabel.frame = CGRectMake(x, y, width, replySize.height);

    NSMutableAttributedString *replyStr = [[NSMutableAttributedString alloc] initWithString:teamReplyStr attributes:@{NSFontAttributeName: _teamReplyLabel.font}];
    NSRange range = {0,5};
    [replyStr addAttributes:@{NSForegroundColorAttributeName:CVMainColor} range:range];
  
    _teamReplyLabel.attributedText = replyStr;
    _cellHeight = CGRectGetMaxY(_teamReplyLabel.frame) + 15;
    
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
