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
    _message=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _message.center=CGPointMake(self.center.x, self.center.y);
    _message.textAlignment=NSTextAlignmentCenter;
    _message.font=[UIFont systemFontOfSize:16];
    _message.textColor=[UIColor grayColor];
    [self addSubview:_message];
}
@end
