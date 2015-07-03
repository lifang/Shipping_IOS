//
//  SettingViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/3.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "SettingViewController.h"
#import "Constants.h"
#import "SetNewPWDViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "NetWorkInterface.h"
#import "WebViewViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_staticData;
    UIImageView *_icon;
    UIImageView *_icon1;
    UIButton *_promote;
    UIView *_backView;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我的信息";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithImage:kImageName(@"setting.png") style:UIBarButtonItemStyleDone target:self action:@selector(signOut:)];
    self.navigationItem.rightBarButtonItem=rightItem;
    [self initStaticData];
    [self initAndLayoutUI];
    [self initBackView];
    _backView.hidden=YES;
}
-(void)initStaticData
{
    _staticData=[[NSArray alloc]initWithObjects:@"姓名",@"船名",@"电话",@"修改密码", @"签证薄概况页照片",nil];
}
#pragma mark action
-(IBAction)signOut:(id)sender
{
    LoginViewController *loginVC=[[LoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed=YES;
    self.navigationController.viewControllers=@[loginVC];
    
}
//升级
-(void)promote:(UIButton*)sender
{
    _backView.hidden=NO;
}
//保存
-(void)save:(UIButton*)sender
{
    
}
-(void)cancelBTN:(UIButton*)btn
{
    _backView.hidden=YES;
}
//缴纳保证金
-(void)sureBTN:(UIButton*)btn
{
    [self upShip];
    _backView.hidden=YES;
}
#pragma mark 初始化UI
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    [self setHeadAndFootView];
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
     [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
      _icon1=[[UIImageView alloc]init];
      _icon1.image=kImageName(@"upload.png");
    
    _promote=[UIButton buttonWithType:UIButtonTypeCustom];
    [_promote setTitle:@"点击升级" forState:UIControlStateNormal];
    [_promote setTitleColor:kMainColor forState:UIControlStateNormal];
    [_promote addTarget:self action:@selector(promote:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)initBackView
{
    CGFloat width=kScreenWidth;
    CGFloat height=kScreenHeight;
    CGFloat leftSpace=20;
    CGFloat rightSpace=20;
    CGFloat topSpace=40;
    CGFloat bottomSpace=10;
    //CGFloat vSpace=5;
    
    _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _backView.backgroundColor=[UIColor colorWithRed:95/255.0 green:114/255.0 blue:114/255.0 alpha:0.5];
    [self.view addSubview:_backView];
    
    UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake((width-width*0.8)/2, 100, width*0.8, height*0.3)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [_backView addSubview:whiteView];
    
    UILabel *title=[[UILabel alloc]init];
    title.numberOfLines=0;
    title.font=[UIFont systemFontOfSize:16];
    title.text=@"高级船可以组队接单,缴纳5000元保障金升级为高级船!";
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=[UIColor blackColor];
    title.frame=CGRectMake(leftSpace, topSpace, whiteView.bounds.size.width-leftSpace*2, 60);
    [whiteView addSubview:title];
    
    UIButton *cancelBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBTN.frame=CGRectMake(2*leftSpace, height*0.3-bottomSpace-30, 80, 30);
    [cancelBTN setTitle:@"取消" forState:UIControlStateNormal];
    cancelBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [cancelBTN setTitleColor:[self colorWithHexString:@"757474"] forState:UIControlStateNormal];
    [cancelBTN addTarget:self action:@selector(cancelBTN:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelBTN];
    
    UIButton *sureBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBTN.frame=CGRectMake(width*0.8-rightSpace-80-rightSpace, height*0.3-bottomSpace-30,80, 30);
    sureBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [sureBTN setTitle:@"缴纳保证金" forState:UIControlStateNormal];
    [sureBTN setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sureBTN addTarget:self action:@selector(sureBTN:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:sureBTN];
}

-(void)setHeadAndFootView
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor=[UIColor clearColor];
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 9.5, kScreenWidth, 0.5)];
    line1.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line1];
    _tableView.tableHeaderView=headView;
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    footView.backgroundColor=[UIColor clearColor];
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line2.backgroundColor=kColor(201, 201, 201, 1);
    [footView addSubview:line2];
    UIButton *save=[UIButton buttonWithType:UIButtonTypeCustom];
    save.frame=CGRectMake(50, 40, kScreenWidth-100, 40);
    save.layer.cornerRadius=4;
    save.layer.masksToBounds=YES;
    [save setBackgroundColor:kMainColor];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:save];
    _tableView.tableFooterView=footView;
}
-(UIColor *)colorWithHexString:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}
//升级为高级船
-(void)upShip
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"请耐心等待";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefaults objectForKey:@"loginId"] intValue];
    int shipOwnerId=[[userDefaults objectForKey:@"shipOwnerId"] intValue];
    
    [NetWorkInterface upShipWithshipId:shipOwnerId loginId:loginId finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------升级为高级船----:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    
                    NSString *urlString=[object objectForKey:@"result"];
                    WebViewViewController *webView=[[WebViewViewController alloc]init];
                    webView.hidesBottomBarWhenPushed=YES;
                    webView.urlString=urlString;
                    [self.navigationController pushViewController:webView animated:YES];
                    
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


#pragma mark ---------UITableView--------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *type=[userDefault objectForKey:@"type"];
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UIView *backView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView=backView;
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    if (indexPath.row>4)
    {
        
        if ([type intValue]==1)
        {
            //高级船
            cell.textLabel.text=@"船舶级别:高级船";
        }else if ([type intValue]==6)
        {
            //普通船
            cell.textLabel.text=@"船舶级别:普通船";
        }

        
        
    }else
    {
        cell.textLabel.text=_staticData[indexPath.row];
    }
    
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    switch (indexPath.row)
    {
        case 0:
        {
            cell.detailTextLabel.text=[userDefaults objectForKey:@"name"];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
        }
            break;
        case 1:
        {
             cell.detailTextLabel.text=[userDefaults objectForKey:@"shipName"];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
        }
            break;
        case 2:
        {
            cell.detailTextLabel.text=[userDefaults objectForKey:@"phone"];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
        }
            break;
        case 3:
        {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 4:
        {
            _icon1.frame=CGRectMake(cell.bounds.size.width-30, (cell.bounds.size.height-20)/2, 20, 20);
            [cell.contentView addSubview:_icon1];
        }
            break;
        case 5:
        {
            if ([type intValue]==1)
            {
                //高级船
                _promote.hidden=YES;
            }else if ([type intValue]==6)
            {
                //普通船
                _promote.frame=CGRectMake(cell.bounds.size.width-90, (cell.bounds.size.height-20)/2, 80, 20);
                _promote.titleLabel.font=[UIFont systemFontOfSize:14];
                [cell.contentView addSubview:_promote];            }

            
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
    if (indexPath.row==3)
    {
        SetNewPWDViewController*setN=[[SetNewPWDViewController alloc]init];
        setN.index=2;
        [self.navigationController pushViewController:setN animated:YES];
    }
    if (indexPath.row==4)
    {
        //签证薄照片
        [self showImageOption];
    }
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

-(void)showImageOption
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@""
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
#pragma mark --UIImagePickerDelegate--
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"---------图片信息:%@",info);
    //调接口上传图片
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
    
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
//    NSDictionary *result=[dic objectForKey:@"result"];
//    _imgList=[[result objectForKey:@"id"] intValue];
//    _imvURL=[result objectForKey:@"url"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
