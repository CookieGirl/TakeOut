//
//  OrderComfirmViewController.m
//  Takeout
//
//  Created by Zhou Mi on 14-12-17.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#import "OrderComfirmViewController.h"
#import "CustomToolBar.h"
#import "ConstValues.h"

@interface OrderComfirmViewController ()
{
    CGPoint startPoint;
}
@end

@implementation OrderComfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


-(void)createBottomBarItems
{
    
    CustomToolBar *toolBar = [[CustomToolBar alloc] init];
    toolBar.frame = CGRectMake(0, CVScreenSize.height - CGRectGetHeight(toolBar.frame), CGRectGetWidth(toolBar.frame), CGRectGetHeight(toolBar.frame));
    
    toolBar.backToolBarChoose = ^(kToolBarChooseType toolBarChooseType) {
        NSLog(@"%u",toolBarChooseType);
        switch (toolBarChooseType) {
            case kToolBarChooseType_Back:
                [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [self.view addSubview:toolBar];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBottomBarItems];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"%@",touches) ;
    
    //NSArray *touchesArray = [event.allTouches allObjects];
    UITouch *touch = [[touches allObjects] objectAtIndex:0];

    CGPoint endPoint = [touch locationInView:self.view];
    
    float distance = endPoint.y - startPoint.y;
    

    //NSLog(@"%f",distance);

    if (distance > 3 || distance < 3) {
        _backMoveDistance(distance);
        
        startPoint = endPoint;
    }
    

    //self.view.frame = CGRectMake(0, CGRectGetMinY(self.view.frame)+endPoint.y - startPoint.y, CVScreenSize.width, CGRectGetHeight(self.view.frame));
    
//    NSLog(@"=====%@====",NSStringFromCGRect(self.view.frame));
    
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
