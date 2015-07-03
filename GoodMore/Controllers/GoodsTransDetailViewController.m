//
//  ShipInfoViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/24.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "GoodsTransDetailViewController.h"
#import "Constants.h"

#import "ShipInfoCell.h"
#import "MBProgressHUD.h"
#import "NetWorkInterface.h"
#import "ShipRelation.h"
#import "BusinessOrders.h"
#import "ShipListModel.h"
#import "ShipTeamModel.h"
#import "LoadGoodsViewController.h"

@interface GoodsTransDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UILabel *_fromLabel;
    UILabel *_toLabel;
    NSMutableArray *_shipListArray;
}
@property(nonatomic,strong)ShipRelation *shipRelation;
@property(nonatomic,strong)BusinessOrders *businessOrder;
@property(nonatomic,strong)ShipListModel *shipList;
@property(nonatomic,strong)ShipTeamModel *shipTeamModel;



@end

@implementation GoodsTransDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    //[self loadDetailInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"任务详情";
    self.view.backgroundColor=[UIColor whiteColor];
    //[self initAndLayoutUI];
    [self loadDetailInfo];
    //[self settabBarOrganizing];
    //[self payfreight];
    _shipListArray=[[NSMutableArray alloc]initWithCapacity:0];
}
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    //_tableView.rowHeight=80;
    [self setHeadAndFootView];
    
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}
-(void)setHeadAndFootView
{
    if (_status==GoodsTransportStatusPerforming || _status==GoodsTransportStatusFinish)
    {
        [self setHeadView2];
        [self setFootView];
        
    }else if (_status==GoodsTransportStatusMakeFail || _status==GoodsTransportStatusMaking)
    {
        [self setHeadView1];
    }
    
}
-(void)setHeadView1
{
    CGFloat topSpace=10;
    CGFloat leftSpace=20;
    //地标图
    CGFloat size=15;
    CGFloat hSpace=3;
    CGFloat vSpace=2;
    //地点框长度
    CGFloat width = 200;
    CGFloat height = 20;
    CGFloat bigHSpace=20;
    CGFloat bigVSpace=0;
    
    if ([UIScreen mainScreen].applicationFrame.size.height>460)
    {
        bigVSpace=10;
    }else
    {
        bigVSpace=5;
    }
    
    //货代框
    CGFloat gentW=120;
    CGFloat gentH=20;
    //货物属性框
    CGFloat goodW=(kScreenWidth-40)/3;
    CGFloat goodH=20;
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5*kScreenHeight)];
    headView.backgroundColor=[UIColor clearColor];
    _tableView.tableHeaderView=headView;
    
    UILabel *label1=[[UILabel alloc]init];
    label1.translatesAutoresizingMaskIntoConstraints=NO;
    label1.text=@"从";
    label1.textColor=kGrayColor;
    label1.textAlignment=NSTextAlignmentRight;
    label1.font=[UIFont systemFontOfSize:12];
    [headView addSubview:label1];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    
    UIImageView *imageView1=[[UIImageView alloc]init];
    imageView1.translatesAutoresizingMaskIntoConstraints=NO;
    imageView1.image=kImageName(@"from.png");
    [headView addSubview:imageView1];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    
    _fromLabel=[[UILabel alloc]init];
    _fromLabel.translatesAutoresizingMaskIntoConstraints=NO;
    _fromLabel.textAlignment=NSTextAlignmentLeft;
    _fromLabel.textColor=kGrayColor;
    _fromLabel.font=[UIFont boldSystemFontOfSize:18];
    _fromLabel.text=_shipTeamModel.beginPortName;
    
    [headView addSubview:_fromLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
    
    UILabel *label2=[[UILabel alloc]init];
    label2.translatesAutoresizingMaskIntoConstraints=NO;
    label2.text=@"至";
    label2.textColor=kGrayColor;
    label2.textAlignment=NSTextAlignmentRight;
    label2.font=[UIFont systemFontOfSize:12];
    [headView addSubview:label2];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    
    UIImageView *imageView2=[[UIImageView alloc]init];
    imageView2.translatesAutoresizingMaskIntoConstraints=NO;
    imageView2.image=kImageName(@"to.png");
    [headView addSubview:imageView2];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    _toLabel=[[UILabel alloc]init];
    _toLabel.translatesAutoresizingMaskIntoConstraints=NO;
    _toLabel.textAlignment=NSTextAlignmentLeft;
    _toLabel.textColor=kGrayColor;
    _toLabel.font=[UIFont boldSystemFontOfSize:18];
    _toLabel.text=_shipTeamModel.endPortName;
    ;
    [headView addSubview:_toLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
    
    UILabel *gentName=[[UILabel alloc]init];
    gentName.translatesAutoresizingMaskIntoConstraints=NO;
    gentName.text=[NSString stringWithFormat:@"货代:%@",_shipTeamModel.companyName];
    gentName.font=[UIFont boldSystemFontOfSize:14];
    gentName.textColor=[UIColor blackColor];
    
    [headView addSubview:gentName];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_toLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:gentW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:gentH]];
    
    UILabel *goodName=[[UILabel alloc]init];
    goodName.translatesAutoresizingMaskIntoConstraints=NO;
    goodName.text=@"货物名称";
    goodName.textColor=[UIColor blackColor];
    goodName.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:goodName];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:gentName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *name=[[UILabel alloc]init];
    name.translatesAutoresizingMaskIntoConstraints=NO;
    
    name.text=_shipTeamModel.cargos;
    name.textColor=kGrayColor;
    name.font=[UIFont systemFontOfSize:12];
    [headView addSubview:name];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *weightLabel=[[UILabel alloc]init];
    weightLabel.translatesAutoresizingMaskIntoConstraints=NO;
    weightLabel.text=@"货物重量";
    weightLabel.textColor=[UIColor blackColor];
    weightLabel.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:weightLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeRight multiplier:1.0 constant:bigHSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    UILabel *weight=[[UILabel alloc]init];
    weight.translatesAutoresizingMaskIntoConstraints=NO;
    weight.text=[NSString stringWithFormat:@"%@吨",_shipTeamModel.amount];
    weight.textColor=kGrayColor;
    weight.font=[UIFont systemFontOfSize:12];
    [headView addSubview:weight];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *priceLabel=[[UILabel alloc]init];
    priceLabel.translatesAutoresizingMaskIntoConstraints=NO;
    priceLabel.text=@"运价";
    priceLabel.textColor=[UIColor blackColor];
    priceLabel.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:priceLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:bigHSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *price=[[UILabel alloc]init];
    price.translatesAutoresizingMaskIntoConstraints=NO;
    price.text=[NSString stringWithFormat:@"%@元/吨",_shipTeamModel.cargoPay];
    price.textColor=kGrayColor;
    price.font=[UIFont systemFontOfSize:12];
    [headView addSubview:price];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:priceLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    timeLabel.text=@"装船时间";
    timeLabel.textColor=[UIColor blackColor];
    timeLabel.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:timeLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *time=[[UILabel alloc]init];
    time.translatesAutoresizingMaskIntoConstraints=NO;
    time.text=_shipTeamModel.workTime;
    time.textColor=kGrayColor;
    time.font=[UIFont systemFontOfSize:12];
    [headView addSubview:time];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:timeLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *periodLabel=[[UILabel alloc]init];
    periodLabel.translatesAutoresizingMaskIntoConstraints=NO;
    periodLabel.text=@"装卸周期";
    periodLabel.textColor=[UIColor blackColor];
    periodLabel.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:periodLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:timeLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:timeLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:bigHSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *period=[[UILabel alloc]init];
    period.translatesAutoresizingMaskIntoConstraints=NO;
    period.text=[NSString stringWithFormat:@"%@天",_shipTeamModel.days];
    
    period.textColor=kGrayColor;
    period.font=[UIFont systemFontOfSize:12];
    [headView addSubview:period];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:time attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:periodLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *shipPwd=[[UILabel alloc]init];
    shipPwd.translatesAutoresizingMaskIntoConstraints=NO;
    shipPwd.text=[NSString stringWithFormat:@"船队密码:%@",_shipTeamModel.code];
    shipPwd.textColor=kGrayColor;
    shipPwd.font=[UIFont systemFontOfSize:15];
    [headView addSubview:shipPwd];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipPwd attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:time attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipPwd attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipPwd attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW*2]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipPwd attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    UILabel *shipWeight=[[UILabel alloc]init];
    shipWeight.translatesAutoresizingMaskIntoConstraints=NO;
    //shipWeight.text=[NSString stringWithFormat:@"船队吨位:%@吨",_allAccount];
    shipWeight.text=[NSString stringWithFormat:@"船队吨位:%@吨",_shipTeamModel.amount];
    shipWeight.textColor=kGrayColor;
    shipWeight.font=[UIFont systemFontOfSize:15];
    [headView addSubview:shipWeight];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipWeight attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:shipPwd attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipWeight attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipWeight attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW*2]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipWeight attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UIImageView *statusImv=[[UIImageView alloc]init];
    statusImv.translatesAutoresizingMaskIntoConstraints=NO;
    statusImv.image=kImageName(@"shipStatus.png");
    [headView addSubview:statusImv];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:statusImv attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:shipPwd attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:statusImv attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-(leftSpace+15)]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:statusImv attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size*2]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:statusImv attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size*2]];
    
    UILabel *status=[[UILabel alloc]init];
    status.translatesAutoresizingMaskIntoConstraints=NO;
    
    NSString *str = nil;
    switch (_status)
    {
        case GoodsTransportStatusMaking:
            str = @"组队中";
            break;
        case GoodsTransportStatusMakeFail:
            str = @"组队失败";
            break;
        case GoodsTransportStatusPerforming:
            str = @"执行中";
            break;
        case GoodsTransportStatusFinish:
            str = @"已完成";
            break;
            
        default:
            break;
    }
    status.text=str;
    status.textAlignment=NSTextAlignmentCenter;
    status.font=[UIFont systemFontOfSize:13];
    status.textColor=kMainColor;
    [headView addSubview:status];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:status attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:statusImv attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:status attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:status attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:status attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    
    UIView*line1=[[UIView alloc]init];
    line1.backgroundColor=kColor(201, 201, 201, 1);
    line1.translatesAutoresizingMaskIntoConstraints=NO;
    [headView addSubview:line1];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:shipWeight attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    
    UILabel *joinShip=[[UILabel alloc]init];
    joinShip.translatesAutoresizingMaskIntoConstraints=NO;
    joinShip.text=@"参与船舶";
    joinShip.textColor=kGrayColor;
    joinShip.font=[UIFont boldSystemFontOfSize:12];
    [headView addSubview:joinShip];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:joinShip attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:line1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:joinShip attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:joinShip attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:joinShip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UIView*line2=[[UIView alloc]init];
    line2.translatesAutoresizingMaskIntoConstraints=NO;
    line2.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line2];
    
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:joinShip attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    
    
   //原来的
//    CGFloat topSpace=10;
//    CGFloat leftSpace=20;
//    //地标图
//    CGFloat size=15;
//    CGFloat hSpace=3;
//    CGFloat vSpace=2;
//    //地点框长度
//    CGFloat width = 200;
//    CGFloat height = 20;
//    CGFloat bigHSpace=20;
//    CGFloat bigVSpace=0;
//    
//    if ([UIScreen mainScreen].applicationFrame.size.height>460)
//    {
//        bigVSpace=10;
//    }else
//    {
//        bigVSpace=5;
//    }
//    
//    //货代框
//    CGFloat gentW=120;
//    CGFloat gentH=20;
//    //货物属性框
//    CGFloat goodW=120;
//    CGFloat goodH=20;
//    
//    CGFloat bigWidth=200;
//    
//    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5*kScreenHeight)];
//    headView.backgroundColor=[UIColor clearColor];
//    _tableView.tableHeaderView=headView;
//    
//    UILabel *label1=[[UILabel alloc]init];
//    label1.translatesAutoresizingMaskIntoConstraints=NO;
//    label1.text=@"从";
//    label1.textColor=kGrayColor;
//    label1.textAlignment=NSTextAlignmentRight;
//    label1.font=[UIFont systemFontOfSize:12];
//    [headView addSubview:label1];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
//    
//    UIImageView *imageView1=[[UIImageView alloc]init];
//    imageView1.translatesAutoresizingMaskIntoConstraints=NO;
//    imageView1.image=kImageName(@"from.png");
//    [headView addSubview:imageView1];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
//    
//    _fromLabel=[[UILabel alloc]init];
//    _fromLabel.translatesAutoresizingMaskIntoConstraints=NO;
//    _fromLabel.textAlignment=NSTextAlignmentLeft;
//    _fromLabel.textColor=kGrayColor;
//    _fromLabel.font=[UIFont boldSystemFontOfSize:16];
//    _fromLabel.text=_businessOrder.beginPortName;
//    
//    [headView addSubview:_fromLabel];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
//    
//    UILabel *label2=[[UILabel alloc]init];
//    label2.translatesAutoresizingMaskIntoConstraints=NO;
//    label2.text=@"至";
//    label2.textColor=kGrayColor;
//    label2.textAlignment=NSTextAlignmentRight;
//    label2.font=[UIFont systemFontOfSize:12];
//    [headView addSubview:label2];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
//    
//    UIImageView *imageView2=[[UIImageView alloc]init];
//    imageView2.translatesAutoresizingMaskIntoConstraints=NO;
//    imageView2.image=kImageName(@"to.png");
//    [headView addSubview:imageView2];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
//    _toLabel=[[UILabel alloc]init];
//    _toLabel.translatesAutoresizingMaskIntoConstraints=NO;
//    _toLabel.textAlignment=NSTextAlignmentLeft;
//    _toLabel.textColor=kGrayColor;
//    _toLabel.font=[UIFont boldSystemFontOfSize:16];
//    _toLabel.text=_businessOrder.endPortName;
//    ;
//    [headView addSubview:_toLabel];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
//    
//    UILabel *gentName=[[UILabel alloc]init];
//    gentName.translatesAutoresizingMaskIntoConstraints=NO;
//    gentName.text=[NSString stringWithFormat:@"货代:%@",_businessOrder.companyName];
//    gentName.font=[UIFont boldSystemFontOfSize:12];
//    gentName.textColor=[UIColor blackColor];
//    //gentName.textAlignment=NSTextAlignmentCenter;
//    [headView addSubview:gentName];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_toLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:gentW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:gentH]];
//    
//    UILabel *goodName=[[UILabel alloc]init];
//    goodName.translatesAutoresizingMaskIntoConstraints=NO;
//    goodName.text=@"货物名称";
//    goodName.textColor=[UIColor blackColor];
//    goodName.font=[UIFont boldSystemFontOfSize:12];
//    [headView addSubview:goodName];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:gentName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    
//    UILabel *name=[[UILabel alloc]init];
//    name.translatesAutoresizingMaskIntoConstraints=NO;
//    //name.text=_businessOrder.cargos;
//    name.text=_businessOrder.cargos;
//    name.textColor=kGrayColor;
//    name.font=[UIFont systemFontOfSize:12];
//    [headView addSubview:name];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    
//    UILabel *weightLabel=[[UILabel alloc]init];
//    weightLabel.translatesAutoresizingMaskIntoConstraints=NO;
//    weightLabel.text=@"货物重量";
//    weightLabel.textColor=[UIColor blackColor];
//    weightLabel.font=[UIFont boldSystemFontOfSize:12];
//    [headView addSubview:weightLabel];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeRight multiplier:1.0 constant:bigHSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    UILabel *weight=[[UILabel alloc]init];
//    weight.translatesAutoresizingMaskIntoConstraints=NO;
//    weight.text=[NSString stringWithFormat:@"%@吨",_businessOrder.amount];
//    
//    weight.textColor=kGrayColor;
//    weight.font=[UIFont systemFontOfSize:12];
//    [headView addSubview:weight];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//
//    UILabel *timeLabel=[[UILabel alloc]init];
//    timeLabel.translatesAutoresizingMaskIntoConstraints=NO;
//    timeLabel.text=@"装船时间";
//    timeLabel.textColor=[UIColor blackColor];
//    timeLabel.font=[UIFont boldSystemFontOfSize:12];
//    [headView addSubview:timeLabel];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    
//    UILabel *time=[[UILabel alloc]init];
//    time.translatesAutoresizingMaskIntoConstraints=NO;
//    time.text=_businessOrder.workTime;
//   
//    time.textColor=kGrayColor;
//    time.font=[UIFont systemFontOfSize:12];
//    [headView addSubview:time];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:timeLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    
//    UILabel *periodLabel=[[UILabel alloc]init];
//    periodLabel.translatesAutoresizingMaskIntoConstraints=NO;
//    periodLabel.text=@"装卸周期";
//    periodLabel.textColor=[UIColor blackColor];
//    periodLabel.font=[UIFont boldSystemFontOfSize:12];
//    [headView addSubview:periodLabel];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:timeLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:timeLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:bigHSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    
//    UILabel *period=[[UILabel alloc]init];
//    period.translatesAutoresizingMaskIntoConstraints=NO;
//    period.text=[NSString stringWithFormat:@"%@天",_businessOrder.days];
//    
//    period.textColor=kGrayColor;
//    period.font=[UIFont systemFontOfSize:12];
//    [headView addSubview:period];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:time attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:periodLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    
//    UILabel *shipPwd=[[UILabel alloc]init];
//    shipPwd.translatesAutoresizingMaskIntoConstraints=NO;
//    shipPwd.text=[NSString stringWithFormat:@"船队密码:%@",_shipTeamModel.code];
//    shipPwd.textColor=kGrayColor;
//    shipPwd.font=[UIFont systemFontOfSize:15];
//    [headView addSubview:shipPwd];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipPwd attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:time attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipPwd attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipPwd attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:bigWidth]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipPwd attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    UILabel *shipWeight=[[UILabel alloc]init];
//    shipWeight.translatesAutoresizingMaskIntoConstraints=NO;
//    shipWeight.text=[NSString stringWithFormat:@"船队吨位:%@吨",_shipTeamModel.amount];
//    shipWeight.textColor=kGrayColor;
//    shipWeight.font=[UIFont systemFontOfSize:15];
//    [headView addSubview:shipWeight];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipWeight attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:shipPwd attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipWeight attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipWeight attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:bigWidth]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:shipWeight attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    
//    UIImageView *statusImv=[[UIImageView alloc]init];
//    statusImv.translatesAutoresizingMaskIntoConstraints=NO;
//    statusImv.image=kImageName(@"shipStatus.png");
//    [headView addSubview:statusImv];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:statusImv attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:shipPwd attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:statusImv attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-(leftSpace+15)]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:statusImv attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size*2]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:statusImv attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size*2]];
//    
//    UILabel *status=[[UILabel alloc]init];
//    status.translatesAutoresizingMaskIntoConstraints=NO;
//    
//    NSString *str = nil;
//    switch (_status)
//    {
//        case GoodsTransportStatusMaking:
//            str = @"组队中";
//            break;
//        case GoodsTransportStatusMakeFail:
//            str = @"组队失败";
//            break;
//        case GoodsTransportStatusPerforming:
//            str = @"执行中";
//            break;
//        case GoodsTransportStatusFinish:
//            str = @"已完成";
//            break;
//            
//        default:
//            break;
//    }
//    status.text=str;
//    status.textAlignment=NSTextAlignmentCenter;
//    status.font=[UIFont systemFontOfSize:13];
//    status.textColor=kMainColor;
//    [headView addSubview:status];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:status attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:statusImv attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:status attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:status attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW/2]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:status attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//
//
//    UIView*line1=[[UIView alloc]init];
//    line1.backgroundColor=kColor(201, 201, 201, 1);
//    line1.translatesAutoresizingMaskIntoConstraints=NO;
//    [headView addSubview:line1];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:shipWeight attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
//    
//    UILabel *joinShip=[[UILabel alloc]init];
//    joinShip.translatesAutoresizingMaskIntoConstraints=NO;
//    joinShip.text=@"参与船舶";
//    joinShip.textColor=kGrayColor;
//    joinShip.font=[UIFont boldSystemFontOfSize:12];
//    [headView addSubview:joinShip];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:joinShip attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:line1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:joinShip attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:joinShip attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW/2]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:joinShip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    
//    UIView*line2=[[UIView alloc]init];
//    line2.translatesAutoresizingMaskIntoConstraints=NO;
//    line2.backgroundColor=kColor(201, 201, 201, 1);
//    [headView addSubview:line2];
//
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:joinShip attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    
}
-(void)setHeadView2
{

    CGFloat topSpace=40;
    CGFloat leftSpace=20;
    //地标图
    CGFloat size=15;
    CGFloat hSpace=3;
    CGFloat vSpace=7;
    //地点框长度
    CGFloat width = 160;
    CGFloat height = 20;
    CGFloat bigHSpace=20;
    CGFloat bigVSpace=0;
    
    if ([UIScreen mainScreen].applicationFrame.size.height>460)
    {
        bigVSpace=20;
    }else
    {
        bigVSpace=10;
    }
    
    //货代框
    CGFloat gentW=120;
    CGFloat gentH=20;
    //货物属性框
    CGFloat goodW=120;
    CGFloat goodH=20;
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.6)];
    headView.backgroundColor=[UIColor clearColor];
    _tableView.tableHeaderView=headView;
    
    UILabel *label1=[[UILabel alloc]init];
    label1.translatesAutoresizingMaskIntoConstraints=NO;
    label1.text=@"从";
    label1.textColor=kGrayColor;
    label1.textAlignment=NSTextAlignmentRight;
    label1.font=[UIFont systemFontOfSize:12];
    [headView addSubview:label1];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    
    UIImageView *imageView1=[[UIImageView alloc]init];
    imageView1.translatesAutoresizingMaskIntoConstraints=NO;
    imageView1.image=kImageName(@"from.png");
    [headView addSubview:imageView1];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    
    _fromLabel=[[UILabel alloc]init];
    _fromLabel.translatesAutoresizingMaskIntoConstraints=NO;
    _fromLabel.textAlignment=NSTextAlignmentLeft;
    _fromLabel.textColor=kGrayColor;
    _fromLabel.text=_businessOrder.beginPortName;
    _fromLabel.font=[UIFont boldSystemFontOfSize:18];
    //_fromLabel.backgroundColor=[UIColor redColor];
    [headView addSubview:_fromLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
    
    UILabel *label2=[[UILabel alloc]init];
    label2.translatesAutoresizingMaskIntoConstraints=NO;
    label2.text=@"至";
    label2.textColor=kGrayColor;
    label2.textAlignment=NSTextAlignmentRight;
    label2.font=[UIFont systemFontOfSize:12];
    [headView addSubview:label2];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    
    UIImageView *imageView2=[[UIImageView alloc]init];
    imageView2.translatesAutoresizingMaskIntoConstraints=NO;
    imageView2.image=kImageName(@"to.png");
    [headView addSubview:imageView2];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    _toLabel=[[UILabel alloc]init];
    _toLabel.translatesAutoresizingMaskIntoConstraints=NO;
    _toLabel.textAlignment=NSTextAlignmentLeft;
    _toLabel.textColor=kGrayColor;
    _toLabel.text=_businessOrder.endPortName;
    _toLabel.font=[UIFont boldSystemFontOfSize:18];
    //_toLabel.backgroundColor=[UIColor redColor];
    [headView addSubview:_toLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
    
    UILabel *gentName=[[UILabel alloc]init];
    gentName.translatesAutoresizingMaskIntoConstraints=NO;
    gentName.text=[NSString stringWithFormat:@"货代:%@",_businessOrder.companyName];
    gentName.font=[UIFont boldSystemFontOfSize:14];
    gentName.textColor=[UIColor blackColor];
    //gentName.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:gentName];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_toLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:gentW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:gentName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:gentH]];
    
    UILabel *goodName=[[UILabel alloc]init];
    goodName.translatesAutoresizingMaskIntoConstraints=NO;
    goodName.text=@"货物名称";
    goodName.textColor=[UIColor blackColor];
    goodName.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:goodName];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:gentName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *name=[[UILabel alloc]init];
    name.translatesAutoresizingMaskIntoConstraints=NO;
    name.text=_businessOrder.cargos;
    name.textColor=kGrayColor;
    name.font=[UIFont systemFontOfSize:14];
    [headView addSubview:name];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace/2]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *weightLabel=[[UILabel alloc]init];
    weightLabel.translatesAutoresizingMaskIntoConstraints=NO;
    weightLabel.text=@"货物重量";
    weightLabel.textColor=[UIColor blackColor];
    weightLabel.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:weightLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeRight multiplier:1.0 constant:bigHSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *weight=[[UILabel alloc]init];
    weight.translatesAutoresizingMaskIntoConstraints=NO;
    weight.text=[NSString stringWithFormat:@"%@吨",_businessOrder.amount];
    weight.textColor=kGrayColor;
    weight.font=[UIFont systemFontOfSize:14];
    [headView addSubview:weight];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    
    UILabel *chargeLabel=[[UILabel alloc]init];
    chargeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    chargeLabel.text=@"运价";
    chargeLabel.textColor=[UIColor blackColor];
    chargeLabel.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:chargeLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:chargeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:chargeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:chargeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:chargeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    
    UILabel *charge=[[UILabel alloc]init];
    charge.translatesAutoresizingMaskIntoConstraints=NO;
    double charg=[_businessOrder.allPay doubleValue];
    NSString *cha=[NSString stringWithFormat:@"%.2f",charg];
    charge.text=[NSString stringWithFormat:@"%@元/吨",cha];
    charge.textColor=kGrayColor;
    charge.font=[UIFont systemFontOfSize:14];
    [headView addSubview:charge];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:chargeLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace/2]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    timeLabel.text=@"装船时间";
    timeLabel.textColor=[UIColor blackColor];
    timeLabel.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:timeLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:chargeLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *time=[[UILabel alloc]init];
    time.translatesAutoresizingMaskIntoConstraints=NO;
    time.text=_businessOrder.workTime;
    time.textColor=kGrayColor;
    time.font=[UIFont systemFontOfSize:14];
    [headView addSubview:time];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:charge attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *periodLabel=[[UILabel alloc]init];
    periodLabel.translatesAutoresizingMaskIntoConstraints=NO;
    periodLabel.text=@"装卸周期";
    periodLabel.textColor=[UIColor blackColor];
    periodLabel.font=[UIFont boldSystemFontOfSize:14];
    [headView addSubview:periodLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:charge attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigHSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *period=[[UILabel alloc]init];
    period.translatesAutoresizingMaskIntoConstraints=NO;
    period.text=[NSString stringWithFormat:@"%@天",_businessOrder.days];
    period.textColor=kGrayColor;
    period.font=[UIFont systemFontOfSize:14];
    [headView addSubview:period];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:periodLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
}
-(void)setFootView
{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.4)];
    
    footView.backgroundColor=[UIColor clearColor];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 0.5, kScreenWidth-20, 0.5)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [footView addSubview:line];
    
    UIButton *loadGoods=[UIButton buttonWithType:UIButtonTypeCustom];
    loadGoods.frame=CGRectMake(50, 100, kScreenWidth-100, 40);
    loadGoods.layer.cornerRadius=4;
    loadGoods.layer.masksToBounds=YES;
    [loadGoods setBackgroundColor:kMainColor];
//    [loadGoods setTitle:@"装货" forState:UIControlStateNormal];
    
    if ([_shipRelation.inAccount intValue]==0)
    {
        [loadGoods setTitle:@"装货" forState:UIControlStateNormal];
    }else if([_shipRelation.outAccount intValue]==0)
    {
        [loadGoods setTitle:@"卸货" forState:UIControlStateNormal];
    }else
    {
        [loadGoods setTitle:@"完成" forState:UIControlStateNormal];
        loadGoods.userInteractionEnabled=NO;
    }
    
    [loadGoods addTarget:self action:@selector(loadGoods:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:loadGoods];
    
    NSArray *itemArray=[[NSArray alloc]initWithObjects:@"装货吨位",@"卸货吨位",@"总运费", nil];
    //间距为
    CGFloat space=20;
    CGFloat width=(kScreenWidth-40-space*2)/3;
    for (int i=0; i<itemArray.count; i++)
    {
        UILabel *item=[[UILabel alloc]initWithFrame:CGRectMake(20+(width+space)*i, 20, width, 20)];
        item.text=itemArray[i];
        item.textColor=[UIColor blackColor];
        item.font=[UIFont boldSystemFontOfSize:15];
        [footView addSubview:item];
        UILabel *subItem=[[UILabel alloc]initWithFrame:CGRectMake(20+(width+space)*i, 40, width, 20)];
        UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(20+(width+space)*i, 60, width, 20)];
        if (i==2)
        {
            if ([_shipRelation.payMoney intValue]==0)
            {
                subItem.text=@"--";
                time.text=_shipRelation.outWriteTimeNew;
                
            }else{
                double allPay=[_shipRelation.payMoney doubleValue];
                NSString *pay=[NSString stringWithFormat:@"%.2f",allPay];
                subItem.text=[NSString stringWithFormat:@"%@元",pay];
                time.text=_shipRelation.outWriteTimeNew;
            }
            
        }
        if (i==0)
        {
            if ([_shipRelation.inAccount intValue]==0)
            {
                subItem.text=@"--";
                time.text=_shipRelation.inWriteTimeNew;
                

            }else
            {
                subItem.text=[NSString stringWithFormat:@"%@吨",_shipRelation.inAccount];
                time.text=_shipRelation.inWriteTimeNew;
            }
            
        }
        if (i==1)
        {
            if ([_shipRelation.outAccount intValue]==0)
            {
                subItem.text=@"--";
                time.text=_shipRelation.outWriteTimeNew;
               

            }else
            {
                subItem.text=[NSString stringWithFormat:@"%@吨",_shipRelation.outAccount];
                time.text=_shipRelation.outWriteTimeNew;
            }
            
        }
        
        subItem.textColor=kGrayColor;
        subItem.font=[UIFont systemFontOfSize:15];
        [footView addSubview:subItem];
        
        
        time.textColor=kGrayColor;
        time.font=[UIFont systemFontOfSize:8];
        [footView addSubview:time];
        if (i<2)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20+width+(width+space)*i, 35, 15, 15)];
            imageView.image=kImageName(@"indicate.png");
            [footView addSubview:imageView];
        }
    }
    
//    UIButton *loadGoods=[UIButton buttonWithType:UIButtonTypeCustom];
//    loadGoods.frame=CGRectMake(50, 100, kScreenWidth-100, 40);
//    loadGoods.layer.cornerRadius=4;
//    loadGoods.layer.masksToBounds=YES;
//    [loadGoods setBackgroundColor:kMainColor];
//    [loadGoods setTitle:@"装货" forState:UIControlStateNormal];
//    [loadGoods addTarget:self action:@selector(loadGoods:) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:loadGoods];
    
    if (_status==GoodsTransportStatusFinish)
    {
        loadGoods.hidden=YES;
    }
    _tableView.tableFooterView=footView;
}

#pragma mark  action

//装货
-(void)loadGoods:(UIButton*)sender
{
    if ([_shipRelation.inAccount intValue]==0)
    {
        //未装货  去装货
        LoadGoodsViewController *loadGoods=[[LoadGoodsViewController alloc]init];
        loadGoods.index=1;
        loadGoods.shipRelationID=[_shipRelation.shipBusinessRelationId intValue];
        [self.navigationController pushViewController:loadGoods animated:YES];
    }else if ([_shipRelation.outAccount intValue]==0)
    {
        //未卸货  去卸货
        LoadGoodsViewController *loadGoods=[[LoadGoodsViewController alloc]init];
        loadGoods.index=2;
        loadGoods.shipRelationID=[_shipRelation.shipBusinessRelationId intValue];
        [self.navigationController pushViewController:loadGoods animated:YES];
    }else
    {
        //完成
    }
    
}
//退出船队
-(void)delete:(UIButton*)sender
{
    [self deleteShipFromTeamWith:sender.tag];
}

-(void)deleteShipFromTeamWith:(NSInteger)index
{
    ShipListModel *shipModel=_shipListArray[index];
    if ([shipModel.isLeader intValue]==1)
    {
        //队长
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"船队长不能退出船队" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }else
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"退出中...";
        
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        int loginId=[[userDefault objectForKey:@"loginId"] intValue];
        //ShipListModel *shipModel=_shipListArray[index];
        int delShipId=[shipModel.ID intValue];
        
        [NetWorkInterface deleteShipFromTeamWithshipTeamId:[_shipTeamModel.ID intValue] loginId:loginId delShipId:delShipId finished:^(BOOL success, NSData *response) {
            
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            NSLog(@"------------删除船:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if (success)
            {
                id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                    {
                        [hud setHidden:YES];
                        NSString *message=[object objectForKey:@"message"];
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [alert show];
                        
                    }else
                    {
                        hud.labelText=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    }
                }else
                {
                    hud.labelText=kServiceReturnWrong;
                }
            }else
            {
                hud.labelText=kNetworkFailed;
            }
            
        }];
        
    }
    
}


//加载详情
-(void)loadDetailInfo
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefault objectForKey:@"loginId"] intValue];
    [NetWorkInterface OrderDetailWithID:_ID loginId:loginId finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------货物运输详情:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    [self parseDataWithDictionary:object];
                    
                }else
                {
                    hud.labelText=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
            }else
            {
                hud.labelText=kServiceReturnWrong;
            }
        }else
        {
            hud.labelText=kNetworkFailed;
        }
        
    }];

}
-(void)parseDataWithDictionary:(NSDictionary*)dic
{
    if (![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *result=[dic objectForKey:@"result"];
    
    NSDictionary *shipRelation=[result objectForKey:@"shipRelation"];
    _shipRelation=[[ShipRelation alloc]initWithDictionary:shipRelation];
    NSDictionary *businessOrder=[result objectForKey:@"businessOrder"];
    _businessOrder=[[BusinessOrders alloc]initWithDictionary:businessOrder];
    
    if (![result objectForKey:@"shipTeamInfo"] || ![[result objectForKey:@"shipTeamInfo"] isKindOfClass:[NSDictionary class]])
    {
        [self initAndLayoutUI];
        return;
    }
    NSDictionary *shipTeamInfo=[result objectForKey:@"shipTeamInfo"];
    _shipTeamModel=[[ShipTeamModel alloc]initWithDictionary:shipTeamInfo];
    //_amount=[shipTeamInfo objectForKey:@"amount"];
    //_shipTeamCode=[shipTeamInfo objectForKey:@"code"];
    
    
    if (![result objectForKey:@"shipList"] || ![[result objectForKey:@"shipList"] isKindOfClass:[NSArray class]])
    {
        [self initAndLayoutUI];
        return;
    }
    NSArray *shipList=[result objectForKey:@"shipList"];
    [shipList enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        ShipListModel *shipList=[[ShipListModel alloc]initWithDictionary:obj];
        [_shipListArray addObject:shipList];
        
    }];
    
    NSLog(@"-------ship列表:%d",_shipListArray.count);
    [self initAndLayoutUI];

}
    
#pragma mark ------UITableView--------
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_status)
    {
        case GoodsTransportStatusMaking:
            return 80;
            break;
        case GoodsTransportStatusPerforming:
            return 0;
            break;
        case GoodsTransportStatusMakeFail:
            return 80;
            break;
        case GoodsTransportStatusFinish:
            return 0;
            break;
            
        default:
            return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_status)
    {
        case GoodsTransportStatusMaking:
            return _shipListArray.count;
            break;
        case GoodsTransportStatusPerforming:
            return 0;
            break;
        case GoodsTransportStatusMakeFail:
             return _shipListArray.count;
            break;
        case GoodsTransportStatusFinish:
            return 0;
            break;
            
        default:
            return 0;
    }

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"shipInfo";
    ShipInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[ShipInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (_status==GoodsTransportStatusFinish || _status==GoodsTransportStatusPerforming)
    {
        return cell;
    }else if(_status==GoodsTransportStatusMakeFail)
    {
        ShipListModel *shipModel=_shipListArray[indexPath.row];
        
        cell.ship.text=shipModel.shipName;;
        cell.weight.text=[NSString stringWithFormat:@"%@吨",shipModel.volume];
        cell.person.text=shipModel.name;
        cell.phone.text=shipModel.phone;
        if ([shipModel.isLeader intValue]==1)
        {
            cell.headImageView.image=kImageName(@"headShip.png");
        }
        cell.button.hidden=YES;
        return cell;
    }else
    {
        ShipListModel *shipModel=_shipListArray[indexPath.row];
        
        cell.ship.text=shipModel.shipName;;
        cell.weight.text=[NSString stringWithFormat:@"%@吨",shipModel.volume];
        cell.person.text=shipModel.name;
        cell.phone.text=shipModel.phone;
        if ([shipModel.isLeader intValue]==1)
        {
            cell.headImageView.image=kImageName(@"headShip.png");
        }
        if ([shipModel.isSelf intValue]==1)
        {
            [cell.button setTitle:@"退出船队" forState:UIControlStateNormal];
        }
        
        cell.button.tag=indexPath.row;
        cell.button.titleLabel.font=[UIFont systemFontOfSize:14];
        [cell.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
 
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
