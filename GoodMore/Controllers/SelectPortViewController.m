//
//  SelectPortViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "SelectPortViewController.h"
#import "Constants.h"
#import "PortListViewController.h"
@interface SelectPortViewController ()<UITableViewDataSource,UITableViewDelegate,PortListDelegate>
{
    UITableView *_tableView;
    UILabel *_loadPort;
    UILabel *_unLoadPort;
}
@end

@implementation SelectPortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"港口筛选";
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commit:)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    [self initUI];
}
-(void)initUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.scrollEnabled=NO;
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=50;
    [self setheadAndFootView];
    [self.view addSubview:_tableView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    _loadPort=[[UILabel alloc]init];
    _loadPort.textColor=kGrayColor;
    _loadPort.textAlignment=NSTextAlignmentRight;
    
    _unLoadPort=[[UILabel alloc]init];
    _unLoadPort.textColor=kGrayColor;
    _unLoadPort.textAlignment=NSTextAlignmentRight;


}
-(void)setheadAndFootView
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor=[UIColor clearColor];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 9.5, kScreenWidth, 0.5)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line];
    _tableView.tableHeaderView=headView;
    
    _tableView.tableFooterView=[[UIView alloc]init];
}
#pragma mark action
-(IBAction)commit:(id)sender
{
    
}
#pragma mark UITableView
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    CGFloat cellHeight=50;
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text=@"装货港";
            _loadPort.frame=CGRectMake(cell.bounds.size.width-160-30, (cellHeight-30)/2, 160, 30);
            _loadPort.text=@"未选择";
            [cell.contentView addSubview:_loadPort];
        }
            break;
        case 1:
        {
           cell.textLabel.text=@"卸货港";
            _unLoadPort.frame=CGRectMake(cell.bounds.size.width-160-30, (cellHeight-30)/2, 160, 30);
             _unLoadPort.text=@"未选择";
            [cell.contentView addSubview:_unLoadPort];
        }
            break;

            
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PortListViewController *portList=[[PortListViewController alloc]init];
    portList.index=indexPath.row;
    portList.delegate=self;
    [self.navigationController pushViewController:portList animated:YES];
}
#pragma mark PortListDelegate
-(void)getPortInfoWithportInfo:(NSString *)portInfo index:(NSInteger)index
{
    if (index==0)
    {
        _loadPort.text=portInfo;
    }else
    {
         _unLoadPort.text=portInfo;
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
