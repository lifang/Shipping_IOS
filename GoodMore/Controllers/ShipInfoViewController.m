//
//  ShipInfoViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipInfoViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"

@interface ShipInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_staticData;
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
    
   
   

    _staticData=[[NSArray alloc]initWithObjects:@"船名",@"载重",@"船舶号",@"船舶长度",@"吃水",@"签证薄概况页照片", nil];
    
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
    switch (indexPath.row)
    {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;

        case 4:
        {
            
        }
            break;

        case 5:
        {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //[self uploadPictureWithImage:editImage];
    
}

#pragma mark action
//保存
-(void)save:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)back:(id)sender
{
    //返回主页面
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [self.mm_drawerController setCenterViewController:delegate.rootViewController.mainController withCloseAnimation:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
