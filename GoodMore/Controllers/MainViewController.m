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
{
    UIView *_backView;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControllers];
    //处理船的级别问题
    //[self checkShipRank];
}
////判断船的级别
//-(void)checkShipRank
//{
//    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//    NSString *type=[userDefault objectForKey:@"type"];
//    if ([type intValue]==1)
//    {
//        //高级船
//    }else if ([type intValue]==6)
//    {
//        //普通船
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您现在的船舶级别为普通船,普通船无法组队接单,只能加入船队进行接单!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"升级为高级船", nil];
//        [alertView show];
//    }
//}
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


@end
