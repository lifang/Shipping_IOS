//
//  SetNewPWDViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/3.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "SetNewPWDViewController.h"
#import "Constants.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
@interface SetNewPWDViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UITextField *_newpwd;
    UITextField *_surePwd;
    UITextField *_oldpwd;
}
@end

@implementation SetNewPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设置新密码";
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commit:)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    [self initAndLayoutUI];
}
//提交
-(IBAction)commit:(id)sender
{
    
    if (![_newpwd.text isEqualToString:@""] && ![_surePwd.text isEqualToString:@""])
    {
        if ([_newpwd.text isEqualToString:_surePwd.text])
        {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText=@"提交中...";
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            
            NSString *oldPwd=nil;
            switch (_index) {
                case 1:
                    oldPwd=@"";
                    break;
                case 2:
                    oldPwd=_oldpwd.text;
                    _loginName=[[NSUserDefaults standardUserDefaults]objectForKey:@"loginName"];
                    break;
                default:
                    break;
            }
            [NetWorkInterface setNewPwdWithloginName:_loginName oldPwd:oldPwd pwd:_newpwd.text finished:^(BOOL success, NSData *response) {
                
                NSLog(@"------------新设密码------:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
                
                
                
                if (success)
                {
                    id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                    if ([object isKindOfClass:[NSDictionary class]])
                    {
                        if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                        {
                             hud.customView=[[UIImageView alloc]init];
                             hud.mode=MBProgressHUDModeCustomView;
                             hud.labelText=@"设置新密码成功";
                             [hud hide:YES afterDelay:1.0];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
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

        }else
        {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView=[[UIImageView alloc]init];
            hud.mode=MBProgressHUDModeCustomView;
            hud.labelText=@"密码不一致";
            [hud hide:YES afterDelay:1.0];
        }
        
        
    }else
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView=[[UIImageView alloc]init];
        hud.mode=MBProgressHUDModeCustomView;
        hud.labelText=@"输入不能为空";
        [hud hide:YES afterDelay:1.0];
    }
}

-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.scrollEnabled=NO;
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    [self setHeadAndFootView];
    [self.view addSubview:_tableView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    _oldpwd=[[UITextField alloc]init];
    _oldpwd.delegate=self;
    _oldpwd.secureTextEntry=YES;
    _oldpwd.placeholder=@"请输入旧密码";
    _oldpwd.clearButtonMode=UITextFieldViewModeAlways;
    

    
    _newpwd=[[UITextField alloc]init];
    _newpwd.delegate=self;
    _newpwd.secureTextEntry=YES;
    _newpwd.placeholder=@"请输入新密码";
    _newpwd.clearButtonMode=UITextFieldViewModeAlways;
   
    
    _surePwd=[[UITextField alloc]init];
    _surePwd.delegate=self;
    _surePwd.secureTextEntry=YES;
    _surePwd.placeholder=@"请再次输入密码";
    _surePwd.clearButtonMode=UITextFieldViewModeAlways;
    


}
-(void)setHeadAndFootView
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor=[UIColor clearColor];
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 9.5, kScreenWidth, 0.5)];
    line1.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line1];
    _tableView.tableHeaderView=headView;
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    footView.backgroundColor=[UIColor clearColor];
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line2.backgroundColor=kColor(201, 201, 201, 1);
    [footView addSubview:line2];
    _tableView.tableFooterView=footView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (_index==1)
    {
         return 2;
    }else if (_index==2)
    {
        return 3;
    }else
    {
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    CGFloat width=2*cell.bounds.size.width/3;
    CGFloat height=cell.bounds.size.height;
    if (_index==1)
    {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text=@"新密码";
                _newpwd.frame=CGRectMake(cell.bounds.size.width-width-10, 0, width,height);
                [cell.contentView addSubview:_newpwd];
            }
                break;
            case 1:
            {
                cell.textLabel.text=@"确认密码";
                _surePwd.frame=CGRectMake(cell.bounds.size.width-width-10, 0, width, height);
                [cell.contentView addSubview:_surePwd];
            }
                break;
                
                
            default:
                break;
        }

    }
    if (_index==2)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text=@"旧密码";
                _oldpwd.frame=CGRectMake(cell.bounds.size.width-width-10, 0, width,height);
                [cell.contentView addSubview:_oldpwd];
            }
                break;
            case 1:
            {
                cell.textLabel.text=@"新密码";
                _newpwd.frame=CGRectMake(cell.bounds.size.width-width-10, 0, width,height);
                [cell.contentView addSubview:_newpwd];
            }
                break;
            case 2:
            {
                cell.textLabel.text=@"确认密码";
                _surePwd.frame=CGRectMake(cell.bounds.size.width-width-10, 0, width, height);
                [cell.contentView addSubview:_surePwd];
            }
                break;
                
            default:
                break;
        }
    }
    
        return cell;
}
#pragma mark -----UITextField-----
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
