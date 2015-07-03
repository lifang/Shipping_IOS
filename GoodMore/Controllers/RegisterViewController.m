//
//  RegisterViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/5/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "RegisterViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "NetWorkInterface.h"
#import "LoginViewController.h"
#import "RegularNumber.h"
#import "RegresultViewController.h"

#import "LoadGoodsViewController.h"

@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    UITextField *_name;
    UITextField *_shipName;
    UITextField *_volume;
    UITextField *_phoneNum;
    UITextField *_dentcode;
    UITextField *_pwd;
    UITextField *_sure;
    UITextField *_year;
    UITextField *_inviteNum;
    UIButton *_codeBtn;
    UIButton *_upload;
}
@property(nonatomic,strong)NSString *codeNumber;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commit:)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    _dataArray=[[NSArray alloc]initWithObjects:@"姓名",@"船名",@"船舶吨位",@"建造年份",@"邀请码",@"手机号码",@"验证码",@"密码",@"确认密码",@"签证薄概况页照片", nil];
    
    [self initAndLayoutUI];
    
}

-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=40;
    [self setHeadAndFootView];
    [self.view addSubview:_tableView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    _name=[[UITextField alloc]init];
    _name.placeholder=@"请输入姓名";
    _name.font=[UIFont systemFontOfSize:14];
    _name.delegate=self;
    _name.tag=1;
    _name.clearButtonMode=UITextFieldViewModeAlways;
    
    _shipName=[[UITextField alloc]init];
    _shipName.placeholder=@"请输入船名";
    _shipName.font=[UIFont systemFontOfSize:14];
    _shipName.delegate=self;
    _shipName.tag=2;
    _shipName.clearButtonMode=UITextFieldViewModeAlways;
    
    _volume=[[UITextField alloc]init];
    _volume.placeholder=@"请输入船舶吨位";
    _volume.font=[UIFont systemFontOfSize:14];
    _volume.delegate=self;
    _volume.tag=3;
    _volume.clearButtonMode=UITextFieldViewModeAlways;

    _year=[[UITextField alloc]init];
    _year.placeholder=@"请输入建造年份";
    _year.font=[UIFont systemFontOfSize:14];
    _year.delegate=self;
    _year.tag=4;
    _year.clearButtonMode=UITextFieldViewModeAlways;
    
    _inviteNum=[[UITextField alloc]init];
    _inviteNum.placeholder=@"请输入邀请码";
    _inviteNum.font=[UIFont systemFontOfSize:14];
    _inviteNum.delegate=self;
    _inviteNum.tag=5;
    _inviteNum.clearButtonMode=UITextFieldViewModeAlways;
    
    _phoneNum=[[UITextField alloc]init];
    _phoneNum.placeholder=@"请输入手机号码";
    _phoneNum.font=[UIFont systemFontOfSize:14];
    _phoneNum.delegate=self;
    _phoneNum.tag=6;
    _phoneNum.clearButtonMode=UITextFieldViewModeAlways;
    
    _codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_codeBtn setBackgroundColor:kMainColor];
    [_codeBtn setTitle:@"获得验证码" forState:UIControlStateNormal];
    _codeBtn.titleLabel.font=[UIFont systemFontOfSize:10];
    [_codeBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    
    _dentcode=[[UITextField alloc]init];
    _dentcode.placeholder=@"请输入验证码";
    _dentcode.font=[UIFont systemFontOfSize:14];
    _dentcode.delegate=self;
    _dentcode.tag=7;
    _dentcode.clearButtonMode=UITextFieldViewModeAlways;
    
    _pwd=[[UITextField alloc]init];
    _pwd.placeholder=@"请输入密码";
    _pwd.font=[UIFont systemFontOfSize:14];
    _pwd.secureTextEntry=YES;
    _pwd.delegate=self;
    _pwd.tag=8;
    _pwd.clearButtonMode=UITextFieldViewModeAlways;
    
    _sure=[[UITextField alloc]init];
    _sure.placeholder=@"请再次输入密码";
    _sure.font=[UIFont systemFontOfSize:14];
    _sure.secureTextEntry=YES;
    _sure.delegate=self;
    _sure.tag=9;
    _sure.clearButtonMode=UITextFieldViewModeAlways;
    
    _upload=[UIButton buttonWithType:UIButtonTypeCustom];
    [_upload setTitle:@"上传图片" forState:UIControlStateNormal];
    [_upload setBackgroundColor:kMainColor];
    _upload.titleLabel.font=[UIFont systemFontOfSize:10];
    [_upload addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setHeadAndFootView
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor=[UIColor whiteColor];
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 9.5, kScreenWidth, 0.5)];
    line1.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line1];
    _tableView.tableHeaderView=headView;
    
    UIView *footView=[[UIView alloc]init];
    footView.backgroundColor=[UIColor whiteColor];
    _tableView.tableFooterView=footView;
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
                _codeBtn.userInteractionEnabled = YES;
                [_codeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                _codeBtn.titleLabel.font=[UIFont systemFontOfSize:10];
                
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _codeBtn.userInteractionEnabled = NO;
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                _codeBtn.titleLabel.font=[UIFont systemFontOfSize:10];
            
                [_codeBtn setTitle:title forState:UIControlStateNormal];
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
#pragma mark  上传图片
- (void)showImageOption
{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@""
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"相册上传",@"拍照上传",nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    if (buttonIndex==0)
    {
        //相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (buttonIndex==1)
    {
        //拍照
         sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] &&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }

}
#pragma mark action


//获得验证码
-(IBAction)getCode:(UIButton*)sender
{
    [_phoneNum resignFirstResponder];
    
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
    [NetWorkInterface sendCodeWith:_phoneNum.text finished:^(BOOL success, NSData *response) {
        NSLog(@"------------注册验证码:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
//提交注册
-(IBAction)commit:(UIButton*)sender
{

    if (!_name.text || [_name.text isEqualToString:@""] ||  !_shipName.text || [_shipName.text isEqualToString:@""] || !_volume.text || [_volume.text isEqualToString:@""] || !_year.text || [_year.text isEqualToString:@""] || !_inviteNum.text || [_inviteNum.text isEqualToString:@""] || !_phoneNum.text || [_phoneNum.text isEqualToString:@""] || !_dentcode.text || [_dentcode.text isEqualToString:@""] || !_pwd.text || [_pwd.text isEqualToString:@""] || !_sure.text || [_sure.text isEqualToString:@""] )
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"所有输入不能为空";
    }else if (![_dentcode.text isEqualToString:_codeNumber])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"验证码不正确";

    }else if (![_pwd.text isEqualToString:_sure.text])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"密码不一致";
    }else
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"正在提交";
        
        [NetWorkInterface registerWithLoginName:_phoneNum.text pwd:_pwd.text name:_name.text shipNumber:_shipName.text phone:_phoneNum.text volume:_volume.text dentCode:_dentcode.text builderTime:_year.text imgList:_imgList joinCode:_inviteNum.text shipName:_shipName.text finished:^(BOOL success, NSData *response) {
            
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:0.5f];
            NSLog(@"------------注册:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if (success)
            {
                id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                    {
                        [hud setHidden:YES];
                        RegresultViewController *regResult=[[RegresultViewController alloc]init];
                        [self.navigationController pushViewController:regResult animated:YES];
                        
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
}
#pragma mark ---UITableViewDelegate------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UIView *backView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView=backView;
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    [cell setBackgroundView:[[UIView alloc] init]];          //取消边框线
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text=_dataArray[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14.0];
    switch (indexPath.row)
    {
        case 0:
        {
            _name.frame=CGRectMake(80, 5, 150, 30);
            [cell.contentView addSubview:_name];
        }
            break;
        case 1:
        {
            _shipName.frame=CGRectMake(80, 5, 150, 30);
            [cell.contentView addSubview:_shipName];
        }
            break;
        case 2:
        {
            _volume.frame=CGRectMake(80, 5, 150, 30);
            [cell.contentView addSubview:_volume];
        }
            break;
        case 3:
        {
            _year.frame=CGRectMake(80, 5, 150, 30);
            [cell.contentView addSubview:_year];
        }
            break;
        case 4:
        {
            _inviteNum.frame=CGRectMake(80, 5, 150, 30);
            [cell.contentView addSubview:_inviteNum];
        }
            break;
        case 5:
        {
            _phoneNum.frame=CGRectMake(80, 5, 150, 30);
            _codeBtn.frame=CGRectMake(230, 5, 80, 30);
            [cell.contentView addSubview:_codeBtn];
            [cell.contentView addSubview:_phoneNum];
        }
            break;
        case 6:
        {
            _dentcode.frame=CGRectMake(80, 5, 150, 30);
            
            [cell.contentView addSubview:_dentcode];
        }
            break;
        case 7:
        {
            _pwd.frame=CGRectMake(80, 5, 150, 30);
            [cell.contentView addSubview:_pwd];
        }
            break;
        case 8:
        {
            _sure.frame=CGRectMake(80, 5, 150, 30);
            [cell.contentView addSubview:_sure];

        }
            break;
        case 9:
        {
            _upload.frame=CGRectMake(230, 5, 80, 30);
            [cell.contentView addSubview:_upload];
            
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark 上传图片
-(void)upload:(UIButton*)sender
{
    [self showImageOption];
}
- (void)uploadPictureWithImage:(UIImage *)image
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"上传中...";
    
    [NetWorkInterface uploadSingleImageWithImage:image loginId:@"-1" finished:^(BOOL success, NSData *response) {
        NSLog(@"上传一张图片---%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
            if ([errorCode intValue] == RequestFail) {
                //返回错误代码
                hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
            }
            else if ([errorCode intValue] == RequestSuccess) {
                hud.labelText = @"上传成功";
                [self parseImageUploadInfo:object];
            }
        }
        else {
            //返回错误数据
            hud.labelText = kServiceReturnWrong;
        }
    }
     else {
         hud.labelText = kNetworkFailed;
     }

    }];
}
-(void)parseImageUploadInfo:(NSDictionary*)dic
{
    if (![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"] isKindOfClass:[NSString class]]) {
        return;
    }
    NSDictionary *result=[dic objectForKey:@"result"];
    _imgList=[[result objectForKey:@"id"] intValue];
    _imvURL=[result objectForKey:@"url"];
}
#pragma mark --UIImagePickerDelegate--
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //调接口上传图片
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];

}

#pragma mark ----------------UITextFieldDelegate-------------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==6 || textField.tag==7 || textField.tag==8 || textField.tag==9) {
        _tableView.center=CGPointMake(_tableView.center.x, _tableView.center.y-100);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==6 || textField.tag==7 || textField.tag==8 || textField.tag==9) {
        _tableView.center=CGPointMake(_tableView.center.x, _tableView.center.y+100);
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==3)
    {
        if (![RegularNumber isNumber:string])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请输入数字";
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
