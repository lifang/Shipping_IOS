//
//  MainViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/5/29.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MainViewController.h"
#import "TaskViewController.h"
#import "MyTaskViewController.h"
#import "MyWalletViewController.h"
#import "NavigationBar.h"
#import "Constants.h"
#import "NavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initControllers];
}
-(void)initControllers
{
    
    [[self tabBar] setBackgroundImage:[UIImage imageNamed:@"tabBG.png"]];
    //处理黑线
    [[UITabBar appearance]setShadowImage:[[UIImage alloc]init]];
    TaskViewController *taskVC=[[TaskViewController alloc]init];
    taskVC.tabBarItem.title = @"任务大厅";
    taskVC.tabBarItem.image=[kImageName(@"tabar1_n.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    taskVC.tabBarItem.selectedImage=[kImageName(@"tabar1_h.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *taskNav=[[UINavigationController alloc]initWithRootViewController:taskVC];
    [NavigationBar setNavigationBarStyle:taskNav];
    
    MyTaskViewController *myTaskVC=[[MyTaskViewController alloc]init];
    myTaskVC.tabBarItem.title=@"我的任务";
    myTaskVC.tabBarItem.image=[kImageName(@"tabar2_n.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myTaskVC.tabBarItem.selectedImage=[kImageName(@"tabar2_h.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *myTaskNav=[[UINavigationController alloc]initWithRootViewController:myTaskVC];
    [NavigationBar setNavigationBarStyle:myTaskNav];
    
    MyWalletViewController*walletVC=[[MyWalletViewController alloc]init];
    walletVC.tabBarItem.title=@"我的钱包";
    walletVC.tabBarItem.image=[kImageName(@"wallet_n.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    walletVC.tabBarItem.selectedImage=[kImageName(@"wallet_h.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController*walletNav=[[UINavigationController alloc]initWithRootViewController:walletVC];
    //[walletNav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [NavigationBar setNavigationBarStyle:walletNav];
    self.viewControllers=[[NSArray alloc]initWithObjects:myTaskNav,taskNav,walletNav, nil];
    self.selectedIndex=1;
    
    
}
-(IBAction)personal:(id)sender
{
    NSLog(@"----------------个人");
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
