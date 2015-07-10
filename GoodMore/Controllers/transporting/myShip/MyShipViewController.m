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
#import "NetWorkInterface.h"
#import "JoinShipController.h"

@interface MyShipViewController ()<TopButtonClickedDelegate,UITableViewDelegate,UITableViewDataSource,ShipDetailCellDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)TableViewType tableType;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)HistoryController *historyVC;

@property(nonatomic,strong)LogisticsCell *logisticCell;

@property(nonatomic,strong)NSMutableArray *totalLastTime;

@property(nonatomic,strong)NSTimer *timer;

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
    
    _totalLastTime = [[NSMutableArray alloc]init];
    [_totalLastTime addObject:@"120000"];
    [self startTimer];
    
    //设置导航栏View
    [self setupTopView];
    //获取船队信息
    [self loadShipDetail];
}

-(void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}

-(void)refreshLessTime {
    NSUInteger time;
    for (int i = 0; i < _totalLastTime.count; i++) {
        time = [_totalLastTime[i] integerValue];
        _logisticCell.endTimeLabel.text = [NSString stringWithFormat:@"%@",[self lessSecondToDay:--time]];
        NSString *newTime = [NSString stringWithFormat:@"%i",time];
        [_totalLastTime replaceObjectAtIndex:i withObject:newTime];
    }
}

- (NSString *)lessSecondToDay:(NSUInteger)seconds
{
    NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    NSString *time = [NSString stringWithFormat:@"%lu日%lu小时%lu分钟%lu秒",(unsigned long)day,(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    return time;
    
}
//创建头部的View
-(void)setupTopView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    _headerView = [[UIView alloc]init];
    _headerView.frame = CGRectMake(0, 0, K_MainWidth, 250);
    _headerView.backgroundColor = [UIColor whiteColor];
    
    _logisticCell = [[LogisticsCell alloc]init];
    _logisticCell.successTeam.hidden = YES;
    _logisticCell.frame = CGRectMake(0, 0, K_MainWidth, 250);
    [_headerView addSubview:_logisticCell];
    
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
    [dismissShip setBackgroundImage:[UIImage imageNamed:@"lianglan"] forState:UIControlStateNormal];
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
    [grabBtn setBackgroundImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateNormal];
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

#pragma mark -- Request
-(void)loadShipDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetWorkInterface shipMakeTeamWithLoginId:88 finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    UILabel *label = [[UILabel alloc]init];
                    label.font = [UIFont systemFontOfSize:13];
                    label.text = @"您还未加入任何船队！";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor blackColor];
                    label.frame = CGRectMake(K_MainWidth / 4, K_MainHeight / 5, K_MainWidth / 2, 30);
                    label.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:label];
                    
                    UIButton *btn = [[UIButton alloc]init];
                    [btn setTitle:@"加入船队" forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"lianglan"] forState:UIControlStateNormal];
                    CALayer *readBtnLayer = [btn layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:4.0];
                    btn.frame = CGRectMake(label.frame.origin.x - 20, CGRectGetMaxY(label.frame) + 10, K_MainWidth / 1.7, 35);
                    [btn addTarget:self action:@selector(joinInShipTeam) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:btn];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                  
                    //创建headerView
                    [self setupHeaderView];
                    //创建footerView
                    [self setupFooterView];
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
    NSLog(@"解散船队");
}

-(void)grabClicked {
    NSLog(@"抢单");
}

-(void)joinInShipTeam {
    NSLog(@"加入船队");
    JoinShipController *joinVC = [[JoinShipController alloc]init];
    joinVC.view.frame = CGRectMake(0, 0, 80, 80);
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:joinVC];
    nav.navigationBarHidden = YES;
    nav.modalPresentationStyle = UIModalPresentationCustom;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)pushToHistoryDetail {
    HistoryDetailController *historyVC = [[HistoryDetailController alloc]init];
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyVC animated:YES];
}
@end
