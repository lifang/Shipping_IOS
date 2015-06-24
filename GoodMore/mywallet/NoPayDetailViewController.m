//
//  NoPayDetailViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/11.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "NoPayDetailViewController.h"
#import "Constants.h"
#import "NoPayDetailCell.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "RefreshView.h"
#import "NoPayDetailModel.h"

@interface NoPayDetailViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;

@end

@implementation NoPayDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _icon.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=_cargoName;
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    [self initAndLayoutUI];
    [self firstLoadData];
}
-(void)initAndLayoutUI
{
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"日期", @"类型",@"金额",@"累计",nil];
    CGFloat topSpace=20;
    CGFloat leftSpace=20;
    CGFloat width=(kScreenWidth-leftSpace*2)/titleArray.count;
    
    for (int i=0; i<titleArray.count; i++)
    {
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+width*i, topSpace, width, 30)];
        titleLabel.text=titleArray[i];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.textColor=[self colorWithHexString:@"757474"];
        [self.view addSubview:titleLabel];
    }
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, topSpace+30, kScreenWidth, 1)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, topSpace+30+1, kScreenWidth, kScreenHeight-topSpace-31)];
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
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
#pragma mark ----------UITableView--------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier =@"noPayDetailCell";
    NoPayDetailCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell==nil)
    {
        cell=[[NoPayDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    NoPayDetailModel *detailModel=_dataArray[indexPath.row];
    cell.date.text=detailModel.createTimeStr;
    cell.date.textColor=kWalletTitleColor;
    cell.type.textColor=kWalletTitleColor;
    cell.type.text=detailModel.typeName;
    cell.money.text=[NSString stringWithFormat:@"￥%.2f",[detailModel.toPay doubleValue]];
    cell.addUp.text=[NSString stringWithFormat:@"￥%.2f",[detailModel.allPay doubleValue]];
    cell.addUp.textColor=[self colorWithHexString:@"18A90D"];
    if (indexPath.row==0)
    {
        cell.money.textColor=[self colorWithHexString:@"18A90D"];
    }else
    {
        cell.money.textColor=[self colorWithHexString:@"F90824"];
    }
    return cell;

}

-(void)firstLoadData
{
    _page=1;
    [self downloadDataWithPage:_page isMore:NO];
}
- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"加载中...";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipOwerId=[userDefaults objectForKey:@"shipOwerId"];
    [NetWorkInterface payRecordListWithCargoId:[_cargoId intValue] shipOwerId:[shipOwerId intValue] page:page cargoName:_cargoName finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        if (success) {
            NSLog(@"!!---------------货运公司支付列表:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_dataArray removeAllObjects];
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
    NSDictionary *paySerialList=[result objectForKey:@"paySerialList"];
    NSArray *content=[paySerialList objectForKey:@"content"];
    [content enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        NoPayDetailModel *detail=[[NoPayDetailModel alloc]initWithDictionary:obj];
        [_dataArray addObject:detail];
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


@end
