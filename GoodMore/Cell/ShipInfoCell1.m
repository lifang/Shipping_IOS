//
//  ShipInfoCell1.m
//  GoodMore
//
//  Created by lihongliang on 15/6/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipInfoCell1.h"

@implementation ShipInfoCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}
-(void)initUI
{
    
    CGFloat leftSpace=20;
    CGFloat topSpace=20;
    CGFloat bottomSpace=10;
    CGFloat width=(self.bounds.size.width-leftSpace*2)/3;
    CGFloat height=20;
    CGFloat Vspace=80-topSpace-bottomSpace-height*2;
    
    _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 12, 12.5)];
    [self.contentView addSubview:_headImageView];
    
    _ship=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace, width, height)];
    _ship.font=[UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:_ship];
    
    _weight=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+width, topSpace, width, height)];
    _weight.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_weight];
    
    _money=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+width+width, topSpace, width, height)];
    _money.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_money];
    
    _person=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+height+Vspace, width, height)];
    _person.font=[UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:_person];
    
    _phone=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+width, topSpace+height+Vspace, width, height)];
    _phone.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_phone];
    
    _button=[UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame=CGRectMake(leftSpace+width+width, topSpace+height+Vspace, width, height);
    [self.contentView addSubview:_button];
    
    
}

@end
