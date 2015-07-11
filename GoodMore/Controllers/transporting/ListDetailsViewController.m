
//
//  ListDetailsViewController.m
//  GoodMore
//
//  Created by comdosoft on 15/7/11.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ListDetailsViewController.h"
#import "BusinessOrders.h"
@interface ListDetailsViewController ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)BusinessOrders *businessOrder;
@property(nonatomic,strong)NSString *payMoney;
@property(nonatomic,strong)NSString *toBPortTime;
@property(nonatomic,strong)NSString *toBPortTimeStr;
@property(nonatomic,strong)NSString *toEPortTime;
@property(nonatomic,strong)NSString *toEPortTimeStr;

@end

@implementation ListDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self downloadData];
    
//    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
//    _scrollView.contentSize=CGSizeMake(kScreenWidth, kScreenHeight+100);
//    
//    [self.view addSubview:_scrollView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)downloadData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefault objectForKey:@"loginId"] intValue];
    int shipOwnerId=[[userDefault objectForKey:@"shipOwnerId"] intValue];

    [NetWorkInterface ListDetailWithID:self.ID loginId:86 shipOwnerId:63 finished:^(BOOL success, NSData *response) {
   
        
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
    
 
    NSDictionary *businessOrder=[result objectForKey:@"businessOrder"];
    if ([[result objectForKey:@"sbRelation"] objectForKey:@"payMoney"]) {
        _payMoney = [[result objectForKey:@"sbRelation"] objectForKey:@"payMoney"];

    }
    else
    {
    _payMoney = @"";
        
    }
    if ([[result objectForKey:@"sbRelation"] objectForKey:@"toBPortTime"]) {
        _toBPortTime = [[result objectForKey:@"sbRelation"] objectForKey:@"toBPortTime"];
        
    }
    else
    {
        _toBPortTime = @"";
        
    }
    if ([[result objectForKey:@"sbRelation"] objectForKey:@"toBPortTimeStr"]) {
        _toBPortTimeStr = [[result objectForKey:@"sbRelation"] objectForKey:@"toBPortTimeStr"];
        
    }
    else
    {
        _toBPortTimeStr = @"";
        
    }
    if ([[result objectForKey:@"sbRelation"] objectForKey:@"toEPortTime"]) {
        _toEPortTime = [[result objectForKey:@"sbRelation"] objectForKey:@"toEPortTime"];
        
    }
    else
    {
        _toEPortTime = @"";
        
    }
    if ([[result objectForKey:@"sbRelation"] objectForKey:@"toEPortTimeStr"]) {
        _toEPortTimeStr = [[result objectForKey:@"sbRelation"] objectForKey:@"toEPortTimeStr"];
        
    }
    else
    {
        _toEPortTimeStr = @"";
        
    }


    _businessOrder=[[BusinessOrders alloc]initWithDictionary:businessOrder];
    [self setSubviews];

    
    
}

-(void)setSubviews
{
    CGFloat topSpace=10;
    CGFloat leftSpace=20;
    
    CGFloat cityWidth=100;
    CGFloat PortWidth=kScreenWidth/3;//港口label的宽度
    CGFloat jianTouWidth=42;//箭头的长度
    
//    UIView *Vline1=[[UIView alloc]initWithFrame:CGRectMake(10, topSpace, 1, kScreenHeight+100)];
//    Vline1.backgroundColor=kColor(213, 217, 218, 1.0);
//    [_scrollView addSubview:Vline1];
//    
//    UIView *Vline2=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-10, topSpace, 1, kScreenHeight+100)];
//    Vline2.backgroundColor=kColor(201, 201, 201, 1);
//    [_scrollView addSubview:Vline2];
    
    
    UIScrollView *headView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [self.view addSubview:headView];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(10, topSpace, kScreenWidth-10*2, 30)];
    view1.backgroundColor=kColor(217, 220, 221, 1);
    
    UIImageView *imav1=[[UIImageView alloc]initWithFrame:CGRectMake(10, (30-17)/2, 17, 17)];
    imav1.image=kImageName(@"company.png");
    [view1 addSubview:imav1];
    
    UILabel *company=[[UILabel alloc]initWithFrame:CGRectMake(10+17, (30-17)/2, 120, 17)];
    company.font=[UIFont systemFontOfSize:15];
    company.text=_businessOrder.companyName;
    [view1 addSubview:company];
    
//    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(view1.bounds.size.width-10-80-10, (30-17)/2, 1, 17)];
//    line1.backgroundColor=kColor(201, 201, 201, 1);
//    [view1 addSubview:line1];
    
//    UILabel *numShip=[[UILabel alloc]initWithFrame:CGRectMake(view1.bounds.size.width-80-10, (30-17)/2, 80, 17)];
//    numShip.text=[NSString stringWithFormat:@"%@船竞价",_singleShipCompleteNum];
//    numShip.font=[UIFont systemFontOfSize:15];
//    numShip.textColor=kGrayColor;
//    [view1 addSubview:numShip];
//    
    [headView addSubview:view1];
    
    
    UIImageView *fromImaV=[[UIImageView alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+30+15, 12, 12)];
    fromImaV.image=kImageName(@"from.png");
    [headView addSubview:fromImaV];
    
    UILabel *fromCity=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2+12+10, topSpace+30+10,  cityWidth, 20)];
    fromCity.text=_businessOrder.beginPortName;
//    fromCity.font=[UIFont boldSystemFontOfSize:18];
    fromCity.textColor=kGrayColor;
    [headView addSubview:fromCity];
    
    UILabel *fromPort=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+10+20+5, PortWidth, 20)];
    fromPort.text=_businessOrder.beginDockName;
    fromPort.textColor=kGrayColor;
    fromPort.font=[UIFont systemFontOfSize:15];
    fromPort.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:fromPort];
    
    UIImageView *jianTou=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-jianTouWidth)/2, topSpace+30+10+20, jianTouWidth, 3)];
    jianTou.image=kImageName(@"jianTou.png");
    [headView addSubview:jianTou];
    
    UIImageView *toImaV=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+30+15, 12, 12)];
    toImaV.image=kImageName(@"to.png");
    [headView addSubview:toImaV];
    
    UILabel *toCity=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2+12+10, topSpace+30+10, cityWidth, 20)];
    toCity.text=_businessOrder.endPortName;
    toCity.textColor=kGrayColor;
//    toCity.font=[UIFont boldSystemFontOfSize:20];
    [headView addSubview:toCity];
    
    UILabel *toPort=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+30+10+20+5, PortWidth, 20)];
    toPort.text=_businessOrder.endDockName;
    toPort.textAlignment=NSTextAlignmentCenter;
    toPort.font=[UIFont systemFontOfSize:15];
    toPort.textColor=kGrayColor;
    [headView addSubview:toPort];
    
//    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(10, topSpace+30+10+20+5+20+10, kScreenWidth-10*2, 30)];
//    view2.backgroundColor=kColor(193, 230, 242, 1.0);
//    [headView addSubview:view2];
//    
//    UILabel *endTime=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 30)];
//    endTime.text=@"2小时53分45秒后结束";
//    endTime.textAlignment=NSTextAlignmentCenter;
//    endTime.font=[UIFont systemFontOfSize:12];
//    [view2 addSubview:endTime];
//    
//    UILabel *deposit=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 30)];
//    deposit.text=@"保证金:200.00元";
//    deposit.textAlignment=NSTextAlignmentCenter;
//    deposit.font=[UIFont systemFontOfSize:12];
//    [view2 addSubview:deposit];
    
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
    UILabel *paymoneyLable=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, line2.frame.origin.y+line2.frame.size.height+10, kScreenWidth-20, 20)];
    paymoneyLable.text=[NSString stringWithFormat:@"%@钱",_payMoney];
//    capacity.textColor=kGrayColor;
    [headView addSubview:paymoneyLable];
    UILabel *toBPortTimeLable=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, paymoneyLable.frame.origin.y+paymoneyLable.frame.size.height+10, kScreenWidth-20, 20)];
    if ([self isBlankString:_toBPortTime]) {
        toBPortTimeLable.text=[NSString stringWithFormat:@""];

    }
    else
    {
        toBPortTimeLable.text=[NSString stringWithFormat:@"%@",_toBPortTime];

    
    }
    //    capacity.textColor=kGrayColor;
    [headView addSubview:toBPortTimeLable];
    UILabel *toBPortTimeStrLable=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, toBPortTimeLable.frame.origin.y+toBPortTimeLable.frame.size.height+10, kScreenWidth-20, 20)];
    if ([self isBlankString:_toBPortTimeStr]) {
        toBPortTimeStrLable.text=[NSString stringWithFormat:@""];
        
    }
    else
    {
        toBPortTimeStrLable.text=[NSString stringWithFormat:@"%@",_toBPortTimeStr];
        
        
    }

    //    capacity.textColor=kGrayColor;
    [headView addSubview:toBPortTimeStrLable];
    UILabel *toEPortTimeLable=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, toBPortTimeStrLable.frame.origin.y+toBPortTimeStrLable.frame.size.height+10, kScreenWidth-20, 20)];
    if ([self isBlankString:_toEPortTime]) {
        toEPortTimeLable.text=[NSString stringWithFormat:@""];
        
    }
    else
    {
        toEPortTimeLable.text=[NSString stringWithFormat:@"%@",_toEPortTime];
        
        
    }

    //    capacity.textColor=kGrayColor;
    [headView addSubview:toEPortTimeLable];
    UILabel *toEPortTimeStrLable=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, toEPortTimeLable.frame.origin.y+toEPortTimeLable.frame.size.height+10, kScreenWidth-20, 20)];
    if ([self isBlankString:_toEPortTimeStr]) {
        toEPortTimeStrLable.text=[NSString stringWithFormat:@""];
        
    }
    else
    {
        toEPortTimeStrLable.text=[NSString stringWithFormat:@"%@",_toEPortTimeStr];
        
        
    }

    //    capacity.textColor=kGrayColor;
    [headView addSubview:toEPortTimeStrLable];
    headView.contentSize=CGSizeMake(kScreenWidth, toEPortTimeStrLable.frame.origin.y+toEPortTimeStrLable.frame.size.height+80);
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
