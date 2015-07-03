//
//  WalletCell.m
//  GoodMore
//
//  Created by lihongliang on 15/6/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "WalletCell.h"
#import "Constants.h"
@implementation WalletCell

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
    CGFloat width=(kScreenWidth-20)/3;
    _date=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, 0, width, self.bounds.size.height)];
    _date.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_date];
    
    _explanation=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+width, 0, width, self.bounds.size.height)];
    _explanation.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_explanation];
    
    _money=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+2*width, 0, width, self.bounds.size.height)];
    _money.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_money];
    
}
@end
