//
//  HistoryController.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "HistoryController.h"
#import "ShipHistoryCell.h"
#import "HistoryDetailController.h"
#import "RefreshView.h"
#import "ShipOrder.h"
#import "PromptView.h"

@interface HistoryController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *historyArray;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

//@property(nonatomic,strong)PromptView *promtView;
@property(nonatomic,strong)UILabel *messageLabel;
@end

@implementation HistoryController

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(0, 0, K_MainWidth, K_MainHeight - 60 * 2);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [self setupRefreshView];
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    _historyArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstLoadData) name:HistoryDetailControllerRefreshNotification object:nil];
    //获取历史列表
    [self firstLoadData];
}

-(void)setupRefreshView {
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.frame.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,80)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
}

#pragma mark -- UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShipOrder *shipOrder = [_historyArray objectAtIndex:indexPath.row];
    NSString *Identifier = [NSString stringWithFormat:@"historyCell%@",shipOrder.teamStatus];
    ShipHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell= [[ShipHistoryCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:Identifier];
    [cell setContentWithShipOrderModel:shipOrder];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShipOrder *shipOrder = [_historyArray objectAtIndex:indexPath.row];
//    if ([shipOrder.status isEqualToString:@"3"]) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:shipOrder.ID,@"shipID", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:PushToPayForShipNotification object:nil userInfo:dict];
//    }else{
//        
//    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:shipOrder.ID,@"shipID", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:PushToHistoryDetailNotification object:nil userInfo:dict];
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = kColor(188, 188, 188, 0.7);
//    line.frame = CGRectMake(10, 0, K_MainWidth - 20, 1);
//    return line;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 1;
//}

#pragma mark -- Reuest

-(void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipOwerId = [userDefaults objectForKey:@"shipOwnerId"];
    [NetWorkInterface getHistoryListWithShipOwnerId:[shipOwerId intValue] Status:-1 page:page finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.0f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_historyArray removeAllObjects];
                    }
                    id content = [[object objectForKey:@"result"] objectForKey:@"content"];
                    if ([content isKindOfClass:[NSArray class]] && [content count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";

                    }
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
        
    }];

}

-(void)parseHistoryDataWithDictionary:(NSDictionary *)dict {
    if (![[dict objectForKey:@"result"] objectForKey:@"content"] || ![[[dict objectForKey:@"result"] objectForKey:@"content"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *contentArray = [[dict objectForKey:@"result"] objectForKey:@"content"];
    for (int i = 0; i < [contentArray count]; i++) {
        ShipOrder *historyModel = [[ShipOrder alloc]initWithParseDictionary:contentArray[i]];
        [_historyArray addObject:historyModel];
    }
    if (_historyArray.count == 0) {
        _messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-70, kScreenHeight/2-75, 140, 30)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text=@"暂无历史任务";
        _messageLabel.textColor=kGrayColor;
        [self.view addSubview:_messageLabel];
    }
    
    [_tableView reloadData];
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
    [self firstLoadData];
}

//上拉加载
- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}

@end
