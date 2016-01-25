//
//  PopUpView.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-5.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "PopUpView.h"
#import "ConstValues.h"

@interface PopUpView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    
    kPopViewType _viewType;

}
@end

@implementation PopUpView

-(id)initWithViewType:(kPopViewType)viewType
{
    _viewType = viewType;
    
    CGRect frame ;
    switch (viewType) {
            
        case kPopUpView_Setting:
        {
            frame = CGRectMake(0, 0, CVTopRightFrameSize.width, CVTopRightFrameSize.height);
            _dataSource = [NSMutableArray arrayWithObjects:@"设置",@"反馈",@"关于",@"招商合作", nil];
        }
            break;
            
        case kPopUpView_Price:
        {
            frame = CGRectMake(0, 0, 45, 100);
            _dataSource = [NSMutableArray array];
            for (int i = 0; i < MaxOderAmount; i ++) {
                [_dataSource addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
            
        }
            break;
            
        case kPopUpView_SequenceType:
        {
            frame = CGRectMake(0, 0, 100, 70);
            _dataSource = [NSMutableArray arrayWithObjects:@"按价格排序",@"按人气排序", nil];
        }
            break;
            
        default:
            break;
    }
    
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.layer.borderWidth = 1.0;
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 5;
    self = [super initWithFrame:frame];
    
    if (self) {
        [self prepareTableView];
    }

    return self;
}


#pragma mark - 创建tableview
-(void)prepareTableView
{
    float slideOffset = 1;
    CGRect rect = CGRectMake(2*slideOffset, 2, self.bounds.size.width-3*slideOffset, self.bounds.size.height-2*slideOffset);
    _tableView = [[UITableView alloc] initWithFrame:rect];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //_tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = _viewType == kPopUpView_Setting ? NO:YES;
    [self addSubview:_tableView];
}

#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_viewType) {
            
        case kPopUpView_Setting:
            return _tableView.frame.size.height/_dataSource.count;
            break;
            
        case kPopUpView_Price:
            return 25;
            break;
            
        case kPopUpView_SequenceType:
            return 35;
            break;
            
        default:
            break;
    }
    

//    if (_viewType == kPopUpView_Setting) {
//    }else{
//        return 25;
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    
    switch (_viewType) {
            
        case kPopUpView_Price:
            cell.textLabel.font = [UIFont systemFontOfSize:15];

            break;
            
        case kPopUpView_SequenceType:
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - 点击视图某行   1.首页：跳转新界面；
#pragma mark - 2. 食物详情页面：block 回传订单数量
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (_viewType) {
        case kPopUpView_Setting:
            _backSettingChoice([_dataSource objectAtIndex:indexPath.row]);
            break;
            
        case kPopUpView_Price:
        {
            _backFoodOrderNumber([_dataSource objectAtIndex:indexPath.row]);
        }
            break;
        case kPopUpView_SequenceType:
        {
            _backSequenceTypeStr([_dataSource objectAtIndex:indexPath.row]);
        }
            break;
        default:
            break;
    }

}


@end
