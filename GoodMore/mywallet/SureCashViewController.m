//
//  SureCashViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/11.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "SureCashViewController.h"
#import "Constants.h"
#import "BankInfoViewController.h"
@interface SureCashViewController ()

@end

@implementation SureCashViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"提现确认";
    [self initAndLayoutUI];
}
-(void)initAndLayoutUI
{
    UIImageView *bg=[[UIImageView alloc]initWithFrame:self.view.frame];
    bg.image=kImageName(@"kuang");
    [self.view addSubview:bg];
    
    CGFloat topSpace=40;
    CGFloat leftSpace=30;
    CGFloat Vspace=30;
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace, kScreenWidth-leftSpace*2, 30)];
    label1.textColor=kWalletTitleColor;
    label1.text=@"本次提现:";
    label1.textAlignment=NSTextAlignmentLeft;
    label1.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:label1];
    
    UILabel *cash=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(label1.frame)-5, kScreenWidth-leftSpace*2, 30)];
    cash.textColor=kWalletTitleColor;
    cash.font=[UIFont systemFontOfSize:18];
    cash.textAlignment=NSTextAlignmentLeft;
    //cash.text=[NSString stringWithFormat:@"%@元",_moneyNum.allNum];
    cash.text=_moneyNum;
    [self.view addSubview:cash];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(cash.frame)+Vspace, kScreenWidth-leftSpace*2, 30)];
    label2.text=@"扣手续费:";
    label2.textAlignment=NSTextAlignmentLeft;
    label2.textColor=kWalletTitleColor;
    label2.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:label2];
    
    UILabel *commission=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(label2.frame)-5, kScreenWidth-2*leftSpace, 30)];
    commission.textAlignment=NSTextAlignmentLeft;
    commission.textColor=kWalletTitleColor;
    commission.font=[UIFont systemFontOfSize:18];
    //commission.text=[NSString stringWithFormat:@"%@元",_moneyNum.sxf];
     commission.text=_moneyNum;
    [self.view addSubview:commission];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(commission.frame)+Vspace, kScreenWidth-2*leftSpace, 30)];
    label3.text=@"实际到账:";
    label3.textAlignment=NSTextAlignmentLeft;
    label3.textColor=kWalletTitleColor;
    label3.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:label3];
    
    UILabel *reality=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(label3.frame)-5, kScreenWidth-2*leftSpace, 30)];
    //reality.text=[NSString stringWithFormat:@"%@元",_moneyNum.actualNum];
     reality.text=_moneyNum;
    reality.textAlignment=NSTextAlignmentLeft;
    reality.textColor=kWalletTitleColor;
    reality.font=[UIFont systemFontOfSize:18];
    [self.view addSubview:reality];
    
    //画线
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(reality.frame)+Vspace, kScreenWidth, 0.5)];
    line1.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line1];
    
    UIButton *sureCash=[UIButton buttonWithType:UIButtonTypeCustom];
    sureCash.frame=CGRectMake(leftSpace*2, CGRectGetMaxY(line1.frame)+Vspace, kScreenWidth-leftSpace*4, 40);
    [sureCash setTitle:@"确认提现" forState:UIControlStateNormal];
    [sureCash addTarget:self action:@selector(sureCash:) forControlEvents:UIControlEventTouchUpInside];
    [sureCash setBackgroundColor:kMainColor];
    sureCash.layer.masksToBounds=YES;
    sureCash.layer.cornerRadius=2;
    [self.view addSubview:sureCash];
    
    
}
//确认提现
-(void)sureCash:(UIButton*)sender
{
    BankInfoViewController *bankInfo=[[BankInfoViewController alloc]init];
    //bankInfo.cashNum=_moneyNum.allNum;
    bankInfo.cashNum=_moneyNum;
    [self.navigationController pushViewController:bankInfo animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
