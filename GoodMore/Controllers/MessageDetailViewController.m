//
//  MessageDetailViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"消息详情";
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initUI];
    
}
-(void)initUI
{
    CGFloat leftSpace=10;
    CGFloat topSpace=10;
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace, kScreenWidth-leftSpace*2, 30)];
    title.text=_message.title;
    title.font=[UIFont boldSystemFontOfSize:20];
    title.textColor=[UIColor blackColor];
    [self.view addSubview:title];
    
    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30, kScreenWidth-leftSpace*2, 20)];
    time.text=_message.updateTime;
    time.font=[UIFont systemFontOfSize:12];
    time.textColor=[UIColor grayColor];
    [self.view addSubview:time];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+20, kScreenWidth-leftSpace*2, 1)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line];
    
    
    
    UITextView *content=[[UITextView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+20+10, kScreenWidth-leftSpace*2, kScreenHeight-(topSpace+30+20+10))];
    content.text=_message.content;
    content.textColor=kGrayColor;
    content.editable=NO;
    content.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:content];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
