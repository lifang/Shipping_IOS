//
//  FindPwdViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/4.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "FindPwdViewController.h"
#import "Constants.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "RegularNumber.h"
#import "SetNewPWDViewController.h"
@interface FindPwdViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UITextField *_phoneNum;
    UIButton *_sendBtn;
    UITextField *_code;
    UIImageView *_statusImv;
}
@property(nonatomic,strong)NSString *codeNumber;
@end

@implementation FindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"找回密码";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(next:)];
    self.navigationItem.rightBarButtonItem=rightItem;

    [self initAndLayoutUI];
}
//验证验证码是否正确
-(IBAction)next:(id)sender
{
    if (![_phoneNum.text isEqualToString:@""] && ![_code.text isEqualToString:@""])
    {
        
        if ([_code.text isEqualToString:_codeNumber])
        {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.labelText=@"发送中...";
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            [NetWorkInterface testdentCodeWithloginName:_phoneNum.text dentCode:_codeNumber finished:^(BOOL success, NSData *response) {
                
                NSLog(@"------------验证码------:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
                if (success)
                {
                    id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                    if ([object isKindOfClass:[NSDictionary class]])
                    {
                        if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                        {
                            [hud setHidden:YES];
                            
                            [self parseLoginDataWithDictionary:object];
                            
                            
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
            hud.labelText=@"验证码不正确";
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
-(void)parseLoginDataWithDictionary:(NSDictionary*)dic
{
    SetNewPWDViewController *setNewPWD=[[SetNewPWDViewController alloc]init];
    setNewPWD.loginName=_phoneNum.text;
    setNewPWD.index=1;
    [self.navigationController pushViewController:setNewPWD animated:YES];
}
//倒计时
-(void)TimerStart
{
    __block int timeout = 120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI更新
                _sendBtn.userInteractionEnabled = YES;
                [_sendBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                _sendBtn.titleLabel.font=[UIFont systemFontOfSize:10];
                
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _sendBtn.userInteractionEnabled = NO;
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                _sendBtn.titleLabel.font=[UIFont systemFontOfSize:10];
                [_sendBtn setTitle:title forState:UIControlStateNormal];
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
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
    
    _phoneNum=[[UITextField alloc]init];
    _phoneNum.delegate=self;
    _phoneNum.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _phoneNum.tag=1;
    _phoneNum.placeholder=@"请输入手机号";
    _phoneNum.clearButtonMode=UITextFieldViewModeAlways;
    
    _sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"发送验证" forState:UIControlStateNormal];
    _sendBtn.titleLabel.font=[UIFont systemFontOfSize:10];
    [_sendBtn setBackgroundColor:kMainColor];
    _sendBtn.layer.cornerRadius=6;
    _sendBtn.layer.masksToBounds=YES;
    [_sendBtn addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    
    _statusImv=[[UIImageView alloc]init];
    //_statusImv.backgroundColor=[UIColor redColor];
    
    _code=[[UITextField alloc]init];
    _code.tag=2;
    _code.delegate=self;
    _code.placeholder=@"请输入验证码";
    _code.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _code.clearButtonMode=UITextFieldViewModeAlways;

}
//发送验证
-(IBAction)sendCode:(UIButton*)sender
{
    
    if (![RegularNumber isMobileNumber:_phoneNum.text])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入正确的手机号";
        return;
        
    }
    
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"正在获取...";
    [NetWorkInterface sendForPwdWithPhone:_phoneNum.text finished:^(BOOL success, NSData *response) {
        NSLog(@"------------找回密码验证码:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    _codeNumber=[object objectForKey:@"result"];
                    [self TimerStart];
                    
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
#pragma mark ----UITableView----
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
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text=@"手机号";
            _phoneNum.frame=CGRectMake(cell.bounds.size.width-150-80-20, 0, 150, cell.bounds.size.height);
            _sendBtn.frame=CGRectMake(cell.bounds.size.width-90, 0, 80, cell.bounds.size.height);
            [cell.contentView addSubview:_phoneNum];
            [cell.contentView addSubview:_sendBtn];
    
        }
            break;
        case 1:
        {
            cell.textLabel.text=@"输入验证码";
            _code.frame=CGRectMake(cell.bounds.size.width-130, 0, 120, cell.bounds.size.height);
            _statusImv.frame=CGRectMake(cell.bounds.size.width-20-140, (cell.bounds.size.height-20)/2, 20, 20);
            [cell.contentView addSubview:_statusImv];
            [cell.contentView addSubview:_code];
        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark ------UITextField--------
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField.tag==1)
//    {
//        if ([_code.text isEqualToString:@"123456"])
//        {
//            _statusImv.image=kImageName(@"rightg.png");
//        }else
//        {
//            _statusImv.image=kImageName(@"wrong.png");
//        }
//    }
    if (textField.tag==2)
    {
        if ([textField.text isEqualToString:_codeNumber])
        {
            _statusImv.image=kImageName(@"right.png");
        }else
        {
            _statusImv.image=kImageName(@"wrong.png");
        }
        
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
        if (textField.tag==2)
    {
        NSString *code=[NSString stringWithFormat:@"%@%@",textField.text,string];
        if ([code isEqualToString:_codeNumber])
        {
            _statusImv.image=kImageName(@"right.png");
            
        }else
        {
            _statusImv.image=kImageName(@"wrong.png");
        }
       
    }

    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag==2)
    {
        _statusImv.image=kImageName(@"");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
