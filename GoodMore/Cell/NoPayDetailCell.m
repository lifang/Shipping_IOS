//
//  NoPatDetailCell.m
//  GoodMore
//
//  Created by lihongliang on 15/6/11.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "NoPayDetailCell.h"
#import "Constants.h"
@implementation NoPayDetailCell



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
    CGFloat leftSpace=10;
    CGFloat width=(kScreenWidth-20)/4;
    _date=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, 0, width, self.bounds.size.height)];
    _date.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_date];
    
    _type=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+width, 0, width, self.bounds.size.height)];
    _type.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_type];
    
    _money=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+2*width, 0, width, self.bounds.size.height)];
    _money.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_money];
    
    _addUp=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+3*width, 0, width, self.bounds.size.height)];
    _addUp.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_addUp];
    
}

@end
