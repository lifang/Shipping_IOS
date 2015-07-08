//
//  CommonCell.m
//  GoodMore
//
//  Created by lihongliang on 15/7/7.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonCell.h"
#import "Constants.h"
@implementation CommonCell

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
    CGFloat topSpace=5;
    CGFloat leftSpace=20;
    CGFloat cityWidth=100;
    CGFloat PortWidth=kScreenWidth/3;//港口label的宽度
    CGFloat jianTouWidth=42;//箭头的长度
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, topSpace, kScreenWidth, 20)];
    headView.backgroundColor=[UIColor lightGrayColor];
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(leftSpace, (20-17)/2, 17, 17)];
    imageView1.image=kImageName(@"company.png");
    [headView addSubview:imageView1];
    
    _companyName=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+17, 0, 180, 20)];
    _companyName.font=[UIFont systemFontOfSize:16];
    [headView addSubview:_companyName];
    [self.contentView addSubview:headView];
    
    _statusButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_statusButton];
    
    UIImageView *fromImaV=[[UIImageView alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+20+15, 12, 12)];
    fromImaV.image=kImageName(@"from.png");
    [self.contentView addSubview:fromImaV];
    
    _fromCity=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2+12+10, topSpace+20+10,  cityWidth, 20)];
    _fromCity.font=[UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:_fromCity];
    
    _fromPort=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+20+10+20+5, PortWidth, 20)];
    _fromPort.font=[UIFont systemFontOfSize:15];
    _fromPort.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_fromPort];
    
    UIImageView *jianTou=[[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-jianTouWidth)/2, 20+10+15, jianTouWidth, 3)];
    jianTou.image=kImageName(@"jianTou.png");
    [self.contentView addSubview:jianTou];
    
    UIImageView *toImaV=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+20+15, 12, 12)];
    toImaV.image=kImageName(@"to.png");
    [self.contentView addSubview:toImaV];
    
    _toCity=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2+12+10, topSpace+20+10, cityWidth, 20)];
    _toCity.font=[UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:_toCity];
    
    _toPort=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+20+10+20+5, PortWidth, 20)];
    _toPort.textAlignment=NSTextAlignmentCenter;
    _toPort.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_toPort];
    
    UIView *hLine=[[UIView alloc]initWithFrame:CGRectMake(0, topSpace+20+10+20+20+4+5, kScreenWidth, 1)];
    hLine.backgroundColor=kColor(201, 201, 201, 1);;
    [self.contentView addSubview:hLine];
    
    _price=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+20+10+20+20+4+5+5, 100, 20)];
    _price.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_price];
    
    _weight=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+20+10+20+20+4+5+5, 100, 20)];
    _weight.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_weight];
    
    _loadTime=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+20+10+20+20+4+5+20+5, PortWidth, 20)];
    _loadTime.font=[UIFont systemFontOfSize:12];
    _loadTime.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_loadTime];
    
    _goods=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+20+10+20+20+4+1+5+20+5, PortWidth, 20)];
    _goods.font=[UIFont systemFontOfSize:12];
    _goods.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_goods];
    
    UIView *vLine=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, topSpace+20+10+20+20+4+5+5, 1, 40)];
    vLine.backgroundColor=kColor(201, 201, 201, 1);;
    [self.contentView addSubview:vLine];
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, topSpace+20+10+20+20+4+1+5+20+20+5, kScreenWidth, 20)];
    footView.backgroundColor=[UIColor greenColor];
    _endTime=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 20)];
    _endTime.textAlignment=NSTextAlignmentCenter;
    _endTime.font=[UIFont systemFontOfSize:12];
    [footView addSubview:_endTime];
    
    _deposit=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 20)];
    _deposit.textAlignment=NSTextAlignmentCenter;
    _deposit.font=[UIFont systemFontOfSize:12];
    [footView addSubview:_deposit];
    
    [self.contentView addSubview:footView];
    
    
}
@end
