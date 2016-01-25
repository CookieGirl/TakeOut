//
//  OrderComfirmView.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-10.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

enum
{
    RemarkBtnTag_MoreRice = 801,
    RemarkBtnTag_LessChilli,
    RemarkBtnTag_NoChange,
};



#define generalFontSize  15

#import "CustomToolBar.h"
#import "OrderComfirmView.h"
#import "ConstValues.h"

@interface OrderComfirmView ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    CustomToolBar *_toolBarView;
    
    UITableView *_tableView;
    NSMutableArray *_modelsArray;
    
    
    UILabel *_resNameLabel;
    UILabel *_priceLabel;
    UILabel *_localeLabel;
    UITextView *_remarkTV;
    
    UIButton *_comfirmBtn;
    UILabel *_placeHolderLabel;
}
@end

@implementation OrderComfirmView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = CVMainBgColor;
        
        [self initTableView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGesture];
        
        [self createTopBarItems];

    }
    return self;
}

#pragma mark - 工具条
-(void)createTopBarItems
{
    
    _toolBarView = [[CustomToolBar alloc] init];
    _toolBarView.frame = CGRectMake(0, 0, CGRectGetWidth(_toolBarView.frame), CGRectGetHeight(_toolBarView.frame));
    
    _toolBarView.backToolBarChoose = ^(kToolBarChooseType toolBarChooseType) {
        NSLog(@"%u",toolBarChooseType);
        switch (toolBarChooseType) {
            case kToolBarChooseType_Back:
                //[self dismissViewControllerAnimated:YES completion:nil];
                break;
                
            case kToolBarChooseType_ShopCart:
                
                break;
                
            case kToolBarChooseType_Favourite:
                
                break;
                
            case kToolBarChooseType_Share:
                
                break;
                
            default:
                break;
        }
        
        
        
    };
    
    [self addSubview:_toolBarView];
    
}

#pragma mark - 初始化中间视图
-(void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ToolBarHeight, CVScreenSize.width, CVScreenSize.height - ToolBarHeight - 20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self addSubview:_tableView];

    
    float offsetX = 10;
    float x = offsetX;
    float y = 0;
    float width = CVScreenSize.width - 2*offsetX;
    float height = 30;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    //[_tableView setTableHeaderView:headerView];
    _tableView.tableHeaderView = headerView;

    _resNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _resNameLabel.font = [UIFont systemFontOfSize:generalFontSize];
    [headerView addSubview:_resNameLabel];
    
    y += height;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, 1)];
    lineView.backgroundColor = CVMainColor;
    [_resNameLabel addSubview:lineView];
    
    _tableView.tableFooterView = [self createTableFooterView];

    
}

#pragma mark - 订单以下视图
-(UIView *)createTableFooterView
{
    float x = 0;
    float y = 0;
    float width = CVScreenSize.width;
    float height = CVScreenSize.height/2;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, height)];
    
    width = 100;
    height = 100;
    x = (CGRectGetWidth(footerView.frame) - width)/2;
    y = 10;
    UIButton *bowlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bowlBtn.frame = CGRectMake(x, y, width, height);
    [bowlBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ricebowl" ofType:@"png"]] forState:UIControlStateNormal];
    bowlBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 30, 10);
    bowlBtn.titleLabel.font = [UIFont systemFontOfSize:generalFontSize + 1];
    [bowlBtn setTitle:@"快到碗里来" forState:UIControlStateNormal];
    [bowlBtn setTitleColor:CVMainColor forState:UIControlStateNormal];
    [bowlBtn setTitleEdgeInsets: UIEdgeInsetsMake(65, -80, 0, 0)];
    //bowlBtn.backgroundColor = [UIColor grayColor];
    [footerView addSubview:bowlBtn];
    
    float offsetX = 20;
    x = offsetX;
    y = CGRectGetMaxY(bowlBtn.frame) + 8;
    width = CGRectGetWidth(footerView.frame) - 2*x;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, 1)];
    lineView.backgroundColor = CVMainColor;
    [footerView addSubview:lineView];
    
    NSArray *leftTitlesArr = [NSArray arrayWithObjects:@"总金额：",@"地  址：",@"备  注：", nil];
    x += 10;
    y += 10;
    height = 30;
    width = 60;
    UILabel *leftLabel = nil;
    for (int i = 0; i < leftTitlesArr.count; i++) {
        
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        leftLabel.font = [UIFont systemFontOfSize:generalFontSize];
        leftLabel.text = leftTitlesArr[i];
        //label.backgroundColor = [UIColor blackColor];
        [footerView addSubview:leftLabel];
        y += height;
    }
    
    x += width;
    y = CGRectGetMaxY(lineView.frame) + 10;
    width = CGRectGetWidth(footerView.frame) - x;
    //height = cgre;
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _priceLabel.textColor = CVBlueColor;
    _priceLabel.text = @"$ 37.0";
    _priceLabel.font = [UIFont boldSystemFontOfSize:generalFontSize +1];
    [footerView addSubview:_priceLabel];
    
    y += height;
    _localeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _localeLabel.font = [UIFont boldSystemFontOfSize:generalFontSize];
    [footerView addSubview:_localeLabel];
    
    //  textview 备注框
    y = CGRectGetMaxY(leftLabel.frame) + 10;
    x = offsetX;
    width = footerView.frame.size.width - 2*x;
    height = height*4;
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    borderView.layer.borderColor = CVMainColor.CGColor;
    borderView.layer.borderWidth = 0.5;
    borderView.layer.cornerRadius = 7;
    [footerView addSubview:borderView];
    
    height = height - 40;
    _remarkTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _remarkTV.delegate = self;
    [borderView addSubview:_remarkTV];
    
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, width - 10, 40)];
    _placeHolderLabel.numberOfLines = 0;
    //placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _placeHolderLabel.font = [UIFont systemFontOfSize:generalFontSize];
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    _placeHolderLabel.text = @"在这里填额外的需求，比如多加点饭，少放点辣椒";
    //[placeHolderLabel sizeToFit];
    [_remarkTV addSubview:_placeHolderLabel];
    
    NSArray *remarkTitlesArr = [NSArray arrayWithObjects:@"多加点饭",@"少放点辣椒",@"没零钱", nil];
    x = 2;
    width = (width - 4*x)/3;
    height = 30;
    y = CGRectGetHeight(borderView.frame) - height - 1;

    for (int i = 0; i < remarkTitlesArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = CVMainBgColor;
        btn.frame = CGRectMake(x, y, width, height);
        [btn setTitle:remarkTitlesArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:generalFontSize];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        x += width+2;
        //btn.tag = RemarkBtnTag_MoreRice + i;
        [btn addTarget:self action:@selector(RemarkWordsBtnActtion:) forControlEvents:UIControlEventTouchUpInside];
        [borderView addSubview:btn];
    }
    
    width = 200;
    height = 35;
    x = (CGRectGetWidth(footerView.frame) - width)/2;
    y = CGRectGetMaxY(borderView.frame) + 20;
    
    _comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _comfirmBtn.frame = CGRectMake(x, y, width, height);
    _comfirmBtn.backgroundColor = CVMainColor;
    [_comfirmBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    _comfirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [_comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [footerView addSubview:_comfirmBtn];
    
    //borderView.backgroundColor = [UIColor lightGrayColor];
    _localeLabel.text = @"弘辰";
    
    return footerView;
}

#pragma mark - 备注留言按钮 的事件
-(void)RemarkWordsBtnActtion:(UIButton *)button
{
    NSLog(@"remark action");
    _remarkTV.text = [_remarkTV.text stringByAppendingFormat:@"%@,",button.titleLabel.text];
    
}

#pragma mark - 键盘处理
-(void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
//    if ([tapGesture.view isKindOfClass:[UIButton class]]) {
//        
//        [self RemarkWordsBtnActtion:(UIButton *)tapGesture.view];
//        
//        return;
//    }
    
    
    if ([_remarkTV isFirstResponder]) {
        _tableView.frame = CGRectMake(0, ToolBarHeight, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame));
        [self endEditing:YES];
    }
    
}


#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"comein");
    _tableView.frame = CGRectMake(0, ToolBarHeight - 200, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame));
}

-(void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([textView.text isEqualToString: @""]) {
        _placeHolderLabel.hidden = NO;
    }else{
        _placeHolderLabel.hidden = YES;
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location > 50) {
        return NO;
    }
    return YES;
}

//-(void)textViewDidChange:(UITextView *)textView
//{
//    
//}


#pragma mark - UITableViewDataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelsArray.count;
}



#pragma mark - 创建视图
-(void)initView
{
    
}

@end
