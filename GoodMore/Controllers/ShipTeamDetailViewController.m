//
//  ShipTeamDetailViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/26.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipTeamDetailViewController.h"
#import "Constants.h"
#import "ShipInfoCell.h"
#import "MBProgressHUD.h"
#import "NetWorkInterface.h"
#import "PayFreightViewController.h"
#import "ShipTeamModel.h"
#import "ShipListModel.h"
#import "ShipInfoCell1.h"

@interface ShipTeamDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    UILabel *_fromLabel;
    UILabel *_toLabel;
    NSMutableArray *_shipListArray;
}
@property(nonatomic,strong)ShipTeamModel *shipTeamModel;
@property(nonatomic,strong)NSNumber *allAccount;//船队吨位

@end

@implementation ShipTeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"船队信息";
    self.view.backgroundColor=[UIColor whiteColor];
    //[self initAndLayoutUI];
    [self loadDownShipTeamDetail];
    _shipListArray=[[NSMutableArray alloc]initWithCapacity:0];
}
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.rowHeight=80;
    [self setHeadAndFootView];
    
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    if (_status==ShipTeamStatusMaking || _status==ShipTeamStatusPayfreight)
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-60]];
        
        if (_status==ShipTeamStatusMaking)
        {
            [self settabBarOrganizing];
            
        }else if(_status==ShipTeamStatusPayfreight)
        {
            [self payfreight];
        }
        
    }else
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    
    
}
-(void)setHeadAndFootView
{
    [self setHeadView];
    
}
-(void)setHeadView
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
    shipWeight.text=[NSString stringWithFormat:@"船队吨位:%@吨",_allAccount];
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
        case ShipTeamStatusMaking:
            str = @"组队中";
            break;
        case ShipTeamStatusMakeSuccess:
            str = @"组队成功";
            break;
        case ShipTeamStatusMakeFail:
            str = @"组队失败";
            break;
        case ShipTeamStatusPayfreight:
            str = @"结算运费";
            break;
        case ShipTeamStatusFinished:
            str = @"完成";
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
    
}
//组队中
-(void)settabBarOrganizing
{
    CGFloat leftSpace=10;
    CGFloat width=(kScreenWidth-leftSpace*2-leftSpace*4)/2;
    
    UIView *tabBar=[[UIView alloc]init];
    tabBar.translatesAutoresizingMaskIntoConstraints=NO;
    tabBar.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tabBar];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    UIButton *dismiss=[UIButton buttonWithType:UIButtonTypeCustom];
    dismiss.frame=CGRectMake(leftSpace, 10, width, 40);
    [dismiss setTitle:@"解散船队" forState:UIControlStateNormal];
    dismiss.layer.cornerRadius=4;
    dismiss.layer.masksToBounds=YES;
    dismiss.backgroundColor=[UIColor orangeColor];
    [dismiss addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:dismiss];
    
    UIButton *scramble=[UIButton buttonWithType:UIButtonTypeCustom];
    scramble.frame=CGRectMake(leftSpace+width+leftSpace*4, 10, width, 40);
    [scramble setTitle:@"抢单" forState:UIControlStateNormal];
    scramble.layer.cornerRadius=4;
    scramble.layer.masksToBounds=YES;
    scramble.backgroundColor=kMainColor;
    [scramble addTarget:self action:@selector(scramble:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:scramble];
    
}
//结算运费
-(void)payfreight
{
    UIView *tabBar=[[UIView alloc]init];
    tabBar.translatesAutoresizingMaskIntoConstraints=NO;
    tabBar.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tabBar];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60]];
    UIButton *pay=[UIButton buttonWithType:UIButtonTypeCustom];
    pay.frame=CGRectMake(40, 10, kScreenWidth-40*2, 40);
    pay.layer.cornerRadius=4;
    pay.layer.masksToBounds=YES;
    [pay setTitle:@"结算运费" forState:UIControlStateNormal];
    [pay setBackgroundColor:kMainColor];
    [pay addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:pay];
}

#pragma mark UITableViewDelegate 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shipListArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShipListModel *shipModel=_shipListArray[indexPath.row];

    static NSString *cellIdentifier=@"shipTeamInfo";
    ShipInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[ShipInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundView=[[UIImageView alloc]initWithImage:kImageName(@"kuang.png")];
    cell.ship.text=shipModel.shipName;;
    cell.weight.text=[NSString stringWithFormat:@"%@吨",shipModel.volume];
    cell.weight.textColor=kGrayColor;
    cell.person.text=shipModel.name;
    cell.phone.text=shipModel.phone;
    cell.phone.textColor=kGrayColor;
    
    if ([shipModel.isLeader intValue]==1)//队长
    {
        cell.headImageView.image=kImageName(@"headShip.png");
    }
    
    
    switch (_status)
    {
        case ShipTeamStatusMaking:
        {
            [cell.button setTitle:@"删除" forState:UIControlStateNormal];
            cell.button.titleLabel.font=[UIFont systemFontOfSize:14];
            cell.button.tag=indexPath.row;
            [cell.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [cell.button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            if ([shipModel.isLeader intValue]==1)//队长
            {
                cell.button.hidden=YES;
            }

        }
            break;
        case ShipTeamStatusMakeSuccess:
        {
            [cell.button setTitle:@"删除" forState:UIControlStateNormal];
            cell.button.titleLabel.font=[UIFont systemFontOfSize:14];
            cell.button.tag=indexPath.row;
            [cell.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [cell.button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            if ([shipModel.isLeader intValue]==1)//队长
            {
                cell.button.hidden=YES;
            }
            
        }
            break;
        case ShipTeamStatusMakeFail:
        {
            cell.button.hidden=YES;
            
            if ([shipModel.isLeader intValue]==1)//队长
            {
                cell.button.hidden=YES;
            }
            
        }
            break;
        case ShipTeamStatusPayfreight:
        {
            cell.button.hidden=YES;
            
            if ([shipModel.isLeader intValue]==1)//队长
            {
                cell.button.hidden=YES;
            }
            
        }
            break;

        case ShipTeamStatusFinished:
        {
            NSString *payMoney=[NSString stringWithFormat:@"￥%@",shipModel.payMoney];
            [cell.button setTitle:payMoney forState:UIControlStateNormal];
            cell.button.titleLabel.font=[UIFont systemFontOfSize:14];
            [cell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cell.button.userInteractionEnabled=NO;
        }
            break;

        default:
            break;
    }
    
//    if (_status==ShipTeamStatusMaking || _status==ShipTeamStatusMakeSuccess) {
//        [cell.button setTitle:@"删除" forState:UIControlStateNormal];
//        cell.button.tag=indexPath.row;
//        [cell.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        [cell.button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
//        if ([shipModel.isLeader intValue]==1)//队长
//        {
//            cell.button.hidden=YES;
//        }
//    }
//    
//    
//    if (_status==ShipTeamStatusFinished)
//    {
//        //完成
//        NSString *payMoney=[NSString stringWithFormat:@"%@",shipModel.payMoney];
//        [cell.button setTitle:payMoney forState:UIControlStateNormal];
//        cell.button.userInteractionEnabled=NO;
//    }
    
    
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
#pragma mark action 
//解散船队
-(void)dismiss:(UIButton*)sender
{
    [self breakShipTeam];
}
//抢单
-(void)scramble:(UIButton*)sender
{
    [self shipTeamGetOrder];
}
//结算运费
-(void)pay:(UIButton*)sender
{
    PayFreightViewController *payFreight=[[PayFreightViewController alloc]init];
    payFreight.shipTeamID=_shipTeamModel.ID;
    payFreight.shipListArray=_shipListArray;
    payFreight.paidMoney=_shipTeamModel.paidMoney;
    [self.navigationController pushViewController:payFreight animated:YES];
}
//删除船舶
-(void)delete:(UIButton*)btn
{
    [self deleteShipFromTeamWith:btn.tag];
}
-(void)loadDownShipTeamDetail
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefault objectForKey:@"loginId"] intValue];
    [NetWorkInterface getShipTeamDetailWithloginId:loginId ID:_ID finished:^(BOOL success, NSData *response) {
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------船队列表详情:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
    NSDictionary *shipTeamInfo=[result objectForKey:@"shipTeamInfo"];
    _shipTeamModel=[[ShipTeamModel alloc]initWithDictionary:shipTeamInfo];
    
    if (![result objectForKey:@"shipList"] || ![[result objectForKey:@"shipList"] isKindOfClass:[NSArray class]])
    {
        [self initAndLayoutUI];
        return;
    }
    _allAccount=[result objectForKey:@"allAccount"];
    
    NSArray *shipList=[result objectForKey:@"shipList"];
    [shipList enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        ShipListModel *shipList=[[ShipListModel alloc]initWithDictionary:obj];
        [_shipListArray addObject:shipList];
    }];
    [self initAndLayoutUI];
    
}
//解散船队
-(void)breakShipTeam
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"解散中...";
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefault objectForKey:@"loginId"] intValue];
    int shipOwnerId=[[userDefault objectForKey:@"shipOwnerId"] intValue];

    [NetWorkInterface breakshipTeamWithshipTeamId:[_shipTeamModel.ID intValue] loginId:loginId shipOwnerId:shipOwnerId finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------解散船队:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
//船队抢单
-(void)shipTeamGetOrder
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"抢单中...";
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefault objectForKey:@"loginId"] intValue];
    int shipOwnerId=[[userDefault objectForKey:@"shipOwnerId"] intValue];
    
    [NetWorkInterface shipTeamGetOrderWithshipTeamId:[_shipTeamModel.ID intValue] loginId:loginId shipOwnerId:shipOwnerId finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------船队抢单:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"抢单成功!" message:@"在'我的任务'中可以管理改任务" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    alert.tag=666;
                    [alert show];
                    
                }else
                {
                    //hud.labelText=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    NSString *message=[object objectForKey:@"message"];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alert show];
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
//删除船
-(void)deleteShipFromTeamWith:(NSInteger)index
{
    ShipListModel *shipModel=_shipListArray[index];
    if ([shipModel.isLeader intValue]==1)
    {
        //队长
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"船队长不能删除" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];

    }else
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"删除中...";
        
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

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==666)
    {
        if (buttonIndex==1)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
