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
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_staticData;
    UIImageView *_icon;
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
}
-(void)initStaticData
{
    _staticData=[[NSArray alloc]initWithObjects:@"姓名",@"船名",@"电话",@"修改密码", nil];
}
-(IBAction)signOut:(id)sender
{
    LoginViewController *loginVC=[[LoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed=YES;
    self.navigationController.viewControllers=@[loginVC];
    
}
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
    
    _icon=[[UIImageView alloc]init];
    _icon.image=kImageName(@"setting_in.png");
    
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
#pragma mark ---------UITableView--------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
            cell.detailTextLabel.text=[userDefaults objectForKey:@"name"];
        }
            break;
        case 1:
        {
             cell.detailTextLabel.text=[userDefaults objectForKey:@"shipNumber"];
        }
            break;
        case 2:
        {
            cell.detailTextLabel.text=[userDefaults objectForKey:@"phone"];
        }
            break;
        case 3:
        {
            _icon.frame=CGRectMake(cell.bounds.size.width-30, (cell.bounds.size.height-20)/2, 20, 20);
            [cell.contentView addSubview:_icon];
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
