//
//  DetailViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/1.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "NetWorkInterface.h"
#import "ShipRelation.h"
#import "BusinessOrders.h"
#import "MyTaskViewController.h"
#import "WebViewViewController.h"
#import "ShipInfoViewController.h"

@interface TaskDetailViewController ()<UIAlertViewDelegate>
{
    UITableView *_tableView;
    UILabel *_fromLabel;
    UILabel *_toLabel;
    UIButton *_receive;
    UIView *_backView;
    UILabel *_shipPwd;
    UIView *_priceView;
    UILabel *_priceNumber;
    UIScrollView *_scrollView;
}

@property(nonatomic,strong)BusinessOrders *businessOrder;
@property(nonatomic,assign)BOOL isReceived;
@property(nonatomic,strong)NSNumber *singleShipCompleteNum;//几条船竞价
@property(nonatomic,strong)NSNumber *canSingleShipComplete;//单条船能否接单
@property(nonatomic,strong)NSString *code;//组队密码
@property(nonatomic,assign)double price;//记录报价

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"任务详情";
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self downloadData];
    //[self initAndLayoutUI];
    [self initBackView];
    _backView.hidden=YES;
    
    
}
-(void)initAndLayoutUI
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    _scrollView.contentSize=CGSizeMake(kScreenWidth, kScreenHeight+100);
    [self setSubviews];
    
    [self.view addSubview:_scrollView];
    
   
    
    

}

-(void)setSubviews
{
    CGFloat topSpace=10;
    CGFloat leftSpace=20;

    CGFloat cityWidth=160;
    CGFloat PortWidth=(kScreenWidth-leftSpace*2)/2;//港口label的宽度
    CGFloat jianTouWidth=42;//箭头的长度

    UIView *Vline1=[[UIView alloc]initWithFrame:CGRectMake(10, topSpace, 1, kScreenHeight+100)];
    Vline1.backgroundColor=kColor(213, 217, 218, 1.0);
    [_scrollView addSubview:Vline1];
    
    UIView *Vline2=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-10, topSpace, 1, kScreenHeight+100)];
    Vline2.backgroundColor=kColor(201, 201, 201, 1);
    [_scrollView addSubview:Vline2];

    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+100)];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(10, topSpace, kScreenWidth-10*2, 30)];
    view1.backgroundColor=kColor(217, 220, 221, 1);
    UIImageView *imav1=[[UIImageView alloc]initWithFrame:CGRectMake(10, (30-17)/2, 17, 17)];
    imav1.image=kImageName(@"company.png");
    [view1 addSubview:imav1];
    
    UILabel *company=[[UILabel alloc]initWithFrame:CGRectMake(10+17, (30-17)/2, 120, 17)];
    company.font=[UIFont systemFontOfSize:15];
    company.text=_businessOrder.companyName;
    [view1 addSubview:company];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(view1.bounds.size.width-10-80-10, (30-17)/2, 1, 17)];
    line1.backgroundColor=kColor(201, 201, 201, 1);
    [view1 addSubview:line1];
    
    UILabel *numShip=[[UILabel alloc]initWithFrame:CGRectMake(view1.bounds.size.width-80-10, (30-17)/2, 80, 17)];
    numShip.text=[NSString stringWithFormat:@"%@船竞价",_singleShipCompleteNum];
    numShip.font=[UIFont systemFontOfSize:15];
    numShip.textColor=kGrayColor;
    [view1 addSubview:numShip];
    
    [headView addSubview:view1];
    
    
    UIImageView *fromImaV=[[UIImageView alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+30+15, 12, 12)];
    fromImaV.image=kImageName(@"from.png");
    [headView addSubview:fromImaV];
    
    UILabel *fromCity=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2+12+10, topSpace+30+10,  cityWidth, 20)];
    fromCity.text=_businessOrder.beginPortName;
    fromCity.font=[UIFont boldSystemFontOfSize:16];
    fromCity.textColor=kGrayColor;
    [headView addSubview:fromCity];
    
    UILabel *fromPort=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5, PortWidth, 20)];
    fromPort.text=_businessOrder.beginDockName;
    //fromPort.backgroundColor=[UIColor redColor];
    fromPort.textColor=kGrayColor;
    fromPort.font=[UIFont systemFontOfSize:12];
    fromPort.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:fromPort];
    
    UIImageView *jianTou=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-jianTouWidth)/2, topSpace+30+10+15, jianTouWidth, 3)];
    jianTou.image=kImageName(@"jianTou.png");
    [headView addSubview:jianTou];
    
    UIImageView *toImaV=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+30+15, 12, 12)];
    toImaV.image=kImageName(@"to.png");
    [headView addSubview:toImaV];
    
    UILabel *toCity=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2+12+10, topSpace+30+10, cityWidth, 20)];
    toCity.text=_businessOrder.endPortName;
    toCity.textColor=kGrayColor;
    toCity.font=[UIFont boldSystemFontOfSize:16];
    [headView addSubview:toCity];
    
    UILabel *toPort=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2, topSpace+30+10+20+5, PortWidth, 20)];
    //toPort.backgroundColor=[UIColor blueColor];
    toPort.text=_businessOrder.endDockName;
    toPort.textAlignment=NSTextAlignmentCenter;
    toPort.font=[UIFont systemFontOfSize:12];
    toPort.textColor=kGrayColor;
    [headView addSubview:toPort];

    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(10, topSpace+30+10+20+5+20+10, kScreenWidth-10*2, 30)];
    view2.backgroundColor=kColor(193, 230, 242, 1.0);
    [headView addSubview:view2];
    
    UILabel *endTime=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 30)];
    endTime.text=_businessOrder.timeLeft;
    endTime.textAlignment=NSTextAlignmentCenter;
    endTime.font=[UIFont systemFontOfSize:12];
    [view2 addSubview:endTime];
    
    UILabel *deposit=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 30)];
    deposit.text=@"保证金:200.00元";
    deposit.textAlignment=NSTextAlignmentCenter;
    deposit.font=[UIFont systemFontOfSize:12];
    [view2 addSubview:deposit];
    
    //topSpace+30+10+20+5+20+10+30+10
    UILabel *goods=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10, kScreenWidth/2, 20)];
    goods.text=@"货物:";
    goods.font=[UIFont systemFontOfSize:12];
    [headView addSubview:goods];
    
    UILabel *goodsName=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5, 120, 20)];
    goodsName.text=@"货物名称";
    goodsName.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:goodsName];
    
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5, 120, 20)];
    name.textColor=kGrayColor;
    name.text=_businessOrder.companyName;
    [headView addSubview:name];
    
    UILabel *goodsWeight=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5, 120, 20)];
    goodsWeight.text=@"货物重量";
    goodsWeight.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:goodsWeight];
    
    UILabel *weight=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5, 120, 20)];
    weight.textColor=kGrayColor;
    weight.text=[NSString stringWithFormat:@"%@吨",_businessOrder.amount];
    [headView addSubview:weight];

    UILabel *goodsPrice=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20, 120, 20)];
    goodsPrice.text=@"限价";
    goodsPrice.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:goodsPrice];
    
    UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5, 120, 20)];
    double pay=[_businessOrder.maxPay doubleValue];
    price.text=[NSString stringWithFormat:@"￥%.2f元",pay];
    price.textColor=kGrayColor;
    [headView addSubview:price];
    
    UILabel *loadTime=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20, 120, 20)];
    loadTime.text=@"装船时间";
    loadTime.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:loadTime];
    
    UILabel *loadT=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5, 120, 20)];
    loadT.text=_businessOrder.workTime;
    loadT.textColor=kGrayColor;
    [headView addSubview:loadT];

    UILabel *loadtimeLimit=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20, 120, 20)];
    loadtimeLimit.text=@"装货时限";
    loadtimeLimit.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:loadtimeLimit];
    
    UILabel *loadlimit=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5, 120, 20)];
    loadlimit.text=[NSString stringWithFormat:@"%@天",_businessOrder.inDays];
    loadlimit.textColor=kGrayColor;
    [headView addSubview:loadlimit];
    
    UILabel *unloadTimeLimit=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20, 120, 20)];
    unloadTimeLimit.text=@"卸货时限";
    unloadTimeLimit.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:unloadTimeLimit];
    
    UILabel *unloadLimit=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5, 120, 20)];
    unloadLimit.text=[NSString stringWithFormat:@"%@天",_businessOrder.outDays];
    unloadLimit.textColor=kGrayColor;
    [headView addSubview:unloadLimit];
    
    UILabel *shipRule=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+10, kScreenWidth/2, 20)];
    shipRule.text=@"船规:";
    shipRule.font=[UIFont systemFontOfSize:12];
    [headView addSubview:shipRule];
    
    UILabel *shipWeight1=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+5, 120, 20)];
    shipWeight1.text=@"最小船吨位";
    shipWeight1.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:shipWeight1];
    
    UILabel *shipW1=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+20+5+5, 120, 20)];
    shipW1.text=[NSString stringWithFormat:@"%@天",_businessOrder.minAmount];
    shipW1.textColor=kGrayColor;
    [headView addSubview:shipW1];
    
    UILabel *shipWeight2=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+5, 120, 20)];
    shipWeight2.text=@"最大船吨位";
    shipWeight2.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:shipWeight2];
    
    UILabel *shipW2=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+20+5+5, 120, 20)];
    shipW2.text=[NSString stringWithFormat:@"%@天",_businessOrder.maxAmount];
    shipW2.textColor=kGrayColor;
    [headView addSubview:shipW2];

    UILabel *waterLevel=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+20+5+20+20+5, 120, 20)];
    waterLevel.text=@"吃水";
    waterLevel.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:waterLevel];
    
    UILabel *level=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+20+5+20+20+20+5+5, 120, 20)];
    level.text=[NSString stringWithFormat:@"%@米",_businessOrder.waterEat];
    level.textColor=kGrayColor;
    [headView addSubview:level];
    
    UILabel *shipCapacity=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+20+5+20+20+5, 120, 20)];
    shipCapacity.text=@"船容";
    shipCapacity.font=[UIFont boldSystemFontOfSize:18];
    [headView addSubview:shipCapacity];
    
    UILabel *capacity=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+20+5+20+20+20+5+5, 120, 20)];
    capacity.text=[NSString stringWithFormat:@"%@立方米",_businessOrder.storage];
    capacity.textColor=kGrayColor;
    [headView addSubview:capacity];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+20+5+20+20+20+5+5+20+20, kScreenWidth-leftSpace*2, 1)];
    line2.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line2];
    
    CGFloat buttonWidth=120;
    CGFloat buttonSpace=kScreenWidth-30*2-buttonWidth*2;
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(30, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+20+5+20+20+20+5+5+20+20+20, buttonWidth, 40);
    button1.layer.cornerRadius=4;
    button1.layer.masksToBounds=YES;
    [button1 setTitle:@"单船报价" forState:UIControlStateNormal];
    [button1 setBackgroundColor:kColor(22, 168, 238, 1)];
    [button1 addTarget:self action:@selector(quotation:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:button1];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(30+buttonWidth+buttonSpace, topSpace+30+10+20+5+20+10+30+10+20+5+20+5+20+20+20+5+20+20+20+5+20+20+10+20+5+20+20+20+5+5+20+20+20, buttonWidth, 40);
    button2.layer.cornerRadius=4;
    button2.layer.masksToBounds=YES;
    [button2 setTitle:@"组队接单" forState:UIControlStateNormal];
    [button2 setBackgroundColor:kMainColor];
    [button2 addTarget:self action:@selector(receive:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:button2];
    
    [_scrollView addSubview:headView];
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
    remark.text=@"在\"我的任务\"中可以管理船队";
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
-(void)initPriceView
{
    CGFloat width=kScreenWidth;
    CGFloat height=kScreenHeight;
    CGFloat leftSpace=20;
    CGFloat topSpace=20;
    CGFloat bottomSpace=10;
    //CGFloat vSpace=5;
    
    _priceView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _priceView.backgroundColor=[UIColor colorWithRed:95/255.0 green:114/255.0 blue:114/255.0 alpha:0.5];
    [self.view addSubview:_priceView];
    
    UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake((width-width*0.8)/2, 100, width*0.8, height*0.3)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [_priceView addSubview:whiteView];
    
    UILabel *title=[[UILabel alloc]init];
    title.font=[UIFont systemFontOfSize:16];
    title.text=@"请报价!";
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=[UIColor blackColor];
    title.frame=CGRectMake(leftSpace, topSpace, whiteView.bounds.size.width-leftSpace*2, 30);
    [whiteView addSubview:title];
    
    UIButton *reduceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    reduceBtn.frame=CGRectMake(leftSpace*2, (whiteView.bounds.size.height-34)/2, 34, 34);
    [reduceBtn setBackgroundImage:kImageName(@"reduceBtn.png") forState:UIControlStateNormal];
    [reduceBtn addTarget:self action:@selector(reduce:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:reduceBtn];
    
    _priceNumber=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2+34+10, (whiteView.bounds.size.height-30)/2, whiteView.bounds.size.width-leftSpace*2*2-34*2-10*2, 30)];
    _priceNumber.backgroundColor=kColor(231, 230, 230, 1);
    _priceNumber.text=@"1.00";
    _priceNumber.font=[UIFont systemFontOfSize:14];
    _priceNumber.textAlignment=NSTextAlignmentCenter;
    [whiteView addSubview:_priceNumber];
    
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(whiteView.bounds.size.width-leftSpace*2-34, (whiteView.bounds.size.height-34)/2, 34, 34);
    [addBtn setBackgroundImage:kImageName(@"addBtn.png") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:addBtn];


    UIButton *sureBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBTN.frame=CGRectMake((width*0.8-60)/2, height*0.3-bottomSpace-30, 60, 30);
    sureBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [sureBTN setTitle:@"确定" forState:UIControlStateNormal];
    [sureBTN setTitleColor:[self colorWithHexString:@"757474"] forState:UIControlStateNormal];
    [sureBTN addTarget:self action:@selector(priceSureBTN:) forControlEvents:UIControlEventTouchUpInside];
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
//减小报价
-(void)reduce:(UIButton*)btn
{
    _price=[_priceNumber.text doubleValue];
    _price = _price - 0.01 ;
    _priceNumber.text=[NSString stringWithFormat:@"%.2f",_price];
    
}
//增加报价
-(void)add:(UIButton*)btn
{
    _price=[_priceNumber.text doubleValue];
    _price += 0.01;
    _priceNumber.text=[NSString stringWithFormat:@"%.2f",_price];
}
//报价确认
-(void)priceSureBTN:(UIButton*)btn
{
   
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *shipName=[user objectForKey:@"shipName"];
    
    if (shipName && ![shipName isEqualToString:@""])
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"竞价中...";
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        NSNumber *shipOwnerId=[userDefault objectForKey:@"shipOwnerId"];
        NSNumber *loginId=[userDefault objectForKey:@"loginId"];
        [NetWorkInterface singleShipCompletWithshipOwnerId:[shipOwnerId intValue] bsOrderId:[_businessOrder.ID intValue] loginId:[loginId intValue] quote:_price finished:^(BOOL success, NSData *response) {
            
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            
            NSLog(@"------------单船竞价----:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            
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
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"操作成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [alert show];
                        
                    }else
                    {
                        
                        //hud.labelText=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.customView = [[UIImageView alloc] init];
                        hud.mode = MBProgressHUDModeCustomView;
                        [hud hide:YES afterDelay:1.f];
                        hud.labelText = [object objectForKey:@"message"];
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
        
        [_priceView removeFromSuperview];

    }else
    {
        //信息不完全
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不完全,去完善船舶信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag=1;
        [alert show];
    }
}

-(void)sureBTN:(UIButton*)btn
{
    _backView.hidden=YES;
}

//单船报价
-(void)quotation:(UIButton*)sender
{
    [self initPriceView];
    
}


//组队接单
-(IBAction)receive:(UIButton*)sender
{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不完全,去完善船舶信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    [alert show];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *shipName=[user objectForKey:@"shipName"];
    
    if ( shipName && ![shipName isEqualToString:@""])
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

    }else
    {
        //信息不完全
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不完全,去完善船舶信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];

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
        NSLog(@"------------任务详情:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
    
    _canSingleShipComplete=[result objectForKey:@"canSingleShipComplete"];
    _singleShipCompleteNum=[result objectForKey:@"singleShipCompleteNum"];
    
    NSDictionary *businessOrder=[result objectForKey:@"businessOrder"];
    _businessOrder=[[BusinessOrders alloc]initWithDictionary:businessOrder];
    
    //判断是否能组队接单 0不能 1能
    NSNumber *canMT=[result objectForKey:@"canMT"];
    _canMT=[canMT intValue];
    
     [self initAndLayoutUI];
    
    [self initBackView];
    _backView.hidden=YES;
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        ShipInfoViewController *shipInfo=[[ShipInfoViewController alloc]init];
        shipInfo.type=@"isPush";
        shipInfo.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:shipInfo animated:YES];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
