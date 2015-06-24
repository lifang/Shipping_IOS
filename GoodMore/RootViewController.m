//
//  ViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/5/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//
#import "RootViewController.h"
#import "NavigationBar.h"
#import "Constants.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
   
//    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//    if (![userDefaults objectForKey:@"loginName"])
//    {
//        [self showLoginViewController];
//    }else
//    {
//        [self showMainViewController];
//    }
    UIImageView *bg=[[UIImageView alloc]initWithImage:kImageName(@"bg")];
    bg.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIImageView *smallBG=[[UIImageView alloc]initWithImage:kImageName(@"smallBG")];
    smallBG.frame=CGRectMake((kScreenWidth-116)/2, kScreenHeight/2-116, 116, 116);
    [bg addSubview:smallBG];
    [self.view addSubview:bg];
    
    CGFloat leftSpace=10;
    CGFloat bottomSpace=20;
    CGFloat width=(kScreenWidth-leftSpace*3)/2;
    NSArray *title=[[NSArray alloc]initWithObjects:@"注册",@"登录", nil];
    for (int i=0; i<2; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius=4;
        button.layer.masksToBounds=YES;
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        button.frame=CGRectMake(leftSpace+(leftSpace+width)*i, kScreenHeight-bottomSpace-40, width, 40);
        button.tag=i;
        if (i==0)
        {
            [button setBackgroundColor:kMainColor];
        }else
        {
            [button setBackgroundColor:[UIColor orangeColor]];
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}
-(void)buttonClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 0:
        {
            [self showRegisterViewcontroller];
        }
            break;
        case 1:
        {
            [self showLoginViewController];
        }
            break;
        default:
            break;
    }
}
-(void)showRegisterViewcontroller
{
    if (!_registNav)
    {
        RegisterViewController *registVC=[[RegisterViewController alloc]init];
        _registNav=[[UINavigationController alloc]initWithRootViewController:registVC];
        _registNav.view.frame=self.view.bounds;
        [self.view addSubview:_registNav.view];
        [self addChildViewController:_registNav];
        [NavigationBar setNavigationBarStyle:_registNav];
    }
    if (_loginViewController) {
        [_loginViewController.view removeFromSuperview];
        [_loginViewController removeFromParentViewController];
        _loginViewController = nil;
    }

}
-(void)showLoginViewController
{
    if (!_loginNav)
    {
        LoginViewController *logVC=[[LoginViewController alloc]init];
        _loginNav=[[UINavigationController alloc]initWithRootViewController:logVC];
        _loginNav.view.frame=self.view.bounds;
        [self.view addSubview:_loginNav.view];
        [self addChildViewController:_loginNav];
        [NavigationBar setNavigationBarStyle:_loginNav];
    }
    if (_registerViewController) {
        [_registerViewController.view removeFromSuperview];
        [_registerViewController removeFromParentViewController];
        _registerViewController = nil;
    }

}

//-(void)showMainViewController
//{
//    if (!_mainViewController) {
//        _mainViewController=[[MainViewController alloc]init];
//        _mainViewController.view.frame=self.view.bounds;
//        [self.view addSubview:_mainViewController.view];
//        [self addChildViewController:_mainViewController];
//    }
//    if (_loginNav)
//    {
//        [_loginNav.view removeFromSuperview];
//        [_loginNav removeFromParentViewController];
//        _loginNav=nil;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
