//
//  PopUpView.h
//  Takeout
//
//  Created by Zhou Mi on 14-12-5.
//  Copyright (c) 2014年 geowind. All rights reserved.
//

#define MaxOderAmount 50

typedef enum : NSUInteger {
    kPopUpView_Price = 900,
    kPopUpView_Setting,
    kPopUpView_SequenceType,
} kPopViewType;


#import <UIKit/UIKit.h>

@interface PopUpView : UIView

-(id)initWithViewType:(kPopViewType)viewType;


@property (nonatomic,copy) void(^backSettingChoice) (NSString *);

@property (nonatomic,copy) void(^backFoodOrderNumber) (NSString *);

@property (nonatomic,copy) void(^backSequenceTypeStr) (NSString *);


@end
