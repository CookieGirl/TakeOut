//
//  CommentViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-8.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "CommentViewController.h"
#import "ConstValues.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CommentTableViewCell.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_modelsArray;
    
    NSString *_restaurantID;
    UILabel *_restaurantNameLabel;
    UILabel *_commentCountLabel;
    
    CommentTableViewCell *_commentCell;
}
@end

static NSString *cellIde = @"cellID";

@implementation CommentViewController

-(id)initWithRestaurantID:(NSString *)restaurantID
{
    _restaurantID = restaurantID;
    
    self = [super init];
    if (self) {
        _modelsArray = [NSMutableArray array];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _modelsArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 顶部导航条
-(UIView *)createHeadView//WithRestaurantName:(NSString *)restaurantName AndSendArea:(NSString *)sendArea
{
    //  主视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, CVScreenSize.width, HeadBarHeight)];
    view.backgroundColor = CVMainColor;
    [self.view addSubview:view];
    
    // 子视图 icon
    UIButton *iconBtnBack = [[UIButton alloc] initWithFrame:CGRectMake(-5, +5, HeadBarHeight - 5, HeadBarHeight -10)];
    NSString *iconBackPath = [[NSBundle mainBundle] pathForResource:@"ic_arrow_left" ofType:@"png"];
    [iconBtnBack setBackgroundImage:[UIImage imageWithContentsOfFile:iconBackPath] forState:UIControlStateNormal];
    //iconBtnBack.tag = barBtnTag_Back;
    [iconBtnBack addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:iconBtnBack];
    
    float x = CGRectGetMaxX(iconBtnBack.frame) + 5;
    float width = view.frame.size.width - 2*CGRectGetWidth(iconBtnBack.frame) - 10;
    // 添加标签
    _restaurantNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0,width, HeadBarHeight*5/9)];
    _restaurantNameLabel.textColor = [UIColor whiteColor];
    _commentCountLabel.font = [UIFont boldSystemFontOfSize:18];
    _restaurantNameLabel.text = @"店名"; // restaurantName;
    [view addSubview:_restaurantNameLabel];
    
    _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(_restaurantNameLabel.frame), width, HeadBarHeight*4/9)];
    _commentCountLabel.textColor = [UIColor whiteColor];
    //_sendAreaLabel.backgroundColor = [UIColor blackColor];
    _commentCountLabel.font = [UIFont boldSystemFontOfSize:14];
    _commentCountLabel.text = @"共有n条评论"; // sendArea;
    [view addSubview:_commentCountLabel];
    
    return view;
}

-(void)backBtnClicked
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 创建 UITableView
-(void)prepareTableView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_big"]];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HeadBarHeight + 20 , CVScreenSize.width, CVScreenSize.height - HeadBarHeight - 20) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    [self.view addSubview:_tableView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CVMainBgColor;
    
    [self createHeadView];
    [self prepareTableView];
    
    [self prepareDataSource];
    
}

#pragma mark - 查询数据
-(void)prepareDataSource
{
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
    [query whereKey:@"restaurantId" equalTo:_restaurantID];
    [query orderByAscending:@"createdAt"];
    //query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects) {
            
            CommentModel *commentModel = nil;
            for (NSDictionary *commentDic in objects) {
                
                commentModel = [[CommentModel alloc] init];
                commentModel.commentID = [commentDic objectForKey:@"objectId"];
                commentModel.locale = [commentDic objectForKey:@"authorLocale"];
                commentModel.author = [commentDic objectForKey:@"author"];
                commentModel.gender = [commentDic objectForKey:@"authorGender"];
                commentModel.commentStr = [commentDic objectForKey:@"content"];
                commentModel.replyStr = [commentDic objectForKey:@"reply"];
                commentModel.createDate = [commentDic objectForKey:@"createdAt"];
                
                [_modelsArray addObject:commentModel];
            }
            
            _restaurantNameLabel.text = [objects[0] objectForKey:@"restaurant"];
            _commentCountLabel.text = [NSString stringWithFormat:@"共有%d条评论",_modelsArray.count];
            
            [_tableView reloadData];
            
        }else{
            NSLog(@"查询出错: \n%@", [error description]);
        }
    }];
    
    
}

#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _commentCell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!_commentCell) {
        _commentCell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    
    [_commentCell setCommentModel:[_modelsArray objectAtIndex:indexPath.row]];
    
    return _commentCell.cellHeight;
    
    //return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    };

    CommentModel *model = [_modelsArray objectAtIndex:indexPath.row];
    [cell setCommentModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *model = [_modelsArray objectAtIndex:indexPath.row];
    
    CommentDetailViewController *dvc = [[CommentDetailViewController alloc] initWithCommentID:model.commentID];
    [self.navigationController pushViewController:dvc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
