//
//  CommentTableViewCell.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-8.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "ConstValues.h"
#import "CommentTableViewCell.h"


@interface CommentTableViewCell ()
{
    UILabel *_localeLabel;
    UILabel *_authorLabel;
    UIImageView *_genderImgView;
    
    UILabel *_commentLabel;
    UILabel *_replyLabel;
    UILabel *_dateLabel;
    
}
@end

@implementation CommentTableViewCell

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
    
    _localeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _localeLabel.textColor = [UIColor grayColor];
    _localeLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.contentView addSubview:_localeLabel];
    
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _authorLabel.textColor = CVMainColor;
    _authorLabel.font = [UIFont systemFontOfSize:fontSize];
    [self.contentView addSubview:_authorLabel];
    
    _genderImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _genderImgView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_genderImgView];
    
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:fontSize];
    _commentLabel.numberOfLines = 0;
    [self.contentView addSubview:_commentLabel];
    
    _replyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _replyLabel.numberOfLines = 0;
    _replyLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    _replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //_teamReplyLabel.backgroundColor = CVMainBgColor;
    [self.contentView addSubview:_replyLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _dateLabel.textColor = [UIColor grayColor];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.font = [UIFont systemFontOfSize:fontSize - 1];
    [self.contentView addSubview:_dateLabel];
    
    //_dateLabel.backgroundColor = [UIColor redColor];
}

#pragma mark - 设置数据
-(void)setCommentModel:(CommentModel *)commentModel
{
    float x = 10;
    float y = 5;
    float height = 30;
    
    CGSize localeSize = [commentModel.locale boundingRectWithSize:CGSizeMake(999, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _localeLabel.frame = CGRectMake(x, y, localeSize.width + 10, height);
    _localeLabel.text = [NSString stringWithFormat:@"[%@]",commentModel.locale];
    
    x += localeSize.width + 20;
    CGSize authorSize = [commentModel.author boundingRectWithSize:CGSizeMake(999,height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    _authorLabel.frame = CGRectMake(x, y, authorSize.width, height);
    _authorLabel.text = commentModel.author;
    
    float width = 20;
    height = 20;
    x = CGRectGetMaxX(_authorLabel.frame) + 10;
    y = y + (CGRectGetHeight(_authorLabel.frame) -height)/2;
    
    NSString *icStr = [commentModel.gender isEqualToString:@"男"]?@"ic_boy":@"ic_girl";
    if ([commentModel.gender isEqualToString:@""])
        icStr = @"";
    
    _genderImgView.image = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:icStr ofType:@"png"]];
    _genderImgView.frame = CGRectMake(x, y, width, height);
    
    x = 10;
    y = CGRectGetMaxY(_authorLabel.frame) + 7;
    width = CVScreenSize.width - 2*x;
    
    CGSize commentSize = [commentModel.commentStr boundingRectWithSize:CGSizeMake(width,999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_commentLabel.font} context:nil].size;
    _commentLabel.frame = CGRectMake(x, y, width, commentSize.height);
    _commentLabel.text = commentModel.commentStr;

    
    if(commentModel.replyStr.length <= 0) {
        
        _replyLabel.hidden = YES;
        y = CGRectGetMaxY(_commentLabel.frame) + 10;
        
    }else{
        
        _replyLabel.hidden = NO;
        x += 5;
        y += commentSize.height + 10;
        width -= 10;
        NSString *teamReplyStr = [@"商家回复: " stringByAppendingString:commentModel.replyStr];
        CGSize replySize = [teamReplyStr boundingRectWithSize:CGSizeMake(width,999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_replyLabel.font} context:nil].size;
        _replyLabel.frame = CGRectMake(x, y, width, replySize.height);
        
        NSMutableAttributedString *replyStr = [[NSMutableAttributedString alloc] initWithString:teamReplyStr attributes:@{NSFontAttributeName: _replyLabel.font}];
        NSRange range = {0,5};
        [replyStr addAttributes:@{NSForegroundColorAttributeName:CVMainColor} range:range];
        _replyLabel.attributedText = replyStr;
        
        y = CGRectGetMaxY(_replyLabel.frame) + 10;
        
    }
    
    width = 260;
    height = 20;
    x = self.frame.size.width - width - 20;
    _dateLabel.frame = CGRectMake(x, y, width, height);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    
    NSString *dateStr = [dateFormatter stringFromDate:commentModel.createDate];
    _dateLabel.text = [NSString stringWithFormat:@"发表于: %@ ",dateStr];
    
    _cellHeight = CGRectGetMaxY(_dateLabel.frame) + 15;
    
}


- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
