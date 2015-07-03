//
//  DetailViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/1.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "DetailViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "NetWorkInterface.h"
#import "ShipRelation.h"
#import "BusinessOrders.h"
#import "MyTaskViewController.h"
#import "WebViewViewController.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UILabel *_fromLabel;
    UILabel *_toLabel;
    UIButton *_receive;
    UIView *_backView;
    UILabel *_shipPwd;
}
@property(nonatomic,strong)ShipRelation *shipRelation;
@property(nonatomic,strong)BusinessOrders *businessOrder;
@property(nonatomic,assign)BOOL isReceived;
@property(nonatomic,strong)NSNumber *shipOrderRelation;
@property(nonatomic,strong)NSString *code;//组队密码
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"任务详情";
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self downloadData];
    //[self initAndLayoutUI];
    //[self initBackView];
    
    
    
}
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    UIImageView*imaV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imaV.image=kImageName(@"kuang.png");
    _tableView.tableFooterView=[[UIView alloc]init];
    [_tableView addSubview:imaV];
    
    [self setHeadAndFootView];
   
    [self.view addSubview:_tableView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    

}
-(void)setHeadAndFootView
{
    [self setHeadView];
    [self setFootView];
    
   
}
-(void)setFootView
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber *type=[userDefault objectForKey:@"type"];
    if ([type intValue]==1)
    {
        //高级船
        UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.4)];
        footView.backgroundColor=[UIColor clearColor];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 0.5, kScreenWidth-20, 0.5)];
        line.backgroundColor=kColor(201, 201, 201, 1);
        [footView addSubview:line];
        _receive=[UIButton buttonWithType:UIButtonTypeCustom];
        [_receive setTitle:@"组队接单" forState:UIControlStateNormal];
        [_receive setBackgroundColor:kMainColor];
        _receive.frame=CGRectMake(50, 30, kScreenWidth-100, 40);
        
        if (_canMT==0)
        {
            //不能组队接单
            _isReceived=YES;
            [_receive setTitle:@"已组队接单" forState:UIControlStateNormal];
            _receive.userInteractionEnabled=NO;
            _receive.backgroundColor=kGrayColor;
        }else if(_canMT==1)
        {
            //能组队接单
            _isReceived=NO;
            [_receive setTitle:@"组队接单" forState:UIControlStateNormal];
            _receive.userInteractionEnabled=YES;
            _receive.backgroundColor=kMainColor;
        }

        
        _receive.layer.masksToBounds=YES;
        _receive.layer.cornerRadius=4;
        [_receive addTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_receive];
        _tableView.tableFooterView=footView;

    }else
    {
        //普通船
        UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.4)];
        footView.backgroundColor=[UIColor clearColor];
        
        UILabel *remark=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-20*2, 60)];
        remark.numberOfLines=0;
        remark.text=@"普通船无法组队接单,需要升级为高级船";
        remark.font=[UIFont systemFontOfSize:16];
        remark.textColor=kMainColor;
        [footView addSubview:remark];
        
        UIButton *upgrad=[UIButton buttonWithType:UIButtonTypeCustom];
        upgrad.frame=CGRectMake(80, 90, kScreenWidth-160, 40);
        upgrad.layer.cornerRadius=4;
        upgrad.layer.masksToBounds=YES;
        [upgrad setTitle:@"升级为高级船" forState:UIControlStateNormal];
        [upgrad setBackgroundColor:kMainColor];
        [upgrad addTarget:self action:@selector(upgrad:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:upgrad];
        _tableView.tableFooterView=footView;
    }
    
    
}

-(void)setHeadView
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
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.6*kScreenHeight)];
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
    //_toLabel.backgroundColor=[UIColor redColor];
    [headView addSubview:_toLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
    
    UILabel *gentName=[[UILabel alloc]init];
    gentName.translatesAutoresizingMaskIntoConstraints=NO;
    gentName.text=[NSString stringWithFormat:@"货代:%@",_businessOrder.companyName];
    gentName.font=[UIFont boldSystemFontOfSize:13];
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
    goodName.font=[UIFont boldSystemFontOfSize:15];
    [headView addSubview:goodName];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:gentName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:goodName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *name=[[UILabel alloc]init];
    name.translatesAutoresizingMaskIntoConstraints=NO;
    name.text=_businessOrder.cargos;
    name.textColor=kGrayColor;
    name.font=[UIFont systemFontOfSize:15];
    [headView addSubview:name];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace/2]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:name attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *weightLabel=[[UILabel alloc]init];
    weightLabel.translatesAutoresizingMaskIntoConstraints=NO;
    weightLabel.text=@"货物重量";
    weightLabel.textColor=[UIColor blackColor];
    weightLabel.font=[UIFont boldSystemFontOfSize:15];
    [headView addSubview:weightLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:goodName attribute:NSLayoutAttributeRight multiplier:1.0 constant:bigHSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weightLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *weight=[[UILabel alloc]init];
    weight.translatesAutoresizingMaskIntoConstraints=NO;
    weight.text=[NSString stringWithFormat:@"%@吨",_businessOrder.amount];
    weight.textColor=kGrayColor;
    weight.font=[UIFont systemFontOfSize:15];
    [headView addSubview:weight];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:weight attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
//    UILabel *priceLabel=[[UILabel alloc]init];
//    priceLabel.translatesAutoresizingMaskIntoConstraints=NO;
//    priceLabel.text=@"货物单价";
//    priceLabel.textColor=[UIColor blackColor];
//    priceLabel.font=[UIFont boldSystemFontOfSize:15];
//    [headView addSubview:priceLabel];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//
//    UILabel *price=[[UILabel alloc]init];
//    price.translatesAutoresizingMaskIntoConstraints=NO;
//    double prices=[_businessOrder.price doubleValue];
//    NSString *p=[NSString stringWithFormat:@"%.2f",prices];
//    price.text=[NSString stringWithFormat:@"%@元/吨",p];
//    price.textColor=kGrayColor;
//    price.font=[UIFont systemFontOfSize:15];
//    [headView addSubview:price];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:priceLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace/2]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    
    
    UILabel *chargeLabel=[[UILabel alloc]init];
    chargeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    chargeLabel.text=@"运价";
    chargeLabel.textColor=[UIColor blackColor];
    chargeLabel.font=[UIFont boldSystemFontOfSize:15];
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
    charge.font=[UIFont systemFontOfSize:15];
    [headView addSubview:charge];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:chargeLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace/2]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];

    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    timeLabel.text=@"装船时间";
    timeLabel.textColor=[UIColor blackColor];
    timeLabel.font=[UIFont boldSystemFontOfSize:15];
    [headView addSubview:timeLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:chargeLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *time=[[UILabel alloc]init];
    time.translatesAutoresizingMaskIntoConstraints=NO;
    time.text=_businessOrder.workTime;
    time.textColor=kGrayColor;
    time.font=[UIFont systemFontOfSize:15];
    [headView addSubview:time];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:charge attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:weightLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *periodLabel=[[UILabel alloc]init];
    periodLabel.translatesAutoresizingMaskIntoConstraints=NO;
    periodLabel.text=@"装卸周期";
    periodLabel.textColor=[UIColor blackColor];
    periodLabel.font=[UIFont boldSystemFontOfSize:15];
    [headView addSubview:periodLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:charge attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigHSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *period=[[UILabel alloc]init];
    period.translatesAutoresizingMaskIntoConstraints=NO;
    period.text=[NSString stringWithFormat:@"%@天",_businessOrder.days];
    period.textColor=kGrayColor;
    period.font=[UIFont systemFontOfSize:15];
    [headView addSubview:period];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:periodLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    
//    UILabel *remarkLabel=[[UILabel alloc]init];
//    remarkLabel.translatesAutoresizingMaskIntoConstraints=NO;
//    remarkLabel.text=@"说明";
//    //remarkLabel.textColor=[UIColor blackColor];
//    remarkLabel.font=[UIFont boldSystemFontOfSize:15];
//    [headView addSubview:remarkLabel];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remarkLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:time attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remarkLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remarkLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remarkLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
//    
//    
//    UILabel *remark=[[UILabel alloc]init];
//    remark.translatesAutoresizingMaskIntoConstraints=NO;
//    remark.numberOfLines=0;
//    //remark.backgroundColor=[UIColor redColor];
//    if ([_businessOrder.remarks isEqualToString:@""])  {
//        remark.text=@"无";
//    }else
//    {
//        remark.text=_businessOrder.remarks;
//    }
//    
//    remark.textColor=kGrayColor;
//    remark.font=[UIFont systemFontOfSize:15];
//    [headView addSubview:remark];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remark attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:remarkLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remark attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remark attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth-40]];
//    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remark attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];

}
-(void)initBackView
{
    CGFloat width=kScreenWidth;
    CGFloat height=kScreenHeight;
    CGFloat leftSpace=20;
    CGFloat topSpace=20;
    CGFloat bottomSpace=10;
    //CGFloat vSpace=5;
    
    _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _backView.backgroundColor=[UIColor colorWithRed:95/255.0 green:114/255.0 blue:114/255.0 alpha:0.5];
    [self.view addSubview:_backView];
    
    UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake((width-width*0.8)/2, 100, width*0.8, height*0.3)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [_backView addSubview:whiteView];
    
    UILabel *title=[[UILabel alloc]init];
    title.font=[UIFont systemFontOfSize:16];
    title.text=@"组队成功!";
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=[UIColor blackColor];
    title.frame=CGRectMake(leftSpace, topSpace, whiteView.bounds.size.width-leftSpace*2, 30);
    [whiteView addSubview:title];
    
    _shipPwd=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10, whiteView.bounds.size.width-leftSpace*2, 30)];
    
    _shipPwd.textAlignment=NSTextAlignmentCenter;
    _shipPwd.textColor=[self colorWithHexString:@"757474"];
    [whiteView addSubview:_shipPwd];
    
    UILabel *remark=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+30, whiteView.bounds.size.width-leftSpace*2, 30)];
    remark.text=@"在我的任务中可以管理船队";
    remark.textAlignment=NSTextAlignmentCenter;
    remark.font=[UIFont systemFontOfSize:14];
    remark.textColor=[self colorWithHexString:@"757474"];
    [whiteView addSubview:remark];
    
    UIButton *sureBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBTN.frame=CGRectMake((width*0.8-60)/2, height*0.3-bottomSpace-30, 60, 30);
    sureBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [sureBTN setTitle:@"确定" forState:UIControlStateNormal];
    [sureBTN setTitleColor:[self colorWithHexString:@"757474"] forState:UIControlStateNormal];
    [sureBTN addTarget:self action:@selector(sureBTN:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:sureBTN];
}
//RGB 颜色转换
-(UIColor *)colorWithHexString:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

#pragma mark -- action --
-(void)sureBTN:(UIButton*)btn
{
    _backView.hidden=YES;
}
//升级为高级船
-(void)upgrad:(UIButton*)sender
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"请耐心等待";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefaults objectForKey:@"loginId"] intValue];
    int shipOwnerId=[[userDefaults objectForKey:@"shipOwnerId"] intValue];
    
    [NetWorkInterface upShipWithshipId:shipOwnerId loginId:loginId finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------升级为高级船----:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    
                    NSString *urlString=[object objectForKey:@"result"];
                    WebViewViewController *webView=[[WebViewViewController alloc]init];
                    webView.hidesBottomBarWhenPushed=YES;
                    webView.urlString=urlString;
                    [self.navigationController pushViewController:webView animated:YES];
                    
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

//组队接单
-(IBAction)receive:(UIButton*)sender
{
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"接单中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefaults objectForKey:@"loginId"] intValue];
    int shipOwnerId=[[userDefaults objectForKey:@"shipOwnerId"] intValue];

    NSString *ordersList = [NSString stringWithFormat:@"%@",_businessOrder.ID];
    [NetWorkInterface makeTeamWithorderId:[ordersList intValue] loginId:loginId shipOwnerId:shipOwnerId finished:^(BOOL success, NSData *response) {
        
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            NSLog(@"------------组队接单----:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if (success)
            {
                hud.customView=[[UIImageView alloc]init];
                [hud hide:YES afterDelay:0.3];
                id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                    {
                        [hud setHidden:YES];
                        _backView.hidden=NO;
                        _code=[object objectForKey:@"result"];
                        _shipPwd.text=[NSString stringWithFormat:@"组队密码:%@",_code];
                        [self changeStatus];
                        
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
-(void)changeStatus
{
    _isReceived=YES;
    [_receive setTitle:@"已接单" forState:UIControlStateNormal];
    _receive.backgroundColor=kGrayColor;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:_businessOrder.status forKey:@"status"];
    [userDefault synchronize];
//    MyTaskViewController *myTask=[[MyTaskViewController alloc]init];
//    myTask.navigationItem.hidesBackButton=YES;
//    [self.navigationController pushViewController:myTask animated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)downloadData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefault objectForKey:@"loginId"] intValue];
    [NetWorkInterface OrderDetailWithID:_ID loginId:loginId finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------货单详情:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
    
//    NSDictionary *shipRelation=[result objectForKey:@"shipRelation"];
//    _shipOrderRelation=[result objectForKey:@"shipOrderRelation"];
//    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//    [user setObject:_shipOrderRelation forKey:@"shipOrderRelation"];
//    [user synchronize];
//    _shipRelation=[[ShipRelation alloc]initWithDictionary:shipRelation];
    
    
    NSDictionary *businessOrder=[result objectForKey:@"businessOrder"];
    _businessOrder=[[BusinessOrders alloc]initWithDictionary:businessOrder];
    
    //判断是否能组队接单 0不能 1能
    NSNumber *canMT=[result objectForKey:@"canMT"];
    _canMT=[canMT intValue];
    
     [self initAndLayoutUI];
    
    [self initBackView];
    _backView.hidden=YES;
}


#pragma mark ----------------------UITableViewDelegate----------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
