//
//  MYInfo.m
//  侧滑栏
//
//  Created by lihongliang on 15/7/7.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MYInfoView.h"

@implementation MYInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self initData];
        [self initUI];
    }
    return self;
}
-(void)initData
{
    _data=[[NSArray alloc]initWithObjects:@"我的资料",@"船舶情况",@"我的钱包",@"我的消息",@"退出登录", nil];
}
-(void)initUI
{
    _tableView=[[UITableView alloc]initWithFrame:self.frame];
    _tableView.scrollEnabled=NO;
    _tableView.backgroundColor=[UIColor blackColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=40;
    [self setHeadView];
    _tableView.tableFooterView=[[UIView alloc]init];
    [self addSubview:_tableView];
}
-(void)setHeadView
{
    CGFloat topSpace=30;
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*0.3)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-40)/2, topSpace, 40, 40)];
    imageView.image=[UIImage imageNamed:@"head_big.png"];
    [headView addSubview:imageView];
    _name=[[UILabel alloc]initWithFrame:CGRectMake((self.bounds.size.width-60)/2, topSpace+40, 60, 20)];
    _name.textColor=[UIColor whiteColor];
    _name.textAlignment=NSTextAlignmentCenter;
    _name.font=[UIFont systemFontOfSize:13];
    [headView addSubview:_name];
    
    _phone=[[UILabel alloc]initWithFrame:CGRectMake(20, topSpace+40+20, self.bounds.size.width-40, 20)];
    _phone.textColor=[UIColor whiteColor];
    _phone.textAlignment=NSTextAlignmentCenter;
    _phone.font=[UIFont systemFontOfSize:11];
    [headView addSubview:_phone];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, topSpace+40+20+20, (self.bounds.size.width-20)/2, 20)];
    label.text=@"可提现金额:";
    label.textAlignment=NSTextAlignmentRight;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:11];
    [headView addSubview:label];
    
    _cash=[[UILabel alloc]initWithFrame:CGRectMake(10+(self.bounds.size.width-20)/2, topSpace+40+20+20, self.bounds.size.width-40, 20)];
    _cash.textAlignment=NSTextAlignmentCenter;
    _cash.textAlignment=NSTextAlignmentLeft;
    _cash.font=[UIFont systemFontOfSize:11];
    [headView addSubview:_cash];
    
    _tableView.tableHeaderView=headView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndefier=@"myInfo";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndefier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIndefier];
    }
    UIView *backView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView=backView;
    
    cell.backgroundColor=[UIColor blackColor];
    cell.textLabel.text=_data[indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectInfoWithIndex:)])
    {
        [_delegate selectInfoWithIndex:indexPath.row];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
