//
//  ViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/5/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
@interface RootViewController : UIViewController

@property(nonatomic,strong)UINavigationController *loginNav;

@property(nonatomic,strong)UINavigationController *registNav;

//@property(nonatomic,strong)MainViewController *mainViewController;

@property(nonatomic,strong)LoginViewController *loginViewController;

@property(nonatomic,strong)RegisterViewController *registerViewController;

-(void)showLoginViewController;

//-(void)showMainViewController;

@end

