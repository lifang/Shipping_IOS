//
//  LoginViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/5/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "NetWorkInterface.h"
#import "MainViewController.h"
#import "FindPwdViewController.h"
@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

{
    UITableView *_tableView;
    UITextField *_loginName;
    UITextField *_pwd;
    UIView *_footView;
    NSTimer *_timer;
}
@property(nonatomic,strong)NSString *loginId;
@property(nonatomic,strong)NSString *shipOwerId;
@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_timer invalidate];
    _timer=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"登录";
    
    [self initAndLayoutUI];
}


-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.scrollEnabled=NO;
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    [self setheadAndFootView];
    [self.view addSubview:_tableView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
//    _phoneNum=[[UITextField alloc]init];
//    _phoneNum.clearButtonMode=UITextFieldViewModeAlways;
//    _phoneNum.delegate=self;
//    _phoneNum.tag=110;
//    _pwd=[[UITextField alloc]init];
//    _pwd.clearButtonMode=UITextFieldViewModeAlways;
//    _pwd.delegate=self;
//    _pwd.tag=111;
    
    NSUserDefaults *usersDefault=[NSUserDefaults standardUserDefaults];
    NSString *loginName=[usersDefault objectForKey:@"loginName"];
    
    _loginName=[[UITextField alloc]init];
    _loginName.text=loginName;
    _loginName.clearButtonMode=UITextFieldViewModeAlways;
    _loginName.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _loginName.placeholder=@"请输入登录帐号";
    _loginName.delegate=self;
    _loginName.tag=110;
    
    
    _pwd=[[UITextField alloc]init];
    _pwd.placeholder=@"请输入密码";
    _pwd.secureTextEntry=YES;
    _pwd.clearButtonMode=UITextFieldViewModeAlways;
    _pwd.delegate=self;
    _pwd.tag=111;
   
}

-(void)setheadAndFootView
{
    CGFloat space=40;
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor=[UIColor clearColor];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 9.5, kScreenWidth, 0.5)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line];
    _tableView.tableHeaderView=headView;
    
    _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line2.backgroundColor=kColor(201, 201, 201, 1);
    [_footView addSubview:line2];
    
    _footView.backgroundColor=[UIColor clearColor];
    UIButton *loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.frame=CGRectMake(60, space, kScreenWidth-120, 40);
    loginButton.layer.masksToBounds=YES;
    loginButton.layer.cornerRadius=4;
    loginButton.backgroundColor=kMainColor;
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:loginButton];
    
    
    UIButton *findPwd=[UIButton buttonWithType:UIButtonTypeCustom];
    //findPwd.backgroundColor=[UIColor orangeColor];
    [findPwd setTitle:@"找回密码" forState:UIControlStateNormal];
    CGFloat width1 = [self getLengthWithString:findPwd.titleLabel.text withFont:findPwd.titleLabel.font];
    findPwd.frame=CGRectMake(10, CGRectGetMaxY(loginButton.frame)+space, width1, 30);
    findPwd.titleLabel.font=[UIFont systemFontOfSize:16];
    [findPwd setTitleColor:kMainColor forState:UIControlStateNormal];
    [findPwd addTarget:self action:@selector(findPwd:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:findPwd];
    [self setLineWithButton:findPwd];
    
    UIButton *registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //registerButton.backgroundColor=[UIColor orangeColor];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    CGFloat width2 = [self getLengthWithString:registerButton.titleLabel.text withFont:registerButton.titleLabel.font];
    registerButton.frame=CGRectMake(kScreenWidth-width2-10, CGRectGetMaxY(loginButton.frame)+space, width2, 30);
    
    registerButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [registerButton addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_footView addSubview:registerButton];
    [self setLineWithButton:registerButton];
    
    _tableView.tableFooterView=_footView;
    
}
//长度
-(CGFloat)getLengthWithString:(NSString*)str withFont:(UIFont*)font
{
    CGSize size=[str sizeWithAttributes:@{NSFontAttributeName: font}];
    return size.width;
}
//线
-(void)setLineWithButton:(UIButton*)btn
{
    CGFloat width=[self getLengthWithString:btn.titleLabel.text withFont:btn.titleLabel.font];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0,0, width, 1)];
    line.center=CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame)-5);
    line.backgroundColor=kMainColor;
    [_footView addSubview:line];

}
//找回密码
-(IBAction)findPwd:(UIButton*)sender
{
    FindPwdViewController *find=[[FindPwdViewController alloc]init];
    [self.navigationController pushViewController:find animated:YES];
}
//注册
-(IBAction)registerBtn:(UIButton*)sender
{
    RegisterViewController *regVC=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
}
//登录
-(IBAction)login:(UIButton*)sender
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"正在登录";
    [NetWorkInterface loginWithLoginName:_loginName.text pwd:_pwd.text finished:^(BOOL success, NSData *response)
    {
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------登录:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    
                    [self parseLoginDataWithDictionary:object];
                    MainViewController *main=[[MainViewController alloc]init];
                    [self presentViewController:main animated:YES completion:nil];

                }else
                {
                    
                    hud.labelText=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
            }else
            {
                
                hud.labelText=kServiceReturnWrong;
            }
        }else
        {
            hud.labelText=kNetworkFailed;
        }
        
    }];
}

-(void)parseLoginDataWithDictionary:(NSDictionary*)dictionary
{
    if (![dictionary objectForKey:@"result"] || ![[dictionary objectForKey:@"result"] isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSDictionary *result=[dictionary objectForKey:@"result"];
    _loginId=[NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
    _shipOwerId=[result objectForKey:@"shipOwnerId"];
    NSString *name=[result objectForKey:@"name"];
    NSString *shipNumber=[result objectForKey:@"shipNumber"];
    NSString *phone=[result objectForKey:@"phone"];
    NSString *loginName=[result objectForKey:@"loginName"];
    NSLog(@"-------登录loginName---%@",loginName);
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:_loginId forKey:@"loginId"];
    [userDefault setObject:_shipOwerId forKey:@"shipOwerId"];
    [userDefault setObject:name forKey:@"name"];
    [userDefault setObject:shipNumber forKey:@"shipNumber"];
    [userDefault setObject:phone forKey:@"phone"];
    [userDefault setObject:loginName forKey:@"loginName"];
    [userDefault synchronize];
    
    //保存坐标
    [self recordCoordinate];
    
   _timer = [NSTimer scheduledTimerWithTimeInterval:15*60 target:self selector:@selector(recordCoordinate) userInfo:nil repeats:YES];
    
}

-(void)recordCoordinate
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    double latitude=[[user objectForKey:@"latitude"] doubleValue];
    double longitude=[[user objectForKey:@"longitude"] doubleValue];
    
    NSString *coordinate=[NSString stringWithFormat:@"%.4f,%.4f",longitude,latitude];
    [NetWorkInterface recordCoordinateWithshipOwerId:[_shipOwerId intValue] loginId:[_loginId intValue] coordinate:coordinate finished:^(BOOL success, NSData *response) {
        NSLog(@"----------------------保存船坐标:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    }];
}
#pragma mark ---------------UITableVIewDelegate-----------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UIView *backView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView=backView;
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    if (indexPath.row==0)
    {
        cell.textLabel.text=@"登录号";
        _loginName.frame=CGRectMake(100, 5, 180, 50);

        [cell.contentView addSubview:_loginName];
       
    }else if (indexPath.row==1)
    {
        cell.textLabel.text=@"输入密码";
        _pwd.frame=CGRectMake(100, 5, 180, 50);

        [cell.contentView addSubview:_pwd];
    }
    
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -------------------UITextFieldDelegate-------------------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
