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
#import "DetailViewController.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "RefreshView.h"
#import "MytaskModel.h"
@interface MyTaskViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    UIButton *_SelectBtn;
    UITableView *_tableView;
    NSArray *_staticData;
}
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,assign)BOOL isSelected;

@property(nonatomic,assign)OrderStatus orderStatus;//状态
@property(nonatomic,strong)NSMutableArray *mytaskArray;

@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;


@end

@implementation MyTaskViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self firstLoadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _index=2;
    _orderStatus=OrderStatusAll;
    _staticData=[[NSArray alloc]initWithObjects:@"全部",@"选船中",@"被拒绝",@"执行中",@"已完成", nil];
    _mytaskArray=[[NSMutableArray alloc]init];
    [self initNavigation];
    [self initAndLayoutUI];
    
    [self firstLoadData];
    
    
}
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tag=110;
    _tableView.rowHeight=100;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
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
-(UITableView*)myTableView
{
    
    if ( !_myTableView ) {
        _myTableView =[[UITableView alloc]init];
        _myTableView.tag=111;
        _myTableView.backgroundColor=kMainColor;
        _myTableView.showsVerticalScrollIndicator=NO;
        _myTableView.rowHeight=30;
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        
    }
    return _myTableView;
}
-(void)initNavigation
{
    _SelectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _SelectBtn.frame=CGRectMake(0, 0, 100, 40);
    [_SelectBtn setTitle:@"全部" forState:UIControlStateNormal];
    _SelectBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_SelectBtn setImage:kImageName(@"pull.png") forState:UIControlStateNormal];
    _SelectBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    //_SelectBtn.contentEdgeInsets=UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    _SelectBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 70, 0, 10);
    [_SelectBtn addTarget:self action:@selector(SelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView=_SelectBtn;
}
-(IBAction)SelectBtn:(UIButton*)sender
{
    _isSelected = !_isSelected;
    
    self.myTableView.frame=CGRectMake((kScreenWidth-100)/2, 0, 100, 150);
    [self.view addSubview:_myTableView];
    if (_isSelected)
    {
        _myTableView.hidden=YES;
        UITableView *tableView=(UITableView*)[self.view viewWithTag:110];
        tableView.userInteractionEnabled=YES;

        
    }else
    {
        _myTableView.hidden=NO;
        UITableView *tableView=(UITableView*)[self.view viewWithTag:110];
        tableView.userInteractionEnabled=NO;

    }
    
}

#pragma mark -------------------------UITableViewDelegate--------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==110)
    {
        return [_mytaskArray count];
    }else if (tableView.tag==111)
    {
        return [_staticData count];
    }else{
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==110) {
        static NSString *cellIndetifier =@"taskCell";
        TaskCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        if (cell==nil)
        {
            cell=[[TaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        }
        MytaskModel *myTask=_mytaskArray[indexPath.row];
        NSLog(@"-------*******状态----%d----------",[myTask.status intValue]);
        cell.fromLabel.text=myTask.beginPortName;
        cell.toLabel.text=myTask.endPortName;
        cell.whatLabel.text=myTask.cargos;
        double allPay=[myTask.allPay doubleValue];
        NSString *pay=[NSString stringWithFormat:@"%.2f",allPay];
        cell.moneyLabel.text=[NSString stringWithFormat:@"%@元/吨",pay];
        cell.whereLabel.text=myTask.longDistance;
        //cell.fromLabel.font=[UIFont boldSystemFontOfSize:12];
        switch ([myTask.relationStatus intValue])
        {
            case 0:
                [cell.statusBtn setTitle:@"选船中" forState:UIControlStateNormal];
                break;
            case 1:
                [cell.statusBtn setTitle:@"被拒绝" forState:UIControlStateNormal];
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
    }else if (tableView.tag==111)
    {
        UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text=_staticData[indexPath.row];
        cell.textLabel.textColor=[UIColor whiteColor];
    
        cell.backgroundColor=kMainColor;
        return cell;
    }else
    {
        return nil;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==110)
    {
        MytaskModel *mytask=_mytaskArray[indexPath.row];
        DetailViewController *detail=[[DetailViewController alloc]init];
        detail.selectedIndex=_index;
        detail.ID=[mytask.ID intValue];
        detail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else if(tableView.tag==111)
    {
        _myTableView.hidden=YES;
        UITableView *tableView=(UITableView*)[self.view viewWithTag:110];
        tableView.userInteractionEnabled=YES;
        [self changeStatusWithIndex:indexPath.row];
        switch (indexPath.row)
        {
            case 0:
            {
                [_SelectBtn setTitle:@"全部" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [_SelectBtn setTitle:@"选船中" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [_SelectBtn setTitle:@"被拒绝" forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [_SelectBtn setTitle:@"执行中" forState:UIControlStateNormal];
            }
                break;
            case 4:
            {
                [_SelectBtn setTitle:@"已完成" forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        
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

-(void)changeStatusWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
            _orderStatus=OrderStatusAll;
            break;
        case 1:
            _orderStatus=OrderStatusSelecting;
            break;
        case 2:
            _orderStatus=OrderStatusRefuse;
            break;
        case 3:
            _orderStatus=OrderStatusPerforming;
            break;
        case 4:
            _orderStatus=OrderStatusFinished;
            break;
            
        default:
            break;
    }
    
    [self firstLoadData];
}

-(void)firstLoadData
{
    _page=1;
    [self downloadDataWithPage:_page isMore:NO];
}
- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore
{
    //latitude  longitude
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipOwerId=[userDefaults objectForKey:@"shipOwerId"];
    [NetWorkInterface myTaskListWithPage:page status:_orderStatus shipOwerId:[shipOwerId intValue] finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        if (success) {
            NSLog(@"!!---------------我的任务:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
        MytaskModel *mytask=[[MytaskModel alloc]initWithDictionary:obj];
        [_mytaskArray addObject:mytask];
    }];
    
    [_tableView reloadData];
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
    [self firstLoadData];
}

//上拉加载
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
