//
//  MyShipViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MyShipViewController.h"
#import "TopButton.h"
#import "LogisticsCell.h"
#import "ShipDetailCell.h"
#import "HistoryController.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "HistoryDetailController.h"

@interface MyShipViewController ()<TopButtonClickedDelegate,UITableViewDelegate,UITableViewDataSource,ShipDetailCellDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)TableViewType tableType;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)HistoryController *historyVC;

@end

@implementation MyShipViewController

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = TableViewTypeTeam;
        _tableView.frame = CGRectMake(0, 60, K_MainWidth, K_MainHeight - 60 * 3.2);
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
    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToHistoryDetail) name:PushToHistoryDetailNotification object:nil];
    
    //设置导航栏View
    [self setupTopView];
    //创建headerView
    [self setupHeaderView];
    //创建footerView
    [self setupFooterView];
}

//创建头部的View
-(void)setupTopView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIView *topV = [[UIView alloc]init];
    topV.userInteractionEnabled = YES;
    topV.backgroundColor = kLightColor;
    topV.frame = CGRectMake(0, 0, K_MainWidth, 60);
    
    TopButton *topBtn = [[TopButton alloc]init];
    topBtn.delegate = self;
    topBtn.frame = CGRectMake(0, 20, K_MainWidth, 40);
    topBtn.userInteractionEnabled = YES;
    [topBtn.firstBtn setTitle:@"组队中" forState:UIControlStateNormal];
    [topBtn.secondBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    [topV addSubview:topBtn];
    
    [self.view addSubview:topV];
    
}

//创建headerView
-(void)setupHeaderView {
    _headerView = [[UIView alloc]init];
    _headerView.frame = CGRectMake(0, 0, K_MainWidth, 250);
    _headerView.backgroundColor = [UIColor whiteColor];
    
    LogisticsCell *logistCell = [[LogisticsCell alloc]init];
    logistCell.successTeam.hidden = YES;
    logistCell.frame = CGRectMake(0, 0, K_MainWidth, 250);
    [_headerView addSubview:logistCell];
    
    _tableView.tableHeaderView = _headerView;
}

//创建footerView
-(void)setupFooterView {
    
    UIView *footerV = [[UIView alloc]init];
    footerV.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), K_MainWidth, 72);
    footerV.backgroundColor = [UIColor whiteColor];
    
    UIButton *dismissShip = [[UIButton alloc]init];
    [dismissShip setTitle:@"解散船队" forState:UIControlStateNormal];
    [dismissShip addTarget:self action:@selector(dismissClicked) forControlEvents:UIControlEventTouchUpInside];
    dismissShip.frame = CGRectMake(20, 22, K_MainWidth / 2.5, 40);
    [dismissShip setBackgroundColor:kLightColor];
    CALayer *readBtnLayer1 = [dismissShip layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:3.0];
//    [readBtnLayer1 setBorderWidth:1.0];
//    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [footerV addSubview:dismissShip];
    
    UIButton *grabBtn = [[UIButton alloc]init];
    [grabBtn setTitle:@"抢单" forState:UIControlStateNormal];
    [grabBtn addTarget:self action:@selector(grabClicked) forControlEvents:UIControlEventTouchUpInside];
    grabBtn.frame = CGRectMake(CGRectGetMaxX(dismissShip.frame) + 25, 22, K_MainWidth / 2.5, 40);
    [grabBtn setBackgroundColor:kLightColor];
    CALayer *readBtnLayer2 = [grabBtn layer];
    [readBtnLayer2 setMasksToBounds:YES];
    [readBtnLayer2 setCornerRadius:3.0];
    //    [readBtnLayer1 setBorderWidth:1.0];
    //    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [footerV addSubview:grabBtn];
    
    [self.view addSubview:footerV];
}

#pragma mark -- TopBtnDelegate
-(void)TopBtnClickedWithBtnType:(BtnType)btnType {
    switch (btnType) {
        case BtnTypeOne:
            NSLog(@"点击了第1个按钮！");
            [_historyVC.view removeFromSuperview];
            break;
        case BtnTypeTwo:
            NSLog(@"点击了第2个按钮！");
            [self pushToHistory];
            break;
        case BtnTypeIcon:
            NSLog(@"点击了第3个按钮！");
            [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

-(void)pushToHistory {
    _historyVC = [[HistoryController alloc]init];
    _historyVC.view.frame = CGRectMake(0, 60, K_MainWidth, K_MainHeight - 60);
    [self.view addSubview:_historyVC.view];
}

#pragma mark -- ShipDtailCellDelegate
-(void)deleteDataWithSelectedID:(NSString *)selectedID {
    NSLog(@"删除了id%@",selectedID);
}

#pragma mark -- TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShipDetailCell *cell = [[ShipDetailCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *fistV = [[UIView alloc]init];
    fistV.frame = CGRectMake(0, 0, K_MainWidth, 30);
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        firstLabel.text =@"船队成员";
    }else if (section == 1) {
        firstLabel.text =@"待审核";
    }else {
        firstLabel.text =@"单船报价";
    }
    firstLabel.textColor = kColor(115, 114, 114, 1.0);
    firstLabel.frame = CGRectMake(20, 5, 100, 20);
    [fistV addSubview:firstLabel];
    return fistV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ShipDetailCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- Action
-(void)dismissClicked {
    
}

-(void)grabClicked {
    NSLog(@"抢单");
}

-(void)pushToHistoryDetail {
    HistoryDetailController *historyVC = [[HistoryDetailController alloc]init];
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyVC animated:YES];
}
@end
