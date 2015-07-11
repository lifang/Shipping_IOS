//
//  PortListViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "PortListViewController.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "PortModel.h"
@interface PortListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_portArray;
    NSMutableArray *_distanceArray;
}
@property(nonatomic,assign)int portID;
@end

@implementation PortListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    if (_index==0)
    {
        //装货港
        self.title=@"距离";
        _distanceArray=[[NSMutableArray alloc]initWithCapacity:0];
        [self initUI];
        [self getDistanceList];
        
    }else if (_index==1)
    {
        //卸货港
        self.title=@"卸货港";
        _portArray=[[NSMutableArray alloc]initWithCapacity:0];
        [self initUI];
       [self getPortList];
    }
    
   
}
-(void)initUI
{
    _tableView=[[UITableView alloc]init];
    //_tableView.scrollEnabled=NO;
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
#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_index==1)
    {
        return _portArray.count;
    }else
    {
        return _distanceArray.count+1;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndefier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndefier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndefier];
    }
    if (_index==1)
    {
        PortModel *port = _portArray[indexPath.row];
        cell.textLabel.text=port.name;
    }else
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"全部";
        }else
        {
            cell.textLabel.text=_distanceArray[indexPath.row-1];
        }
        

    }
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (_index)
    {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            PortModel *port = _portArray[indexPath.row];
            _portID=[port.ID intValue];
           
        }
            break;

            
        default:
            break;
    }
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if (_delegate && [_delegate respondsToSelector:@selector(getPortInfoWithportInfo:portID:index:)])
    {
        
        [_delegate getPortInfoWithportInfo:cell.textLabel.text portID:_portID index:_index];
        
        [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark request
//获得距离列表
-(void)getDistanceList
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"耐心等待";
    
    [NetWorkInterface getDictanceListWithfinished:^(BOOL success, NSData *response) {
        
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        NSLog(@"------------距离列表:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    
                    [self parseDistanceListWithDictionary:object];
                    
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
-(void)parseDistanceListWithDictionary:(NSDictionary*)dic
{
    if (![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *result=[dic objectForKey:@"result"];
    [result enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        NSString *distance=[obj objectForKey:@"content"];
        [_distanceArray addObject:distance];
    }];
    [_tableView reloadData];

}
//获得港口列表
-(void)getPortList
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"耐心等待";
    
    [NetWorkInterface getPortListWithfinished:^(BOOL success, NSData *response) {
  
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        NSLog(@"------------港口列表:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    
                    [self parsePortListWithDictionary:object];
                    
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
-(void)parsePortListWithDictionary:(NSDictionary*)dic
{
    if (![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *result = [dic objectForKey:@"result"];
    [result enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        PortModel *port=[[PortModel alloc]initWithDictionary:obj];
        [_portArray addObject:port];
    }];
     //[self initUI];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
