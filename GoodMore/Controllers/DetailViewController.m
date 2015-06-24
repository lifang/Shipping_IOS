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
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UILabel *_fromLabel;
    UILabel *_toLabel;
    UIButton *_receive;
}
@property(nonatomic,strong)ShipRelation *shipRelation;
@property(nonatomic,strong)BusinessOrders *businessOrder;
@property(nonatomic,assign)BOOL isReceived;
@property(nonatomic,strong)NSNumber *shipOrderRelation;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"任务详情";
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self downloadData];
    
}
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    UIImageView*imaV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imaV.image=kImageName(@"kuang.png");
    //_tableView.backgroundColor=[UIColor blackColor];
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
    
    if (_selectedIndex==1)
    {
         [self setFootView1];
    }else{
        [self setFootView2];
    }
   
}
-(void)setFootView2
{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.2)];
    
    footView.backgroundColor=[UIColor clearColor];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 0.5, kScreenWidth-20, 0.5)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [footView addSubview:line];
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
    
    _tableView.tableFooterView=footView;
}
-(void)setFootView1
{
    _isReceived=NO;
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.2)];
    footView.backgroundColor=[UIColor clearColor];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 0.5, kScreenWidth-20, 0.5)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [footView addSubview:line];
     _receive=[UIButton buttonWithType:UIButtonTypeCustom];
    _receive.frame=CGRectMake(80, (footView.bounds.size.height-40)/2-10, kScreenWidth-160, 40);
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber *shipOrderRelation=[userDefault objectForKey:@"shipOrderRelation"];
    
    if ([shipOrderRelation intValue]>0)
    {
        _isReceived=YES;
        [_receive setTitle:@"已接单" forState:UIControlStateNormal];
        _receive.backgroundColor=kGrayColor;
    }else
    {
        _isReceived=NO;
        [_receive setTitle:@"我要接单" forState:UIControlStateNormal];
        _receive.backgroundColor=kMainColor;
    }
    
    _receive.layer.masksToBounds=YES;
    _receive.layer.cornerRadius=4;
    [_receive addTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_receive];
    _tableView.tableFooterView=footView;
   
    
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
        bigVSpace=30;
    }else
    {
        bigVSpace=20;
    }
    
    //货代框
    CGFloat gentW=120;
    CGFloat gentH=20;
    //货物属性框
    CGFloat goodW=120;
    CGFloat goodH=20;
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.8*kScreenHeight)];
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
    
    UILabel *priceLabel=[[UILabel alloc]init];
    priceLabel.translatesAutoresizingMaskIntoConstraints=NO;
    priceLabel.text=@"货物单价";
    priceLabel.textColor=[UIColor blackColor];
    priceLabel.font=[UIFont boldSystemFontOfSize:15];
    [headView addSubview:priceLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:name attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *price=[[UILabel alloc]init];
    price.translatesAutoresizingMaskIntoConstraints=NO;
    double prices=[_businessOrder.price doubleValue];
    NSString *p=[NSString stringWithFormat:@"%.2f",prices];
    price.text=[NSString stringWithFormat:@"%@元/吨",p];
    price.textColor=kGrayColor;
    price.font=[UIFont systemFontOfSize:15];
    [headView addSubview:price];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:priceLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace/2]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:price attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *chargeLabel=[[UILabel alloc]init];
    chargeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    chargeLabel.text=@"运价";
    chargeLabel.textColor=[UIColor blackColor];
    chargeLabel.font=[UIFont boldSystemFontOfSize:15];
    [headView addSubview:chargeLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:chargeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:priceLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:chargeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:priceLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:bigHSpace]];
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
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:price attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:chargeLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:charge attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    timeLabel.text=@"装船时间";
    timeLabel.textColor=[UIColor blackColor];
    timeLabel.font=[UIFont boldSystemFontOfSize:15];
    [headView addSubview:timeLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:price attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *time=[[UILabel alloc]init];
    time.translatesAutoresizingMaskIntoConstraints=NO;
    time.text=_businessOrder.workTime;
    time.textColor=kGrayColor;
    time.font=[UIFont systemFontOfSize:15];
    [headView addSubview:time];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:timeLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace/2]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:time attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *periodLabel=[[UILabel alloc]init];
    periodLabel.translatesAutoresizingMaskIntoConstraints=NO;
    periodLabel.text=@"装卸周期";
    periodLabel.textColor=[UIColor blackColor];
    periodLabel.font=[UIFont boldSystemFontOfSize:15];
    [headView addSubview:periodLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:timeLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:timeLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:bigHSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:periodLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    UILabel *period=[[UILabel alloc]init];
    period.translatesAutoresizingMaskIntoConstraints=NO;
    period.text=[NSString stringWithFormat:@"%@天",_businessOrder.days];
    period.textColor=kGrayColor;
    period.font=[UIFont systemFontOfSize:15];
    [headView addSubview:period];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:time attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:periodLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:period attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    
    UILabel *remarkLabel=[[UILabel alloc]init];
    remarkLabel.translatesAutoresizingMaskIntoConstraints=NO;
    remarkLabel.text=@"说明";
    //remarkLabel.textColor=[UIColor blackColor];
    remarkLabel.font=[UIFont boldSystemFontOfSize:15];
    [headView addSubview:remarkLabel];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remarkLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:time attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bigVSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remarkLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remarkLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodW]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remarkLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:goodH]];
    
    
    UILabel *remark=[[UILabel alloc]init];
    remark.translatesAutoresizingMaskIntoConstraints=NO;
    remark.numberOfLines=0;
    //remark.backgroundColor=[UIColor redColor];
    if ([_businessOrder.remarks isEqualToString:@""])  {
        remark.text=@"无";
    }else
    {
        remark.text=_businessOrder.remarks;
    }
    
    remark.textColor=kGrayColor;
    remark.font=[UIFont systemFontOfSize:15];
    [headView addSubview:remark];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remark attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:remarkLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remark attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remark attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth-40]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:remark attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];

}

//我要接单
-(IBAction)receive:(UIButton*)sender
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if (_isReceived==YES)
    {
        hud.labelText=@"此单已接";
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
    }else
    {
        hud.labelText=@"接单中...";
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        int loginId=[[userDefaults objectForKey:@"loginId"] intValue];
        NSString *ordersList = [NSString stringWithFormat:@"%@",_businessOrder.ID];
        [NetWorkInterface bindOrderWithloginId:loginId ordersList:ordersList finished:^(BOOL success, NSData *response) {
            
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            NSLog(@"------------绑定----:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    NSDictionary *shipRelation=[result objectForKey:@"shipRelation"];
    _shipOrderRelation=[result objectForKey:@"shipOrderRelation"];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:_shipOrderRelation forKey:@"shipOrderRelation"];
    [user synchronize];
    _shipRelation=[[ShipRelation alloc]initWithDictionary:shipRelation];
    NSDictionary *businessOrders=[result objectForKey:@"businessOrders"];
    _businessOrder=[[BusinessOrders alloc]initWithDictionary:businessOrders];
    [self initAndLayoutUI];
    

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
