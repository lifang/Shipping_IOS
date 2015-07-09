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
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"

@interface RootViewController ()
{
    NSString *_down_url;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    
    [self checkAppVersion];
    
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
    if (_menuController) {
        [_menuController.view removeFromSuperview];
        [_menuController removeFromParentViewController];
        _menuController = nil;
    }

}
//检测版本更新
-(void)checkAppVersion
{
    
    [NetWorkInterface checkVersionFinished:^(BOOL success, NSData *response) {
        
        NSLog(@"------------检测版本:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess)
                {
                    NSDictionary *result=[object objectForKey:@"result"];
                    int versions=[[result objectForKey:@"versions"]intValue];
                    _down_url=[result objectForKey:@"down_url"];
                    NSString *localVersion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                    if (versions == [localVersion intValue])
                    {
                       
                    }else
                    {
                        UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"您需要更新版本" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [aler show];
                    }
                }
            }else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message: kServiceReturnWrong delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
            }
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message: kNetworkFailed delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            
        }
        
    }];
}
#pragma mark-----------------UIAlertViewDelegate------------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_down_url]];
    }
}

- (void)showMainViewController {
    if (!_menuController) {
        _mainController = [[MainViewController alloc] init];
        _messageController = [[RightViewController alloc] init];
        UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:_mainController];
        [NavigationBar setNavigationBarStyle:mainNav];
        _menuController= [[MMDrawerController alloc] initWithCenterViewController:_mainController
                                                         leftDrawerViewController:nil
                                                        rightDrawerViewController:_messageController];
        [_menuController setMaximumRightDrawerWidth:kScreenWidth/2];
        [_menuController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [_menuController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeTapCenterView | MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModeTapNavigationBar];
        [_menuController setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNone];
        _menuController.view.frame = self.view.bounds;
        [self.view addSubview:_menuController.view];
        [self addChildViewController:_menuController];
    }
    if (_loginNav) {
        [_loginNav.view removeFromSuperview];
        [_loginNav removeFromParentViewController];
        _loginNav = nil;
    }
    [self.view bringSubviewToFront:_mainController.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
