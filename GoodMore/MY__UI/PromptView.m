//
//  PromptView.m
//  GoodMore
//
//  Created by lihongliang on 15/7/12.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "PromptView.h"

@implementation PromptView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {

        [self initUI];
    }
    return self;
}
-(void)initUI
{
    self.backgroundColor=[UIColor whiteColor];
    _message=[[UILabel alloc]initWithFrame:CGRectMake(40, 200, kScreenWidth-80, 30)];
    _message.textAlignment=NSTextAlignmentCenter;
    _message.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:_message];
}
@end
