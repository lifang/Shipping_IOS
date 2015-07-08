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
#import "MMDrawerController.h"
#import "RightViewController.h"

@interface RootViewController : UIViewController

@property(nonatomic,strong)UINavigationController *loginNav;

@property(nonatomic,strong)UINavigationController *registNav;

@property(nonatomic,strong)MMDrawerController *menuController;

@property(nonatomic,strong)LoginViewController *loginViewController;

@property(nonatomic,strong)RegisterViewController *registerViewController;

@property (nonatomic, strong) MainViewController *mainController;

@property (nonatomic, strong) RightViewController *messageController;

-(void)showLoginViewController;

- (void)showMainViewController;

@end

