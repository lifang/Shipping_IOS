//
//  TopButton.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    BtnTypeOne = 101, //第一个btn
    BtnTypeTwo = 102, //第二个btn
    BtnTypeIcon = 103,//第三个btn
}BtnType;

//点击协议
@protocol TopButtonClickedDelegate <NSObject>

@optional

-(void)TopBtnClickedWithBtnType:(BtnType)btnType;

@end

@interface TopButton : UIView

@property(nonatomic,strong)UIButton *firstBtn;

@property(nonatomic,strong)UIButton *secondBtn;

@property(nonatomic,strong)UIImageView *imageV;

//最右边的头像btn
@property(nonatomic,strong)UIButton *rightIcon;

@property(nonatomic,weak)id<TopButtonClickedDelegate> delegate;

@end
