//
//  BanksListViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/23.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "BanksListViewController.h"
#import "Constants.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"

@interface BanksListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_banksArray;
}
@end

@implementation BanksListViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"选择银行";
    _banksArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initAndLayoutUI];
    [self getBanksList];
}
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=40;
    [self setheadAndFootView];
    [self.view addSubview:_tableView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

}
-(void)setheadAndFootView
{
    UIView *headView=[[UIView alloc]init];
    headView.frame=CGRectMake(0, 0, kScreenWidth, 5);
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 4, kScreenWidth, 1)];
    line1.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line1];
    _tableView.tableHeaderView=headView;
    
    _tableView.tableFooterView=[[UIView alloc]init];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _banksArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndefier=@"bankslist";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndefier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndefier];
    }
    BanksModel *bank=_banksArray[indexPath.row];
    cell.textLabel.text=bank.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(getSelectBank:)])
    {
        BanksModel *bank=_banksArray[indexPath.row];
        [_delegate getSelectBank:bank];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//获得银行
-(void)getBanksList
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //hud.labelText=@"正在提现";
    [NetWorkInterface getBanksListfinished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------银行列表:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    //[hud setHidden:YES];
                    
                    [self parseBanksListWithDictionary:object];
                       
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
-(void)parseBanksListWithDictionary:(NSDictionary*)dic
{
    NSArray *result=[dic objectForKey:@"result"];
    [result enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        BanksModel *bank=[[BanksModel alloc]initWithDictionary:obj];
        [_banksArray addObject:bank];
    }];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
