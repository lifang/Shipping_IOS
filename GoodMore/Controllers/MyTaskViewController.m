//
//  MyTaskViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/5/29.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MyTaskViewController.h"
#import "Constants.h"
#import "TaskCell.h"
#import "TaskDetailViewController.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "RefreshView.h"
#import "MytaskModel.h"
#import "MYView.h"
#import "GoodsTransDetailViewController.h"
#import "LoadGoodsViewController.h"
#import "ShipTeamDetailViewController.h"

#import "PayFreightViewController.h"

@interface MyTaskViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,MYViewDelegate>
{
    UIButton *_SelectBtn;
    UITableView *_tableView;
   
    UILabel *_poll;
    NSArray *_statusArray1;
    NSArray *_statusArray2;
    
    NSString *_type;//船的级别
}
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,assign)BOOL isSelected;

@property(nonatomic,assign)ShipTeamStatus ShipTeamStatus;//管理船队状态
@property(nonatomic,assign)GoodsTransportStatus goodsTransportStatus;//货物运输状态
@property(nonatomic,strong)NSMutableArray *mytaskArray;

@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page1;
@property (nonatomic, assign) int page2;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,strong)UIButton *currentButton;//导航栏上当前显示的button

@end

@implementation MyTaskViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    _type=[userDefault objectForKey:@"type"];

    if ([_type intValue]==1)
    {
        //高级船
        _ShipTeamStatus=ShipTeamStatusAll;
        _goodsTransportStatus=GoodsTransportStatusAll;
        
        //_staticData=[[NSArray alloc]initWithObjects:@"全部",@"选船中",@"被拒绝",@"执行中",@"已完成", nil];
        _mytaskArray=[[NSMutableArray alloc]init];
        [self initStaticData];
        [self initAndLayoutUI];
        [self initNavigation];
        [self shipTeamListfirstLoadData];
        
    }else if ([_type intValue]==6)
    {
        //普通船
        _goodsTransportStatus=GoodsTransportStatusAll;
        _statusArray2=[[NSArray alloc]initWithObjects:@"全部",@"组队中",@"组队失败",@"执行中",@"完成", nil];
        _mytaskArray=[[NSMutableArray alloc]init];
        _currentButton.tag=777;
        [self initAndLayoutUI];
        [self initGoodsTransportNav];
        [self goodsTransportListfirstLoadData];
    }
    
}
-(void)initStaticData
{
     _statusArray1=[[NSArray alloc]initWithObjects:@"全部",@"组队中",@"组队成功",@"组队失败",@"结算运费",@"完成", nil];
     _statusArray2=[[NSArray alloc]initWithObjects:@"全部",@"组队中",@"组队失败",@"执行中",@"完成", nil];
}
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    //_tableView.tag=110;
    _tableView.rowHeight=100;
    
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    //获得状态栏的高度
    CGFloat statusBarHeight=[[UIApplication sharedApplication] statusBarFrame].size.height;
    //导航栏的高度
    CGFloat navHeight=self.navigationController.navigationBar.frame.size.height;
     _height=statusBarHeight + navHeight;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:_height+30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];

}
-(void)initGoodsTransportNav
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navView.backgroundColor=kMainColor;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.navigationController.view addSubview:navView];

    UILabel *title=[[UILabel alloc]init];
    title.frame=CGRectMake((kScreenWidth-80)/2, 20, 80, 30);
    title.text=@"货物运输";
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont boldSystemFontOfSize:20];
    [navView addSubview:title];
    
    [self creatStatusBarWithArray:_statusArray2];

}
-(void)initNavigation
{
    UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navView.backgroundColor=kMainColor;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.navigationController.view addSubview:navView];
    
    CGFloat space=30;
    CGFloat width=(kScreenWidth-space*3)/2;
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"管理船队" forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    leftButton.frame=CGRectMake(space, 30, width, 30);
    [leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag=666;
    _currentButton=leftButton;
    [navView addSubview:leftButton];
    
    _poll=[[UILabel alloc]initWithFrame:CGRectMake(space, 60, width, 3)];
    _poll.backgroundColor=[UIColor whiteColor];
    [navView addSubview:_poll];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(space+space+width, 30, width, 30);
    [rightButton setTitle:@"货物运输" forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    [rightButton addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag=777;
    [navView addSubview:rightButton];

    [self creatStatusBarWithArray:_statusArray1];
    
}
-(void)creatStatusBarWithArray:(NSArray*)array;
{
    MYView *myView=[[MYView alloc]initWithFrame:CGRectMake(0, _height, kScreenWidth, 30)];
    myView.delegate=self;
    myView.tag=array.count;
    [myView setItems:array];
    [self.view addSubview:myView];
}
#pragma mark ------action-----
-(void)leftButton:(UIButton*)sender
{
    _currentButton=sender;
    _poll.frame=CGRectMake(sender.frame.origin.x, 60, (kScreenWidth-30*3)/2, 3);
    [self creatStatusBarWithArray:_statusArray1];
    [self shipTeamListfirstLoadData];
}
-(void)rightButton:(UIButton*)sender
{
    _currentButton=sender;
    _poll.frame=CGRectMake(sender.frame.origin.x, 60, (kScreenWidth-30*3)/2, 3);
    [self creatStatusBarWithArray:_statusArray2];
    [self goodsTransportListfirstLoadData];
}

#pragma mark --------MYView-------
-(void)changeValueWithView:(UIView *)myview Index:(NSInteger)index
{
    if (myview.tag==_statusArray1.count)
    {
        //管理船队
        [self changeShipTeamStatusWithIndex:index-2];
        
    }else if (myview.tag==_statusArray2.count)
    {
        //NSLog(@"----index---- %ld",(long)index);
        //货物运输
        [self changeGoodsTransportStatusWithIndex:index-2];
    }
    
}

#pragma mark -------------------------UITableViewDelegate--------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_mytaskArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_type intValue]==6)
    {
        //普通船
        
        static NSString *cellIndetifier =@"taskCell";
        TaskCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        if (cell==nil)
        {
            cell=[[TaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        }
        MytaskModel *myTask=_mytaskArray[indexPath.row];
        cell.fromLabel.text=myTask.beginPortName;
        cell.toLabel.text=myTask.endPortName;
        cell.whatLabel.text=myTask.cargos;
        
        cell.moneyLabel.text=[NSString stringWithFormat:@"%@吨",myTask.amount];
        cell.distanceImV.image=kImageName(@"where.png");
        cell.whereLabel.text=myTask.longDistance;
        //[cell.statusBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

        switch ([myTask.relationStatus intValue])
        {
            case 0:
                [cell.statusBtn setTitle:@"组队中" forState:UIControlStateNormal];
                break;
            case 1:
                [cell.statusBtn setTitle:@"组队失败" forState:UIControlStateNormal];
                break;
            case 2:
                [cell.statusBtn setTitle:@"执行中" forState:UIControlStateNormal];
                break;
            case 3:
                [cell.statusBtn setTitle:@"已完成" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        
        return cell;

        
    }else if([_type intValue]==1)
    {
        //高级船
        static NSString *cellIndetifier =@"taskCell";
        TaskCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        if (cell==nil)
        {
            cell=[[TaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        }
        MytaskModel *myTask=_mytaskArray[indexPath.row];
        cell.fromLabel.text=myTask.beginPortName;
        cell.toLabel.text=myTask.endPortName;
        cell.whatLabel.text=myTask.cargos;
        
        cell.moneyLabel.text=[NSString stringWithFormat:@"%@吨",myTask.amount];
        cell.distanceImV.image=kImageName(@"where.png");
        cell.whereLabel.text=myTask.longDistance;
        
        if (_currentButton.tag==666)
        {
            cell.distanceImV.hidden=YES;
        }else
        {
            cell.distanceImV.hidden=NO;
        }
        
        if (_currentButton.tag==666)
        {
            
            switch ([myTask.status intValue])
            {
                case 0:
                    [cell.statusBtn setTitle:@"组队中" forState:UIControlStateNormal];
                    break;
                case 1:
                    [cell.statusBtn setTitle:@"组队成功" forState:UIControlStateNormal];
                    break;
                case 2:
                    [cell.statusBtn setTitle:@"组队失败" forState:UIControlStateNormal];
                    break;
                case 3:
                    [cell.statusBtn setTitle:@"计算运费" forState:UIControlStateNormal];
                    break;
                case 4:
                    [cell.statusBtn setTitle:@"完成" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            
        }else
        {
            switch ([myTask.relationStatus intValue])
            {
                case 0:
                    [cell.statusBtn setTitle:@"组队中" forState:UIControlStateNormal];
                    break;
                case 1:
                    [cell.statusBtn setTitle:@"组队失败" forState:UIControlStateNormal];
                    break;
                case 2:
                    [cell.statusBtn setTitle:@"执行中" forState:UIControlStateNormal];
                    break;
                case 3:
                    [cell.statusBtn setTitle:@"已完成" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            
        }
        return cell;

        
    }else
    {
        return nil;
    }
    
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     if ([_type intValue]==6)
    {
        //普通船
        MytaskModel *myTask=_mytaskArray[indexPath.row];
        GoodsTransDetailViewController *goodsTrans=[[GoodsTransDetailViewController alloc]init];
        goodsTrans.status=[myTask.relationStatus intValue];
        goodsTrans.ID=[myTask.ID intValue];
        goodsTrans.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:goodsTrans animated:YES];
    }else if([_type intValue]==1)
    {
        if (_currentButton.tag==666)
        {
            //管理团队
            ShipTeamDetailViewController *shipTeam=[[ShipTeamDetailViewController alloc]init];
            MytaskModel *myTask=_mytaskArray[indexPath.row];
            shipTeam.status=[myTask.status intValue];
            shipTeam.ID=[myTask.ID intValue];
            shipTeam.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:shipTeam animated:YES];
            
        }else if (_currentButton.tag==777)
        {
            //货物运输
            MytaskModel *myTask=_mytaskArray[indexPath.row];
            GoodsTransDetailViewController *goodsTrans=[[GoodsTransDetailViewController alloc]init];
            goodsTrans.status=[myTask.relationStatus intValue];
            goodsTrans.ID=[myTask.ID intValue];
            goodsTrans.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:goodsTrans animated:YES];
        }

    }else{
        return;
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==111)
    {
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
}

-(void)changeShipTeamStatusWithIndex:(NSInteger)index
{
    switch (index)
    {
        case -1:
            _ShipTeamStatus=ShipTeamStatusAll;
            break;
        case 0:
            _ShipTeamStatus=ShipTeamStatusMaking;
            break;
        case 1:
            _ShipTeamStatus=ShipTeamStatusMakeSuccess;
            break;
        case 2:
            _ShipTeamStatus=ShipTeamStatusMakeFail;
            break;
        case 3:
            _ShipTeamStatus=ShipTeamStatusPayfreight;
            break;
        case 4:
            _ShipTeamStatus=ShipTeamStatusFinished;
            break;
            
        default:
            break;
    }
    
    [self shipTeamListfirstLoadData];
}
-(void)changeGoodsTransportStatusWithIndex:(NSInteger)index
{
    switch (index)
    {
        case -1:
            _goodsTransportStatus=GoodsTransportStatusAll;
            break;
        case 0:
            _goodsTransportStatus=GoodsTransportStatusMaking;
            break;
        case 1:
            _goodsTransportStatus=GoodsTransportStatusMakeFail;
            break;
        case 2:
            _goodsTransportStatus=GoodsTransportStatusPerforming;
            break;
        case 3:
            _goodsTransportStatus=GoodsTransportStatusFinish;
            break;
            
        default:
            break;
    }
    [self goodsTransportListfirstLoadData];

}

-(void)shipTeamListfirstLoadData
{
    _page1=1;
    [self shipTeamDownloadDataWithPage:_page1 isMore:NO];
}
- (void)shipTeamDownloadDataWithPage:(int)page isMore:(BOOL)isMore
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipOwnerId=[userDefaults objectForKey:@"shipOwnerId"];
    
    [NetWorkInterface getshipTeamListWithPage:page status:_ShipTeamStatus shipOwnerId:[shipOwnerId intValue] finished:^(BOOL success, NSData *response) {
    
    //[NetWorkInterface myTaskListWithPage:page status:_orderStatus shipOwerId:[shipOwerId intValue] finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        if (success) {
            NSLog(@"!!---------------船队列表:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_mytaskArray removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"content"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page1++;
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
    //[_mytaskArray removeAllObjects];
    NSDictionary *result=[dic objectForKey:@"result"];
    NSArray *content=[result objectForKey:@"content"];
  
    [content enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        MytaskModel *mytask=[[MytaskModel alloc]initWithDictionary:obj];
        [_mytaskArray addObject:mytask];
        
    }];
    
    [_tableView reloadData];
}
-(void)goodsTransportListfirstLoadData
{
    _page2=1;
    [self goodsTransportDownloadDataWithPage:_page2 isMore:NO];
}
- (void)goodsTransportDownloadDataWithPage:(int)page isMore:(BOOL)isMore
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipOwnerId=[userDefaults objectForKey:@"shipOwnerId"];
    
    [NetWorkInterface getGoodsTransportListWithPage:page status:_goodsTransportStatus shipOwerId:[shipOwnerId intValue] finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        if (success) {
            NSLog(@"!!---------------货物运输列表:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_mytaskArray removeAllObjects];
                    }
                    id list = [[object objectForKey:@"result"] objectForKey:@"content"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page2++;
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
#pragma mark ------ RefreshDelegate-----------------

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
    if (scrollView == _tableView) {
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
    
    switch ([_type intValue]) {
        case 1:
        {
            //高级船
            if (_currentButton.tag==666)
            {
                //管理船队
                [self shipTeamListfirstLoadData];
                
            }else if(_currentButton.tag==777)
            {
                //货物运输
                [self goodsTransportListfirstLoadData];
            }

            
        }
            break;
        case 6:
        {
            //普通船
            [self goodsTransportListfirstLoadData];
            
        }
            break;
            
        default:
            break;
    }
    
}

//上拉加载
- (void)pullUpToLoadData {
    
    switch ([_type intValue]) {
        case 1:
        {
            //高级船
            if (_currentButton.tag==666)
            {
                //管理船队
                [self shipTeamListfirstLoadData];
                
            }else if(_currentButton.tag==777)
            {
                //货物运输
                [self goodsTransportListfirstLoadData];
            }
            
            
        }
            break;
        case 6:
        {
            //普通船
            [self goodsTransportListfirstLoadData];
            
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
