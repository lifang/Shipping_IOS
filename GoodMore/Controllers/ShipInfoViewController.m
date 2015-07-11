//
//  ShipInfoViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipInfoViewController.h"
#import "NetWorkInterface.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"

@interface ShipInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_staticData;
    UITextField *_shipNameText;
    
    UITextField *_shipVolumeText;
    
    UITextField *_shipYearText;
    
    UITextField *_shipNumberText;
   
    UITextField *_shipLengthText;
   
    UITextField *_shipWaterEatText;
    
}
@end

@implementation ShipInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.title=@"船舶情况";
    
    NSLog(@"----type---:%@",_type);
    if ([_type isEqualToString:@"isPush"])
    {
        
    }else if ([_type isEqualToString:@"noPush"])
    {
        
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem=leftItem;
    }
    
   
   

    _staticData=[[NSArray alloc]initWithObjects:@"船名",@"载重",@"建成年份",@"船舶号",@"船舶长度",@"吃水", nil];
    
    [self initUI];
}
-(void)initUI
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
    
    _shipNameText=[[UITextField alloc]init];
    
    _shipNameText.textAlignment=NSTextAlignmentRight;
    _shipNameText.font=[UIFont systemFontOfSize:14];
    _shipNameText.clearButtonMode=UITextFieldViewModeWhileEditing;
    
   
    
    _shipVolumeText=[[UITextField alloc]init];
   
    _shipVolumeText.textAlignment=NSTextAlignmentRight;
    _shipVolumeText.font=[UIFont systemFontOfSize:14];
    _shipVolumeText.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    
    _shipYearText=[[UITextField alloc]init];
    
    _shipYearText.textAlignment=NSTextAlignmentRight;
    _shipYearText.font=[UIFont systemFontOfSize:14];
    _shipYearText.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    
    _shipNumberText=[[UITextField alloc]init];
    
    _shipNumberText.textAlignment=NSTextAlignmentRight;
    _shipNumberText.font=[UIFont systemFontOfSize:14];
    _shipNumberText.clearButtonMode=UITextFieldViewModeWhileEditing;
    
   
    
    _shipLengthText=[[UITextField alloc]init];
    
    _shipLengthText.textAlignment=NSTextAlignmentRight;
    _shipLengthText.font=[UIFont systemFontOfSize:14];
    _shipLengthText.clearButtonMode=UITextFieldViewModeWhileEditing;
    
   
    
    _shipWaterEatText=[[UITextField alloc]init];
    
    _shipWaterEatText.textAlignment=NSTextAlignmentRight;
    _shipWaterEatText.font=[UIFont systemFontOfSize:14];
    _shipWaterEatText.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    
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
#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _staticData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UIView *backView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView=backView;
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    
    cell.textLabel.text=_staticData[indexPath.row];
    
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipName=[userDefaults objectForKey:@"shipName"];
    NSString *volume=[userDefaults objectForKey:@"volume"];
    NSString *shipNumber=[userDefaults objectForKey:@"shipNumber"];
    NSString *length=[userDefaults objectForKey:@"length"];
    NSString *waterEat=[userDefaults objectForKey:@"waterEat"];
    NSString *builderTime=[userDefaults objectForKey:@"builderTime"];
    NSLog(@"------volume:%@",volume);
    switch (indexPath.row)
    {
        case 0:
        {
            _shipNameText.frame=CGRectMake(cell.bounds.size.width-160-30, (cell.bounds.size.height-30)/2, 160, 30);
            [cell.contentView addSubview:_shipNameText];
            
            if (shipName && ![shipName isEqualToString:@""])
            {
                //存在信息
                _shipNameText.text=shipName;
                
                
            }else
            {
                _shipNameText.placeholder=@"请输入船名";
            }
        }
            break;
        case 1:
        {
            
            _shipVolumeText.frame=CGRectMake(cell.bounds.size.width-160-30, (cell.bounds.size.height-30)/2, 160, 30);
            [cell.contentView addSubview:_shipVolumeText];
            if (volume && ![volume doubleValue]==0)
            {
                //存在信息
                _shipVolumeText.text=[NSString stringWithFormat:@"%@",volume];
                
                
            }else
            {
                 _shipVolumeText.placeholder=@"请输入船吨位";
            }

        }
            break;
        case 2:
        {
            _shipYearText.frame=CGRectMake(cell.bounds.size.width-160-30, (cell.bounds.size.height-30)/2, 160, 30);
            [cell.contentView addSubview:_shipYearText];
            if (builderTime && ![builderTime isEqualToString:@""])
            {
                //存在信息
                _shipYearText.text=builderTime;
                
                
            }else
            {
                _shipYearText.placeholder=@"请输入建成年份";
            }

        }
            break;
        case 3:
        {
            _shipNumberText.frame=CGRectMake(cell.bounds.size.width-160-30, (cell.bounds.size.height-30)/2, 160, 30);
            [cell.contentView addSubview:_shipNumberText];
            if (shipNumber && ![shipNumber isEqualToString:@""])
            {
                //存在信息
                _shipNumberText.text=shipNumber;
               
                
            }else
            {
                _shipNumberText.placeholder=@"请输入船舶号";
            }

        }
            break;

        case 4:
        {
            _shipLengthText.frame=CGRectMake(cell.bounds.size.width-160-30, (cell.bounds.size.height-30)/2, 160, 30);
            [cell.contentView addSubview:_shipLengthText];
            NSLog(@"-----length==%@",length);
            if (length && ![length doubleValue]==0)
            {
                //存在信息
                _shipLengthText.text=[NSString stringWithFormat:@"%@",length];
                
                
            }else
            {
                _shipLengthText.placeholder=@"请输入船舶长度";
            }

        }
            break;
            
        case 5:
        {
            _shipWaterEatText.frame=CGRectMake(cell.bounds.size.width-160-30, (cell.bounds.size.height-30)/2, 160, 30);
            [cell.contentView addSubview:_shipWaterEatText];
            if (waterEat && ![waterEat doubleValue]==0)
            {
                //存在信息
                _shipWaterEatText.text=[NSString stringWithFormat:@"%@",waterEat];
                
                
            }else
            {
                _shipWaterEatText.placeholder=@"请输入吃水深度";
            }

        }
            break;

        
        default:
            break;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==5)
    {
        [self showImageOption];
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
    //UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //[self uploadPictureWithImage:editImage];
    
}

#pragma mark action
//保存
-(void)save:(UIButton*)sender
{
    [self saveShipInfo];
    
}
-(IBAction)back:(id)sender
{
    //返回主页面
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [self.mm_drawerController setCenterViewController:delegate.rootViewController.mainController withCloseAnimation:YES completion:nil];
}
//保存信息
-(void)saveShipInfo
{
    if (_shipNameText.text && ![_shipNameText.text isEqualToString:@""] && _shipVolumeText && ![_shipVolumeText.text isEqualToString:@""])
    {
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"正在保存";
        
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        int loginId=[[userDefault objectForKey:@"loginId"] intValue];
        int shipID=[[userDefault objectForKey:@"shipOwnerId"] intValue];
        
        [NetWorkInterface completeShipInfoWithShipID:shipID loginId:loginId shipNumber:_shipNumberText.text volume:[_shipVolumeText.text intValue] builderTime:_shipYearText.text shipName:_shipNameText.text length:[_shipLengthText.text doubleValue] waterEat:[_shipWaterEatText.text doubleValue] finished:^(BOOL success, NSData *response) {
            
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            NSLog(@"------------保存船信息:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if (success)
            {
                id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                    {
                        [hud setHidden:YES];
                        
                        MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud1.customView = [[UIImageView alloc] init];
                        hud1.mode = MBProgressHUDModeCustomView;
                        [hud1 hide:YES afterDelay:1.f];
                        hud1.labelText = @"保存成功";
                    
                        //如果是push进来的就返回
                        [self.navigationController popViewControllerAnimated:YES];
                        
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"船名和载重必须填写";
        return;

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
