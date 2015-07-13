//
//  MyShipViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MyShipViewController.h"
#import "TopButton.h"
#import "LogistCellTwo.h"
#import "ShipDetailCell.h"
#import "HistoryController.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "HistoryDetailController.h"
#import "NetWorkInterface.h"
#import "JoinShipController.h"
#import "MyShipModel.h"
#import "PayForShipController.h"
#import "ShipInfoViewController.h"
#import "RefreshView.h"

@interface MyShipViewController ()<TopButtonClickedDelegate,UITableViewDelegate,UITableViewDataSource,ShipDetailCellDelegate,UIAlertViewDelegate,RefreshDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)TableViewType tableType;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)HistoryController *historyVC;

@property(nonatomic,strong)LogistCellTwo *logisticCell;

@property(nonatomic,strong)MyShipModel *myshipModel;

@property(nonatomic,strong)NSMutableArray *shipNoInTeamData;

@property(nonatomic,strong)NSMutableArray *shipNumbersData;

@property(nonatomic,strong)NSMutableArray *shipRankData;

@property(nonatomic,strong)UIButton *dismissBtn;

@property(nonatomic,strong)UIButton *grabBtn;

@property(nonatomic,assign)int weight;

@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIButton *btn2;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

@end

@implementation MyShipViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    for (UIView *v in self.navigationController.navigationBar.subviews) {
//        if ([NSStringFromClass(v.class) isEqualToString:@"_UINavigationBarBackground"]) {
//            [v removeFromSuperview];
//        }
//    }
    self.navigationController.navigationBarHidden = YES;
    //获取船队信息
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToHistoryDetail:) name:PushToHistoryDetailNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViews) name:JiedanchenggongShipNotification object:nil];
    
    [self loadViews];
   

}

-(void)setupRefreshView {
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.frame.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
//    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,80)];
//    _bottomRefreshView.direction = PullFromBottom;
//    _bottomRefreshView.delegate = self;
//    _bottomRefreshView.hidden = YES;
//    [_tableView addSubview:_bottomRefreshView];
}
#pragma mark -- Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    [self updateFooterViewFrame];
}

- (BOOL)refreshViewIsLoading:(RefreshView *)view {
    return _reloading;
}

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
    [self refreshViewReloadData];
    //loading...
    if (view == _topRefreshView) {
        [self pullDownToLoadData];
    }
    else if (view == _bottomRefreshView) {
        [self pullUpToLoadData];
    }
}

- (void)updateFooterViewFrame {
    _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (_tableView.contentSize.height < _tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    if (scrollView == _tableView) {
        if (_bottomRefreshView.frame.origin.y != scrollView.contentSize.height) {
            [self updateFooterViewFrame];
        }
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidScroll:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidEndDragging:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}
#pragma mark - 上下拉刷新
//下拉刷新
- (void)pullDownToLoadData {
    [self loadShipDetail];
}

//上拉加载
- (void)pullUpToLoadData {
//    [self downloadDataWithPage:self.page isMore:YES];
}

-(void)loadViews {
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = TableViewTypeTeam;
    _tableView.frame = CGRectMake(0, 60, K_MainWidth, K_MainHeight - 60 * 2.2);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self setupRefreshView];
    
    _shipNoInTeamData = [[NSMutableArray alloc]init];
    _shipNumbersData = [[NSMutableArray alloc]init];
    _shipRankData = [[NSMutableArray alloc]init];
    self.weight = 0;
    [self loadShipDetail];
    //设置导航栏View
    [self setupTopView];
    [self setupHeaderView];
}

//创建头部的View
-(void)setupTopView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *topV = [[UIView alloc]init];
    topV.userInteractionEnabled = YES;
    topV.backgroundColor = kLightColor;
    topV.frame = CGRectMake(0, 0, K_MainWidth, 65);
    
    TopButton *topBtn = [[TopButton alloc]init];
    topBtn.delegate = self;
    topBtn.frame = CGRectMake(0, 20, K_MainWidth, 65);
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
}

//创建footerView
-(void)setupFooterView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    if (!_logisticCell) {
        _logisticCell = [[LogistCellTwo alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"zuduizhong"];
        _logisticCell.successTeam.hidden = YES;
        _logisticCell.frame = CGRectMake(0, 0, K_MainWidth, 250);
        [_logisticCell setContentWithMyshipModel:_myshipModel];
        [_headerView addSubview:_logisticCell];
        _tableView.tableHeaderView = _headerView;
    }else{
        [_logisticCell setContentWithMyshipModel:_myshipModel];
    }
    
    if ([_myshipModel.isTeamLeader isEqualToString:@"1"]) {
        
        _tableView.frame = CGRectMake(0, 60, K_MainWidth, K_MainHeight - 60 * 3.2);
        UIView *footerV = [[UIView alloc]init];
        footerV.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), K_MainWidth, 72);
        footerV.backgroundColor = [UIColor whiteColor];
        _dismissBtn = [[UIButton alloc]init];
        [_dismissBtn setTitle:@"解散船队" forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismissClicked) forControlEvents:UIControlEventTouchUpInside];
        _dismissBtn.frame = CGRectMake(20, 22, K_MainWidth / 2.5, 40);
        [_dismissBtn setBackgroundImage:[UIImage imageNamed:@"lianglan"] forState:UIControlStateNormal];
        CALayer *readBtnLayer1 = [_dismissBtn layer];
        [readBtnLayer1 setMasksToBounds:YES];
        [readBtnLayer1 setCornerRadius:3.0];
        //    [readBtnLayer1 setBorderWidth:1.0];
        //    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
        [footerV addSubview:_dismissBtn];
        
        _grabBtn = [[UIButton alloc]init];
        [_grabBtn setTitle:@"抢单" forState:UIControlStateNormal];
        [_grabBtn addTarget:self action:@selector(grabClicked) forControlEvents:UIControlEventTouchUpInside];
        _grabBtn.frame = CGRectMake(CGRectGetMaxX(_dismissBtn.frame) + 25, 22, K_MainWidth / 2.5, 40);
        [_grabBtn setBackgroundImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateNormal];
        CALayer *readBtnLayer2 = [_grabBtn layer];
        [readBtnLayer2 setMasksToBounds:YES];
        [readBtnLayer2 setCornerRadius:3.0];
        //    [readBtnLayer1 setBorderWidth:1.0];
        //    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
        [footerV addSubview:_grabBtn];
        
        [self.view addSubview:footerV];
    }
}

#pragma mark -- TopBtnDelegate
-(void)TopBtnClickedWithBtnType:(BtnType)btnType {
    switch (btnType) {
        case BtnTypeOne:
            NSLog(@"点击了第1个按钮！");
            [self loadShipDetail];
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
    _historyVC.view.frame = CGRectMake(0, 65, K_MainWidth, K_MainHeight - 65);
    [self.view addSubview:_historyVC.view];
}

#pragma mark -- Request

//获得船队数据
-(void)loadShipDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId = [[userDefaults objectForKey:@"loginId"] intValue];
    [NetWorkInterface shipMakeTeamWithLoginId:loginId finished:^(BOOL success, NSData *response) {
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
                    [_tableView removeFromSuperview];
                    [_headerView removeFromSuperview];
                    [_dismissBtn removeFromSuperview];
                    [_grabBtn removeFromSuperview];
                    [_label removeFromSuperview];
                    [_btn removeFromSuperview];
                    [_btn2 removeFromSuperview];
                    [_logisticCell removeFromSuperview];
                    _label = [[UILabel alloc]init];
                    _label.font = [UIFont systemFontOfSize:13];
                    _label.text = @"您还未加入任何船队！";
                    _label.textAlignment = NSTextAlignmentCenter;
                    _label.textColor = [UIColor blackColor];
                    _label.frame = CGRectMake(K_MainWidth / 4, K_MainHeight / 5, K_MainWidth / 2, 30);
                    _label.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:_label];
                    
                    _btn = [[UIButton alloc]init];
                    [_btn setTitle:@"加入船队" forState:UIControlStateNormal];
                    _btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_btn setBackgroundImage:[UIImage imageNamed:@"lianglan"] forState:UIControlStateNormal];
                    CALayer *readBtnLayer = [_btn layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:4.0];
                    _btn.frame = CGRectMake(_label.frame.origin.x - 20, CGRectGetMaxY(_label.frame) + 10, K_MainWidth / 1.7, 35);
                    [_btn addTarget:self action:@selector(joinInShipTeam) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:_btn];
                    
                    _btn2 = [[UIButton alloc]init];
                    [_btn2 addTarget:self action:@selector(refreshMySelf) forControlEvents:UIControlEventTouchUpInside];
                    [_btn2 setTitle:@"已申请加入船队，刷新我的状态？" forState:UIControlStateNormal];
                    _btn2.titleLabel.font = [UIFont systemFontOfSize:13];
                    [_btn2 setTitleColor:kLightColor forState:UIControlStateNormal];
                    [_btn2 setBackgroundColor:[UIColor clearColor]];
                    _btn2.frame = CGRectMake(_btn.frame.origin.x - 20, CGRectGetMaxY(_btn.frame) + 20, 240, 20);
                    [self.view addSubview:_btn2];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    
                    [self parseTradeDataWithDictionary:object];
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
        [self refreshViewFinishedLoadingWithDirection:PullFromTop];

    }];
}

-(void)refreshMySelf {
    [self loadViews];
}

//解析字典
- (void)parseTradeDataWithDictionary:(NSDictionary *)dict {
    
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [_shipNoInTeamData removeAllObjects];
    [_shipNumbersData removeAllObjects];
    [_shipRankData removeAllObjects];
    _myshipModel = [[MyShipModel alloc]initWithParseDictionary:[dict objectForKey:@"result"]];
    
    if (![[dict objectForKey:@"result"] objectForKey:@"shipInTeam"] && ![[[dict objectForKey:@"result"] objectForKey:@"shipInTeam"]isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *shipInTeamArray = [[dict objectForKey:@"result"] objectForKey:@"shipInTeam"];
    for (int i = 0; i < shipInTeamArray.count; i++) {
        if (!shipInTeamArray[i] || [shipInTeamArray[i] isKindOfClass:[NSDictionary class]]) {
            ShipInTeam *shipTeamModel = [[ShipInTeam alloc]initWithParseDictionary:shipInTeamArray[i]];
            [_shipNumbersData addObject:shipTeamModel];
        }
    }
    
    if ([[dict objectForKey:@"result"] objectForKey:@"shipNoInTeam"] && [[[dict objectForKey:@"result"] objectForKey:@"shipNoInTeam"]isKindOfClass:[NSArray class]]) {
        NSArray *shipnoInTeamArray = [[dict objectForKey:@"result"] objectForKey:@"shipNoInTeam"];
        for (int i = 0; i < shipnoInTeamArray.count; i++) {
            if (!shipnoInTeamArray[i] || [shipnoInTeamArray[i] isKindOfClass:[NSDictionary class]]) {
                ShipInTeam *shipTeamModel = [[ShipInTeam alloc]initWithParseDictionary:shipnoInTeamArray[i]];
                [_shipNoInTeamData addObject:shipTeamModel];
            }
        }
    }
    
    if ([[dict objectForKey:@"result"] objectForKey:@"singleShipList"] && [[[dict objectForKey:@"result"] objectForKey:@"singleShipList"]isKindOfClass:[NSArray class]]) {
        NSArray *singleShipArray = [[dict objectForKey:@"result"] objectForKey:@"singleShipList"];
        for (int i = 0; i < singleShipArray.count; i++) {
            if (!singleShipArray[i] || [singleShipArray[i] isKindOfClass:[NSDictionary class]]) {
                ShipInTeam *shipTeamModel = [[ShipInTeam alloc]initWithParseDictionary:singleShipArray[i]];
                [_shipRankData addObject:shipTeamModel];
            }
        }
    }
    
    //创建footerView
    [self setupFooterView];
    
    [self.tableView reloadData];
}

//同意船请求
-(void)agreenRequestWithSelctedId:(NSString *)selectedID {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId = [[userDefaults objectForKey:@"loginId"] intValue];
    [NetWorkInterface agreenJoinWithSelectedID:[selectedID intValue] Status:1 LoginID:loginId finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    [hud hide:YES];
                    [self loadShipDetail];
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

//删除船请求
-(void)deleteRequestWithSelectedID:(NSString *)selectedID {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId = [[userDefaults objectForKey:@"loginId"] intValue];
    [NetWorkInterface deletedshipWithshipTeamID:[_myshipModel.shipTeam.shipTeamID intValue] delShipId:[selectedID intValue] LoginID:loginId finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    [hud hide:YES];
                    [self loadShipDetail];
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

//解散船队请求
-(void)dissmissShipRequest {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId = [[userDefaults objectForKey:@"loginId"] intValue];
    NSString *shipOwerId = [userDefaults objectForKey:@"shipOwnerId"];
    [NetWorkInterface dismissshipWithshipTeamID:[_myshipModel.shipTeam.shipTeamID intValue] LoginId:loginId ShipOwnerId:[shipOwerId intValue] finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    [hud hide:YES];
                    [self loadShipDetail];
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

//抢单
-(void)grapRequest {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId = [[userDefaults objectForKey:@"loginId"] intValue];
    NSString *shipOwerId=[userDefaults objectForKey:@"shipOwnerId"];
    [NetWorkInterface grapshipWithshipTeamID:[_myshipModel.shipTeam.shipTeamID intValue] LoginId:loginId ShipOwnerId:[shipOwerId intValue] finished:^(BOOL success, NSData *response) {
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
                    hud.labelFont = [UIFont systemFontOfSize:12];
                    [hud hide:YES afterDelay:0.3f];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    [hud hide:YES];
                    [self loadShipDetail];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"抢单成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                    alert.tag = 333;
                    alert.delegate = self;
                    [alert show];
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
    [self deleteRequestWithSelectedID:selectedID];
}

-(void)agreenWithSelectedID:(NSString *)selectedID {
    NSLog(@"同意了id%@",selectedID);
    [self agreenRequestWithSelctedId:selectedID];
}

#pragma mark -- TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_myshipModel.isTeamLeader isEqualToString:@"1"]) {
        return 3;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _shipNumbersData.count;
    }else{
        if (section == 1) {
            return _shipNoInTeamData.count;
        }else{
            return _shipRankData.count;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShipDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell = [[ShipDetailCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell1"];
        ShipInTeam *shipInTeamModel = [_shipNumbersData objectAtIndex:indexPath.row];
        _weight = _weight + [shipInTeamModel.volume intValue];
        cell.selectedID = shipInTeamModel.ID;
        [cell setContentWithShipInTeamModel:shipInTeamModel AndMyShipModel:_myshipModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1)
    {
        ShipDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell = [[ShipDetailCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell2"];
        ShipInTeam *shipnoInTeamModel = [_shipNoInTeamData objectAtIndex:indexPath.row];
        cell.selectedID = shipnoInTeamModel.ID;
        [cell setContentWithShipnoInTeamModel:shipnoInTeamModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else{
        ShipDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell = [[ShipDetailCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell3"];
        ShipInTeam *shipnoRankModel = [_shipRankData objectAtIndex:indexPath.row];
        cell.selectedID = shipnoRankModel.ID;
        [cell setContentWithShipRankTeamModel:shipnoRankModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
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
        if (_shipNoInTeamData.count == 0) {
            firstLabel.text =@"待审核(无)";
        }
    }else {
        firstLabel.text =@"单船报价";
        if (_shipRankData.count == 0) {
            firstLabel.text =@"单船报价(无)";
        }
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

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- Action
-(void)dismissClicked {
    if (![_myshipModel.isTeamLeader isEqualToString:@"1"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"对不起，您不是船长！";
        [hud hide:YES afterDelay:0.3f];
        return;
    }
    NSLog(@"解散船队");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要解散船队吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = 111;
    alert.delegate = self;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 111) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self dissmissShipRequest];
        }
    }
    if (alertView.tag == 222) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            ShipInfoViewController *shipInfo=[[ShipInfoViewController alloc]init];
            shipInfo.type=@"isPush";
            shipInfo.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:shipInfo animated:YES];
        }
    }
    
    if (alertView.tag == 333) {
        if (buttonIndex != alertView.cancelButtonIndex) {
                [[NSNotificationCenter defaultCenter] postNotificationName:PushTotransportationNotification object:nil userInfo:nil];
        }
    }
}

-(void)grabClicked {
    NSLog(@"抢单");
    if (![_myshipModel.isTeamLeader isEqualToString:@"1"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"对不起，您不是船长！";
        [hud hide:YES afterDelay:0.3f];
        return;
    }
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipName=[userDefaults objectForKey:@"shipName"];
    if (shipName) {
        [self grapRequest];
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"请补全信息！";
        [hud hide:YES afterDelay:0.3f];
        return;
    }
//    if (_weight <= [_myshipModel.shipTeam.allAccount intValue]) {
    
//    }else{
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.customView = [[UIImageView alloc] init];
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.labelText = @"对不起，船队吨位不达标！";
//        [hud hide:YES afterDelay:0.3f];
//        return;
//    }
}

-(void)joinInShipTeam {
    NSLog(@"加入船队");
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipName=[userDefaults objectForKey:@"shipName"];
    NSLog(@"%@",shipName);
    if (shipName) {
        JoinShipController *joinVC = [[JoinShipController alloc]init];
        joinVC.view.frame = CGRectMake(0, 0, 80, 80);
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:joinVC];
        nav.navigationBarHidden = YES;
        nav.modalPresentationStyle = UIModalPresentationCustom;
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nav animated:YES completion:nil];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您的船队信息不完全，请先完善信息！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        alert.tag = 222;
        alert.delegate = self;
        [alert show];
    }
}

//-(void)pushToPayForShip:(NSNotification *)notification {
//    PayForShipController *payVC = [[PayForShipController alloc]init];
//    payVC.shipID = [notification.userInfo objectForKey:@"shipID"];
//    payVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:payVC animated:YES];
//}

-(void)pushToHistoryDetail:(NSNotification *)notification {
    HistoryDetailController *historyVC = [[HistoryDetailController alloc]init];
    historyVC.shipID = [notification.userInfo objectForKey:@"shipID"];
    historyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historyVC animated:YES];
}
@end
