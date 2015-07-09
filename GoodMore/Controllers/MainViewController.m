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
#import "TransportingViewController.h"
#import "MyShipViewController.h"
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
    
//    UIImageView *s=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"to.png"]];
//    s.frame=CGRectMake(kScreenWidth/2+40, 15, 20, 20);
//    //[self.tabBarController.view addSubview:s];
//    [self.tabBar addSubview:s];
    
    
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
    
    TransportingViewController *transVC=[[TransportingViewController alloc]init];
    transVC.tabBarItem.title=@"运输中";
    transVC.tabBarItem.image=[kImageName(@"trans_n.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    transVC.tabBarItem.selectedImage=[kImageName(@"trans_h.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *transNav=[[UINavigationController alloc]initWithRootViewController:transVC];
    [NavigationBar setNavigationBarStyle:transNav];
    
    MyShipViewController*myShipVC=[[MyShipViewController alloc]init];
    myShipVC.tabBarItem.title=@"我的船队";
    myShipVC.tabBarItem.image=[kImageName(@"ship_n.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myShipVC.tabBarItem.selectedImage=[kImageName(@"ship_h.png")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController*myShipNav=[[UINavigationController alloc]initWithRootViewController:myShipVC];

    [NavigationBar setNavigationBarStyle:myShipNav];
    self.viewControllers=[[NSArray alloc]initWithObjects:taskNav,transNav,myShipNav, nil];
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
