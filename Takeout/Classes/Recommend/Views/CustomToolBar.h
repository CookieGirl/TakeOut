//
//  CustomToolBar.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-6.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#define ToolBarHeight 40
#define IconHeight  20
#define IconTag_Share 909

typedef enum : NSUInteger {
    
    kToolBarChooseType_Back = 900,
    kToolBarChooseType_ShopCart,
    kToolBarChooseType_Favourite,
    kToolBarChooseType_Share,
    
} kToolBarChooseType;

#import <UIKit/UIKit.h>

//@protocol CustomToolBarDelegate <NSObject>
////
////-(void)didSelectReturnBack;
////-(void)didSelectShopCart:()
//
//@end

@interface CustomToolBar : UIView

@property (nonatomic,copy) void (^backToolBarChoose)(kToolBarChooseType);

@end
