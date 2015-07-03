//
//  RegresultViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/25.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "RegresultViewController.h"
#import "Constants.h"
#import "RootViewController.h"

static NSString *s_phoneNumber=@"4008008888";

@interface RegresultViewController ()<UIActionSheetDelegate>

@end

@implementation RegresultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"温馨提示";
    [self initAndLayoutUI];
}
-(void)initAndLayoutUI
{
    CGFloat leftSpace=20;
    CGFloat topSpace=50;
    CGFloat Vspace=10;
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *result=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace, kScreenWidth-leftSpace*2, 30)];
    result.text=@"账户等待审核";
    result.textAlignment=NSTextAlignmentCenter;
    result.textColor=[UIColor blackColor];
    result.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:result];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(leftSpace/2, topSpace+30+Vspace, kScreenWidth-leftSpace, 1)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line];
    
    UILabel *phone=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+Vspace+Vspace+1+8, kScreenWidth-leftSpace*2, 16)];
    phone.userInteractionEnabled=YES;
    phone.text=@"请与客服400-800-8888联系";
    phone.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:phone];
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [phone addGestureRecognizer:tap1];
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+Vspace*2+1+8+16+2, kScreenWidth-leftSpace*2, 16)];
    label.text=@"加快审核进度!";
    label.textAlignment=NSTextAlignmentCenter;
    label.userInteractionEnabled=YES;
    [self.view addSubview:label];
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [label addGestureRecognizer:tap2];

    
    UIButton *signOut=[UIButton buttonWithType:UIButtonTypeCustom];
    signOut.frame=CGRectMake(leftSpace*2, topSpace+30+Vspace*2+1+16+16+70, kScreenWidth-leftSpace*4, 40);
    signOut.layer.cornerRadius=4;
    signOut.layer.masksToBounds=YES;
    signOut.backgroundColor=kMainColor;
    [signOut setTitle:@"退出" forState:UIControlStateNormal];
    [signOut addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signOut];
}
#pragma mark ---action---
-(void)tap:(UITapGestureRecognizer*)tap
{
    //联系客服
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:s_phoneNumber
                                              otherButtonTitles:nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];

}
-(void)signOut
{
    RootViewController *root=[[RootViewController alloc]init];
    [self presentViewController:root animated:YES completion:nil];
}
#pragma mark - UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",s_phoneNumber]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
