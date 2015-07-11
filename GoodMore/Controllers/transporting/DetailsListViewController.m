//
//  DetailsListViewController.m
//  GoodMore
//
//  Created by comdosoft on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "DetailsListViewController.h"
#import "NetWorkInterface.h"
#import "OrdersModel.h"
#import "ShipHistoryCell.h"
#import "DetailsListTableViewCell.h"
@interface DetailsListViewController ()
@property(nonatomic,strong)NSMutableArray *ordersArray;

@end

@implementation DetailsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ordersArray=[[NSMutableArray alloc]init];

    [self initRefreshViewWithOffset:0];
    [self firstLoadData];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}
#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ordersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndetifier =@"taskCell";
    DetailsListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell==nil)
    {
        cell=[[DetailsListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrdersModel *order = _ordersArray[indexPath.row];
    cell.successLabel.hidden = YES;
    cell.logistNameLabel.text = order.companyName;
    
    cell.startPlaceLabel.text = order.beginPortName;
    cell.startPortLabel.text = order.beginDockName;
    
    cell.endPlaceLabel.text = order.endPortName;
    cell.endPortLabel.text = order.endDockName;
    double price = [order.maxPay doubleValue];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",price];
    cell.weightLabel.text = [NSString stringWithFormat:@"%@吨",order.amount];
    cell.dateLabel.text = order.workTime;
    cell.goodsLabel.text = order.cargos;
    cell.endTimeLabel.text = order.showTime;
    cell.marginLabel.text = @"保证金:200.00元";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
#pragma mark - Request
- (void)firstLoadData {
    self.page = 1;
    [self downloadDataWithPage:self.page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore

{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//    double latitude=[[user objectForKey:@"latitude"] doubleValue];
//    double longitude=[[user objectForKey:@"longitude"] doubleValue];
//    [[user objectForKey:@"loginId"] integerValue]
    [NetWorkInterface getGoodsTransportListWithPage:page status:-1 shipOwerId:63 finished:^(BOOL success, NSData *response) {
   
        //[NetWorkInterface getOrderListWithPage:page status:0 keys:@"" mLat1:latitude mLon1:longitude finished:^(BOOL success, NSData *response) {
        NSLog(@"!!---------------任务大厅:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        if (success) {
            
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_ordersArray removeAllObjects];

                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"content"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                
                    [self parsePortListWithDictionary:object];
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];



}
-(void)parsePortListWithDictionary:(NSDictionary*)dic
{
    if (![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *result=[dic objectForKey:@"result"];
    NSArray *content=[result objectForKey:@"content"];
    [content enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        OrdersModel *order=[[OrdersModel alloc]initWithDictionary:obj];
        [_ordersArray addObject:order];
    }];
    
    [self.tableView reloadData];
}
#pragma mark - 上下拉刷新重写

- (void)pullDownToLoadData {
    
    [self firstLoadData];
    //latitude  longitude
   
}

- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
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
