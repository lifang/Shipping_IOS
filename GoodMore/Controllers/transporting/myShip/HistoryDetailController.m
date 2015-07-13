//
//  HistoryDetailController.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "HistoryDetailController.h"
#import "LogisticsCell.h"
#import "ShipDetailCell.h"
#import "HistoryDetailCell.h"
#import "MyShipModel.h"
#import "PayForShipController.h"

@interface HistoryDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)ShipOrder *shipOder;

@property(nonatomic,strong)NSString *allAcconnt;

@property(nonatomic,strong)NSMutableArray *shipNumberData;
@end

@implementation HistoryDetailController

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        NSString *shipOwerId = [userDefaults objectForKey:@"shipOwnerId"];
        NSLog(@"%@!!!!!!%@",_shipOder.shipID,shipOwerId);
        NSLog(@"%@",_shipOder.status);
        if ([_shipOder.status isEqualToString:@"3"] && [_shipOder.shipID intValue] == [shipOwerId intValue]) {
             _tableView.frame = CGRectMake(0, 0, K_MainWidth, K_MainHeight - 142);
            UIButton *settleBtn = [[UIButton alloc]initWithFrame:CGRectMake(K_MainWidth / 5 - 10, CGRectGetMaxY(_tableView.frame) + 10, K_MainWidth / 1.5, 40)];
            CALayer *readBtnLayer = [settleBtn layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:3.0];
            [settleBtn setBackgroundImage:[UIImage imageNamed:@"lianglan"] forState:UIControlStateNormal];
            [settleBtn setTitle:@"结算运费" forState:UIControlStateNormal];
            [settleBtn addTarget:self action:@selector(settleClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:settleBtn];
            
        }else{
             _tableView.frame = CGRectMake(0, 0, K_MainWidth, K_MainHeight - 62);
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    for (UIView *v in self.navigationController.navigationBar.subviews) {
    //        if ([NSStringFromClass(v.class) isEqualToString:@"_UINavigationBarBackground"]) {
    //            [v removeFromSuperview];
    //        }
    //    }
    self.navigationController.navigationBarHidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务详情";
    self.view.backgroundColor = [UIColor whiteColor];
    _shipNumberData = [[NSMutableArray alloc]init];

    //获取数据
    [self LoadDetailRequest];
}


//创建headerView
-(void)setupHeaderView {
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, K_MainWidth, 220);
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSString *Identifer = [NSString stringWithFormat:@"%@",_shipOder.status];
    LogisticsCell *logistCell = [[LogisticsCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:Identifer];
    [headerView addSubview:logistCell];
    [logistCell setContentWithShipOrderModel:_shipOder AndAllAccount:_allAcconnt];
    _tableView.tableHeaderView = headerView;
}
#pragma mark -- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shipNumberData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShipInTeam *shipInTeamModel = [_shipNumberData objectAtIndex:indexPath.row];
    HistoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyDetailCell"];
    cell = [[HistoryDetailCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"historyDetailCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setContentWithShipInTeamModel:shipInTeamModel];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *fistV = [[UIView alloc]init];
    fistV.frame = CGRectMake(0, 0, K_MainWidth, 30);
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.font = [UIFont systemFontOfSize:13];
    firstLabel.text =@"参与船舶";
    firstLabel.textColor = kColor(115, 114, 114, 1.0);
    firstLabel.frame = CGRectMake(20, 10, 100, 20);
    [fistV addSubview:firstLabel];
    return fistV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HistoryDetailCellHeight;
}

#pragma mark -- Request
-(void)LoadDetailRequest {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId = [[userDefaults objectForKey:@"loginId"] intValue];
    [NetWorkInterface getHistoryDetailWithShipId:[_shipID intValue] LoginId:loginId finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseHistoryDataWithDictionary:object];
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

-(void)parseHistoryDataWithDictionary:(NSDictionary *)dict {
    
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.allAcconnt = [[dict objectForKey:@"result"] objectForKey:@"allAccount"];
    _shipOder = [[ShipOrder alloc]initWithParseDictionary:[[dict objectForKey:@"result"] objectForKey:@"shipTeamInfo"]];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //创建headerView
    [self setupHeaderView];
    
    if (![[dict objectForKey:@"result"] objectForKey:@"shipList"] || ![[[dict objectForKey:@"result"] objectForKey:@"shipList"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *shipList =[[dict objectForKey:@"result"] objectForKey:@"shipList"];
    for (int i = 0; i < [shipList count]; i++) {
        ShipInTeam *shipInTeamModel = [[ShipInTeam alloc]initWithParseDictionary:shipList[i]];
        [_shipNumberData addObject:shipInTeamModel];
    }
    [self.tableView reloadData];
}

#pragma mark -- Action
-(void)settleClicked {
    PayForShipController *payVC = [[PayForShipController alloc]init];
    payVC.shipOrderModel = _shipOder;
    payVC.contentArray = [[NSMutableArray alloc]initWithArray:_shipNumberData];
    [self.navigationController pushViewController:payVC animated:YES];
}
@end
