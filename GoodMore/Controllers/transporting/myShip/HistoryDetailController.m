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

@interface HistoryDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HistoryDetailController

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(0, 0, K_MainWidth, K_MainHeight - 62);
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    //创建headerView
    [self setupHeaderView];
}

//创建headerView
-(void)setupHeaderView {
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, K_MainWidth, 250);
    headerView.backgroundColor = [UIColor whiteColor];
    
    LogisticsCell *logistCell = [[LogisticsCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"1"];
    logistCell.frame = CGRectMake(0, 0, K_MainWidth, 250);
    [headerView addSubview:logistCell];
    
    _tableView.tableHeaderView = headerView;
}
#pragma mark -- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryDetailCell *cell = [[HistoryDetailCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

@end
