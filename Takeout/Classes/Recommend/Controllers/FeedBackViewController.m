//
//  FeedBackViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-15.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

//#define TableHeaderViewHeight  150

#import <AVOSCloud/AVOSCloud.h>
#import "FeedBackViewController.h"
#import "ConstValues.h"
#import "NavigationView.h"
#import "FeedBackTableViewCell.h"
#import "LoginViewController.h"

@interface FeedBackViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    
    UITextView *_feedBackTV;
    
    FeedBackTableViewCell *_cell;//计算高度使用
}
@end

static NSString *hintStr = @"感谢您使用，您在使用过程中如有任何问题、意见或建议，都可以给我们反馈。您的支持是我们不懈努力的动力";
static NSString *cellIde = @"cellID";

@implementation FeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

#pragma mark -  UITableView创建
-(void)prepareTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, MyNaviViewHeight + 20 , CVScreenSize.width, CVScreenSize.height - 20 - MyNaviViewHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];

    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.tableHeaderView = [self createTableHeaderView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [_tableView addGestureRecognizer:tapGesture];
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
}

#pragma mark - 创建 TableHeaderView
-(UIView *)createTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    float width = CVScreenSize.width - 2*10;
    float fontSize = 14;
    
    CGSize hintStrSize = [hintStr boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;

    float x = 10;
    float y = 5;
    
    UITextView *hintTV = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, hintStrSize.height + 10)];
    hintTV.backgroundColor = [UIColor clearColor];
    hintTV.text = hintStr;
    hintTV.textColor = CVMainColor;
    hintTV.font = [UIFont systemFontOfSize:fontSize];
    hintTV.editable = NO;
    [headerView addSubview:hintTV];
    
    y = CGRectGetMaxY(hintTV.frame) + 10;
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 30)];
    hintLabel.text = @"* 反馈意见请控制在15至150字之间";
    hintLabel.font = [UIFont systemFontOfSize:fontSize - 1];
    [headerView addSubview:hintLabel];
    
    y = CGRectGetMaxY(hintLabel.frame) + 5;
    _feedBackTV = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, 100)];
    _feedBackTV.backgroundColor = [UIColor colorWithWhite:245 alpha:0.5];
    _feedBackTV.layer.borderColor = CVMainColor.CGColor;
    _feedBackTV.layer.borderWidth = 0.5;
    _feedBackTV.layer.cornerRadius = 10;
    _feedBackTV.editable = YES;
    _feedBackTV.font = [UIFont systemFontOfSize:fontSize];
    _feedBackTV.returnKeyType = UIReturnKeyDone;
    //_feedBackTV.delegate = self;
    [headerView addSubview:_feedBackTV];
    
    width = 40;
    float height = 20;
    x = CGRectGetWidth(_feedBackTV.frame) - width - 5;
    y = CGRectGetHeight(_feedBackTV.frame) - height - 5;
    UIButton *submitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBnt.frame = CGRectMake(x, y, width, height);
    [submitBnt setTitle:@"提交" forState:0];
    submitBnt.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [submitBnt setTitleColor:CVMainColor forState:UIControlStateNormal];
    submitBnt.layer.borderWidth = 0.8;
    submitBnt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //submitBnt.backgro
    [submitBnt addTarget:self action:@selector(submitComment) forControlEvents:UIControlEventTouchUpInside];
    [_feedBackTV addSubview:submitBnt];
    
    height = CGRectGetHeight(hintTV.frame) + CGRectGetHeight(hintLabel.frame) + CGRectGetHeight(_feedBackTV.frame) + 30;
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width,height);
    return headerView;

}

#pragma mark - 提交评论事件,字数控制 15 ～ 150
-(void)submitComment
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"成功提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    if (_feedBackTV.text.length < 15) {
        alertView.message = @"不能少于15字";
        [alertView show];
        return;
    }else if (_feedBackTV.text.length > 150){
        alertView.message = @"不能多于150字";
        [alertView show];
        return;
    }
    
    AVUser *currentUser = [AVUser currentUser];
    
    AVObject *feedBackObj = [AVObject objectWithClassName:@"FeedBack"];
    [feedBackObj setObject:currentUser.username forKey:@"author"];
    [feedBackObj setObject:[currentUser objectForKey:@"gender"] forKey:@"gender"];
    [feedBackObj setObject:_feedBackTV.text forKey:@"content"];
    
    [feedBackObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        if (succeeded) {
            
            [alertView show];
            _feedBackTV.text = nil;
            [_feedBackTV resignFirstResponder];
            [_tableView reloadData];
            
        }else {
        
            switch (error.code) {
                case 201:
                    
                    break;
                    
                default:
                    break;
            }
        }
        
        
    }];
    
}

#pragma mark  获取数据
-(void)loadData
{
    AVQuery *query = [AVQuery queryWithClassName:@"FeedBack"];
    //query.limit = 6;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (objects) {
            
            for (NSDictionary *dic in objects) {
                
                FeedBackModel *model = [[FeedBackModel alloc] init];
                model.author = [dic objectForKey:@"author"];
                model.userGender = [dic objectForKey:@"gender"];
                model.userComment = [dic objectForKey:@"content"];
                model.teamReply = [dic objectForKey:@"reply"];
                [_dataSource addObject:model];
                
            }
            
            [_tableView reloadData];
            
        }else if(error){
            NSLog(@"error:%@",error);
        }
        
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = CVMainBgColor;
    
    NavigationView *naviView = [[NavigationView alloc] init];
    naviView.backBtnTag = ^(kMyNaviViewBtnTag btnTag){
        
        if (btnTag == kBtnTag_Back)
            [self.navigationController popViewControllerAnimated:YES];
    };
    [naviView setLeftButtonTitle:@"< 返回"];
    [self.view addSubview:naviView];
    
    [self prepareTableView];
    [self loadData];

    
}

#pragma mark - UITableViewDataSource & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!_cell) {
        _cell = [[FeedBackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    
    [_cell setFeedBackModel:[_dataSource objectAtIndex:indexPath.row]];
    
    return _cell.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FeedBackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell = [[FeedBackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    
    if (_dataSource.count > indexPath.row)
        [cell setFeedBackModel:[_dataSource objectAtIndex:indexPath.row]];
    cell.backgroundColor = CVMainBgColor;
    return cell;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
