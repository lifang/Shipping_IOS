
//
//  MyMessageViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "RightViewController.h"
#import "MYInfoView.h"
#import "Constants.h"
#import "NavigationBar.h"
#import "SettingViewController.h"  //我的资料
#import "ShipInfoViewController.h" //船舶情况
#import "MyWalletViewController.h" //我的钱包
#import "MessageViewController.h"  //我的消息
#import "RootViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"
@interface RightViewController ()<MYInfoViewDelegate,UIAlertViewDelegate>

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
}

-(void)initUI
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *name=[userDefault objectForKey:@"name"];
    NSString *phone=[userDefault objectForKey:@"phone"];
    NSString *moneyCanGet=[userDefault objectForKey:@"moneyCanGet"];
    MYInfoView *view=[[MYInfoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, kScreenHeight)];
    view.delegate=self;
    view.name.text=name;
    view.phone.text=phone;
    view.cash.text=[NSString stringWithFormat:@"￥%@",moneyCanGet];
    view.cash.textColor=kColor(250, 131, 8, 1.0);
    [self.view addSubview:view];
}
#pragma mark MYInfoViewDelegate
-(void)selectInfoWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            //我的资料
            SettingViewController *set=[[SettingViewController alloc]init];
            UINavigationController *setNav=[[UINavigationController alloc]initWithRootViewController:set];
            [NavigationBar setNavigationBarStyle:setNav];
            [self.mm_drawerController setCenterViewController:setNav withCloseAnimation:YES completion:nil];
        }
            
            break;
        case 1:
        {
            //船舶情况
            ShipInfoViewController *shipInfo=[[ShipInfoViewController alloc]init];
            shipInfo.type=@"noPush";
            UINavigationController *shiNav=[[UINavigationController alloc]initWithRootViewController:shipInfo];
            [NavigationBar setNavigationBarStyle:shiNav];
            [self.mm_drawerController setCenterViewController:shiNav withCloseAnimation:YES completion:nil];

        }
            
            
            break;
        case 2:
        {
            //我的钱包
            MyWalletViewController *mywallet=[[MyWalletViewController alloc]init];
            UINavigationController *myWalletNav=[[UINavigationController alloc]initWithRootViewController:mywallet];
            [NavigationBar setNavigationBarStyle:myWalletNav];
            [self.mm_drawerController setCenterViewController:myWalletNav withCloseAnimation:YES completion:nil];
        }
            
           
            break;
        case 3:
        {
            //我的消息
            MessageViewController *message=[[MessageViewController alloc]init];
            UINavigationController *messageNav=[[UINavigationController alloc]initWithRootViewController:message];
            [NavigationBar setNavigationBarStyle:messageNav];
            [self.mm_drawerController setCenterViewController:messageNav withCloseAnimation:YES completion:nil];
            
//            //退出登录
//            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//            
//            [delegate.rootViewController showLoginViewController];
            
        }
            break;
            
        case 4:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您确认退出app吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
            
        }
        default:
            break;
    }

}
#pragma mark -----UIAlertViewDelegate-----
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        //退出登录
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
        [delegate.rootViewController showLoginViewController];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
