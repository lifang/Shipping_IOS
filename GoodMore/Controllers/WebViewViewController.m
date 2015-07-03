//
//  WebViewViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/30.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "WebViewViewController.h"
#import "Constants.h"
@interface WebViewViewController ()
{
    UIWebView *_webView;
}
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem=leftButtonItem;
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _webView.backgroundColor=[UIColor whiteColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    [self.view addSubview:_webView];
}
-(IBAction)back:(id)sender
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
