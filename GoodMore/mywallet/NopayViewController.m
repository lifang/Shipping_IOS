//
//  NopayViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "NopayViewController.h"
#import "Constants.h"
#import "WalletCell.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "RefreshView.h"
#import "NoPayModel.h"
#import "NoPayDetailViewController.h"
@interface NopayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_greenView;
    UITableView *_tableView;
    UILabel *_totalNoPay;
    NSMutableArray *_dataArray;
}
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property(nonatomic,assign)CGFloat height;
@end

@implementation NopayViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downloadDate];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    //[self downloadDate];
    [self initAndLayoutUI];
}

-(void)initAndLayoutUI
{
//    //获得状态栏的高度
//    CGFloat statusBarHeight=[[UIApplication sharedApplication] statusBarFrame].size.height;
//    //导航栏的高度
//    CGFloat navHeight=self.navigationController.navigationBar.frame.size.height;
//    _height=statusBarHeight + navHeight;
    
    CGFloat leftSpace=10;
    CGFloat topSpace=10;
    _greenView=[[UIView alloc]init];
    _greenView.translatesAutoresizingMaskIntoConstraints=NO;
    _greenView.frame=CGRectMake(leftSpace, topSpace+64, kScreenWidth-leftSpace*2, kScreenHeight/5);
    _greenView.backgroundColor=[self colorWithHexString:@"03D97C"];
    [self.view addSubview:_greenView];
    
//    UILabel *label1=[[UILabel alloc]init];
//    label1.frame=CGRectMake(leftSpace*4, _greenView.bounds.size.height/2-15, 30, 30);
//    label1.text=@"￥";
//    label1.textAlignment=NSTextAlignmentRight;
//    label1.font=[UIFont boldSystemFontOfSize:24];
//    label1.textColor=[UIColor whiteColor];
//    [_greenView addSubview:label1];
    _totalNoPay=[[UILabel alloc]init];
    _totalNoPay.frame=CGRectMake(0, (_greenView.bounds.size.height-60)/2, kScreenWidth-leftSpace*2, 60);
    
    _totalNoPay.textAlignment=NSTextAlignmentCenter;
    _totalNoPay.textColor=[UIColor whiteColor];
    _totalNoPay.font=[UIFont boldSystemFontOfSize:40];
    [_greenView addSubview:_totalNoPay];
    
    UILabel *company=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(_greenView.frame)+topSpace, 100, 30)];
    company.text=@"货代公司";
    company.textColor=[self colorWithHexString:@"757474"];
    [self.view addSubview:company];
    UILabel *money=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-leftSpace-100, CGRectGetMaxY(_greenView.frame)+topSpace, 100, 30)];
    money.text=@"金额";
    money.textAlignment=NSTextAlignmentRight;
    money.textColor=[self colorWithHexString:@"757474"];
    [self.view addSubview:money];
    
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(company.frame), kScreenWidth, 1)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line];
    
    _tableView=[[UITableView alloc]init];
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=40;
    _tableView.frame=CGRectMake(0, CGRectGetMaxY(company.frame)+1, kScreenWidth, kScreenHeight-CGRectGetMaxY(_greenView.frame)-topSpace-30-1);
    [self.view addSubview:_tableView];

}
#pragma mark --------UITableView------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier =@"walletCell";
    WalletCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell==nil)
    {
        cell=[[WalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    NoPayModel *noPay=_dataArray[indexPath.row];
    cell.date.text=noPay.companyName;
    cell.date.textColor=[self colorWithHexString:@"757474"];
    
    cell.money.text=[NSString stringWithFormat:@"￥%.2f",[noPay.allPay doubleValue]];
    cell.money.textColor=[self colorWithHexString:@"757474"];
    cell.money.textAlignment=NSTextAlignmentRight;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoPayModel *noPay=_dataArray[indexPath.row];
    NoPayDetailViewController *noPayDetail=[[NoPayDetailViewController alloc]init];
    noPayDetail.hidesBottomBarWhenPushed=YES;
    
    noPayDetail.cargoId=noPay.cargoOwnerId;
    noPayDetail.cargoName=noPay.companyName;
    [self.navigationController pushViewController:noPayDetail animated:YES];
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

//RGB 颜色转换
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
-(void)downloadDate
{

    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"加载中...";
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipOwnerId=[userDefaults objectForKey:@"shipOwnerId"];
    
    [NetWorkInterface noPaylistWithshipOwerId:[shipOwnerId intValue] finished:^(BOOL success, NSData *response) {
        
        NSLog(@"!!---------------未支付列表:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    //[hud setHidden:YES];
                    
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

}
-(void)parseLoginDataWithDictionary:(NSDictionary*)dic
{
    if (![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [_dataArray removeAllObjects];
    
    NSDictionary *result=[dic objectForKey:@"result"];
    double totalNoPay=[[result objectForKey:@"totalNoPay"]doubleValue];
    _totalNoPay.text=[NSString stringWithFormat:@"￥%.2f",totalNoPay];
    NSArray *noPayList=[[result objectForKey:@"noPayList"]copy];
    [noPayList enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        NoPayModel *noPay=[[NoPayModel alloc]initWithDictionary:obj];
        [_dataArray addObject:noPay];
    }];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
