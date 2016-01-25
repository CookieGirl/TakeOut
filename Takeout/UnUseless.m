//
//  UnUseless.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-8.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "UnUseless.h"

@implementation UnUseless

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)fun1
{

//    NSString *imgUrlStr = [foodDic objectForKey:@"img"];
//    NSString *foodName = [foodDic objectForKey:@"name"];
//    NSString *foodPrice = [NSString stringWithFormat:@"%@",
//                           [foodDic objectForKey:@"price"]] ;
//    NSString *soldAmmount = [NSString stringWithFormat:@"%@",
//                             [foodDic objectForKey:@"hot"]] ;
//    NSString *favouriteAmmount = [NSString stringWithFormat:@"%@",
//                                  [foodDic objectForKey:@"favorites"]] ;
//    NSString *restaurantName = [foodDic objectForKey:@"restaurant"];
//    
//    //  判断数据为空的情况
//    foodName = foodName == nil ? @"食物名":foodName;
//    restaurantName = restaurantName == NULL ? @"店铺名":restaurantName;
//    foodPrice = [foodPrice floatValue] == 0 ? @"¥" : foodPrice;
//    soldAmmount = [soldAmmount intValue] == 0 ? @"0": soldAmmount;
//    favouriteAmmount = [favouriteAmmount intValue] == 0 ? @"0" : favouriteAmmount;

}

//    UIPanGestureRecognizer *panOrderViewGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureOnOrderViewAction:)];
//    [bottomView addGestureRecognizer:panOrderViewGesture];
//
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureOnOrderViewAction:)];
//    [bottomView addGestureRecognizer:swipeGesture];
//
//    bottomView.backgroundColor = [UIColor grayColor];


/*
#pragma mark - 拖动底部隐藏视图
-(void)gestureOnOrderViewAction:(UIGestureRecognizer *)gesture
{
    UIPanGestureRecognizer *panGesture;
    UISwipeGestureRecognizer *swipeGesture;
    OrderComfirmView *orderView = (OrderComfirmView *)gesture.view;
    
    
    if([gesture isKindOfClass:[UISwipeGestureRecognizer class]]){
        
        swipeGesture = (UISwipeGestureRecognizer *)gesture;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        //_detailView.center = CGPointMake(_detailView.center.x+offsetX, _detailView.center.y);
        
        switch (swipeGesture.direction) {
                
            case UISwipeGestureRecognizerDirectionUp:
            {
                orderView.frame = CGRectMake(0, 20, CGRectGetWidth(orderView.frame), CGRectGetHeight(orderView.frame));
                [UIView commitAnimations];
                
            }
                break;
                
            case UISwipeGestureRecognizerDirectionDown:
            {
                orderView.frame = CGRectMake(0, CVScreenSize.height - ToolBarHeight, CGRectGetWidth(orderView.frame), CGRectGetHeight(orderView.frame));
                [UIView commitAnimations];
                
            }
                break;
                
            default:
                break;
        }
        
    }
    else if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        panGesture = (UIPanGestureRecognizer *)gesture;
        
        CGPoint locale = [panGesture translationInView:self.view];
        //CGPoint origin = panGesture.view.frame.origin;
        CGPoint toPoint = CGPointMake(0, orderView.frame.origin.y + locale.y);
        
        NSLog(@"%f",locale.y);
        
        if (toPoint.y <= 20 &&locale.y <=0){
            
            return;
            
        }else if (toPoint.y >= CVScreenSize.height - ToolBarHeight && locale.y >= 0) {
            
            return;
        }else{
            
            
        }
        
        orderView.transform = CGAffineTransformTranslate(orderView.transform, 0, locale.y);
        [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
        
    }
    
}
*/


@end


/*
 AVQuery *query = [AVQuery queryWithClassName:@"_User"];
 [query whereKey:@"username" equalTo:_acountTF.text];
 
 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
 
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 manager
 
 if (objects.count == 1) {
 AVObject *user = [objects firstObject];
 NSLog(@"===%@===",[user objectForKey:@"username"]);
 if ([[user objectForKey:@"password"] isEqualToString:_passwordTF.text]) {
 alert.title = nil;
 alert.message = @"登陆成功";
 alert.delegate = self;
 [alert show];
 
 NSString* path=[NSString stringWithFormat:@"%@/Documents/userInfo.plist",NSHomeDirectory()];
 NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:path];
 NSLog(@"~~%@",dic);
 
 NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
 [user setObject:@(YES) forKey:@"status"];
 [user synchronize];
 
 ZipArchive *manager =[ZipArchive shareManager];
 [manager.dic setObject:_passwordTF.text forKey:_acountTF.text];
 [manager synchronize];
 }else{
 alert.message = @"密码错误";
 [alert show];
 
 }
 
 }else if (objects.count == 0){
 
 [self lockAnimationForView:_acountTF];
 alert.message = @"该用户不存在";
 [alert show];
 
 }else{
 alert.message = @"网络不给力,稍后再试";
 [alert show];
 
 }
 
 }];
 
 //                if (self.operation) {
 //                    self.operation();
 //                }
 
 */

//
//  TFSearchResultTableVIew.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-11.
//  Copyright (c) 2014年 geowind. All rights reserved.
//




