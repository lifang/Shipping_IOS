//
//  MYView.m
//  GoodMore
//
//  Created by lihongliang on 15/6/24.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MYView.h"
#import "Constants.h"

// 先声明一个类
@interface MYButton1 : UIButton

@end

@implementation MYButton1

-(void)setSelected:(BOOL)selected
{
    if (!selected)
    {
        [self setTitleColor:kGrayColor forState:UIControlStateNormal];
    }else
    {
        [self setTitleColor:kMainColor forState:UIControlStateNormal];
    }
}


@end


@implementation MYView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor colorWithRed:247/255.0 green:250/255.0 blue:251/255.0 alpha:1.0];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 0.5)];
        line.backgroundColor=[UIColor grayColor];
        [self addSubview:line];
    }
    return self;
}

-(void)setItems:(NSArray *)itemNames
{
    CGRect rect = self.bounds;
    CGFloat Allwidth=0;
    CGFloat width=0;
    for (int i=0; i<itemNames.count; i++)
    {
        width=[self getLengthWithString:[itemNames objectAtIndex:i] withFont:[UIFont systemFontOfSize:12]];
        Allwidth +=width;
    }
    //之间的间距
    CGFloat space = (rect.size.width-Allwidth)/([itemNames count] + 1);
    
   
    CGFloat width1=0;
    CGFloat originX=space;
    for (int i=0; i<[itemNames count]; i++)
    {
        width1=[self getLengthWithString:[itemNames objectAtIndex:i] withFont:[UIFont systemFontOfSize:12]];
        MYButton1 *button=[MYButton1 buttonWithType:UIButtonTypeCustom];
        
        button.frame=CGRectMake(originX, 0, width1, rect.size.height);
        button.backgroundColor=[UIColor clearColor];
        button.tag=i+1;
        button.titleLabel.font=[UIFont systemFontOfSize:12.0f];
        [button setTitleColor:kGrayColor forState:UIControlStateNormal];
                [button setTitle:[itemNames objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        originX += width1 + space;
        
        if (i==0)
        {
            button.selected=YES;
        }
        
    }
}
//根据title的长度来确定button的长度
-(CGFloat)getLengthWithString:(NSString*)str withFont:(UIFont*)font
{
    CGSize size=[str sizeWithAttributes:@{NSFontAttributeName: font}];
    return size.width;
}
-(IBAction)selectButton:(UIButton*)sender
{
    _selectIndex=sender.tag;
    //改变上一个button的select状态
    [self clearState];
    sender.selected=YES;
    if (_delegate && [_delegate respondsToSelector:@selector(changeValueWithView:Index:)])
    {
        [_delegate changeValueWithView:self Index:sender.tag];
    }
    
}
-(void)clearState
{
    for (MYButton1 *button in self.subviews)
    {
        if ([button isKindOfClass:[MYButton1 class]])
        {
            button.selected=NO;
        }
    }
}

@end
