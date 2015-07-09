//
//  TaskViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/5/29.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskCell.h"
#import "Constants.h"
#import "TaskDetailViewController.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "OrdersModel.h"
#import "RefreshView.h"
#import "SettingViewController.h"

#import "WebViewViewController.h"

#import "CommonCell.h"
#import "UIViewController+MMDrawerController.h"
#import "LocationButton.h"
#import "SelectPortViewController.h"
#import "RightViewController.h"

@interface TaskViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    UIView *_backView;
    UITextField *_pwd;

}
@property(nonatomic,strong)NSMutableArray *ordersArray;
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
@end

@implementation TaskViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.hidesBottomBarWhenPushed=NO;
    
    //[self firstLoadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.title=@"任务大厅";
    _index=1;
    _ordersArray=[[NSMutableArray alloc]init];
   
    [self initNavigation];
    [self initAndLayoutUI];
    [self initBackView];
    //[self firstLoadData];
     _backView.hidden=YES;
    
    

}

-(void)initNavigation
{
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 24, 24);
    [rightButton setBackgroundImage:kImageName(@"head_small.png") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;

//    UIButton *leftButton1=[UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton1.frame=CGRectMake(0, 0, 24, 24);
//    [leftButton1 setBackgroundImage:kImageName(@"choose.png") forState:UIControlStateNormal];
//    [leftButton1 addTarget:self action:@selector(selcetPort:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem  *leftItem1=[[UIBarButtonItem alloc]initWithCustomView:leftButton1];
//    
//    UIButton *leftButton2=[UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton2 setTitle:@"港口筛选" forState:UIControlStateNormal];
//    leftButton2.titleLabel.font=[UIFont boldSystemFontOfSize:14];
//    leftButton2.frame=CGRectMake(0, 0, 60, 24);
//    [leftButton2 addTarget:self action:@selector(selcetPort:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem  *leftItem2=[[UIBarButtonItem alloc]initWithCustomView:leftButton2];

    LocationButton *leftButton1=[LocationButton buttonWithType:UIButtonTypeCustom];
    //leftButton1.backgroundColor=[UIColor redColor];
    leftButton1.nameLabel.text=@"港口筛选";
    leftButton1.frame=CGRectMake(0, 0, kLocationButtonWidth, 24);
    [leftButton1 addTarget:self action:@selector(selcetPort:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem  *leftItem1=[[UIBarButtonItem alloc]initWithCustomView:leftButton1];
    
    self.navigationItem.leftBarButtonItem=leftItem1;

    //leftButton1.frame=CGRectMake(0, 0, 24, 24);

    //[leftButton1 setBackgroundImage:kImageName(@"choose.png") forState:UIControlStateNormal];
    //[leftButton1 addTarget:self action:@selector(selcetPort:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem  *leftItem1=[[UIBarButtonItem alloc]initWithCustomView:leftButton1];
//    
//    self.navigationItem.leftBarButtonItem=leftItem1;
    
}
#pragma mark action
-(IBAction)selcetPort:(id)sender
{
    SelectPortViewController *selectPort=[[SelectPortViewController alloc]init];
    selectPort.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:selectPort animated:YES];
}
-(IBAction)showRight:(id)sender
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
}
-(IBAction)setting:(id)sender
{
    SettingViewController*setting=[[SettingViewController alloc]init];
    setting.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setting animated:YES];
}
-(IBAction)join:(id)sender
{
    _backView.hidden=NO;
    

}
-(void)cancelBTN:(UIButton*)button
{
    _backView.hidden=YES;
    _pwd.text=nil;
    [self.view endEditing:YES];
}
-(void)sureBTN:(UIButton*)button
{
   //加入船队
  [self joinTeam];
   _pwd.text=nil;
    [self.view endEditing:YES];
    
}

-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.rowHeight=150;
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
-(void)initBackView
{
    CGFloat width=kScreenWidth;
    CGFloat height=kScreenHeight;
    CGFloat leftSpace=20;
    CGFloat rightSpace=20;
    CGFloat topSpace=20;
    CGFloat bottomSpace=10;
    //CGFloat vSpace=5;
    
    _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _backView.backgroundColor=[UIColor colorWithRed:95/255.0 green:114/255.0 blue:114/255.0 alpha:0.5];
    [self.view addSubview:_backView];
    
    UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake((width-width*0.8)/2, 80, width*0.8, height*0.3)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [_backView addSubview:whiteView];
    
    UILabel *title=[[UILabel alloc]init];
    title.font=[UIFont systemFontOfSize:16];
    title.text=@"输入船队密码";
    title.textColor=[self colorWithHexString:@"757474"];
    title.frame=CGRectMake(leftSpace, topSpace, 180, 30);
    [whiteView addSubview:title];
    
    _pwd=[[UITextField alloc]init];
    _pwd.delegate=self;
    _pwd.keyboardType=UIKeyboardTypeNumberPad;
    _pwd.clearButtonMode=UITextFieldViewModeWhileEditing;
    //_pwd.backgroundColor=kColor(223, 224, 224, 1);
    _pwd.layer.cornerRadius=0;
    _pwd.layer.borderColor=[UIColor grayColor].CGColor;
    _pwd.layer.borderWidth=1;
    _pwd.frame=CGRectMake(leftSpace, topSpace+40, width*0.8-leftSpace*2, 40);
    _pwd.placeholder=@"请输入船队密码";
    _pwd.leftViewMode=UITextFieldViewModeAlways;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
    _pwd.leftView=view;
    [whiteView addSubview:_pwd];
    
    UIButton *cancelBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBTN.frame=CGRectMake(2*leftSpace, height*0.3-bottomSpace-30, 60, 30);
    [cancelBTN setTitle:@"取消" forState:UIControlStateNormal];
    cancelBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [cancelBTN setTitleColor:[self colorWithHexString:@"757474"] forState:UIControlStateNormal];
    [cancelBTN addTarget:self action:@selector(cancelBTN:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelBTN];
    
    UIButton *sureBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBTN.frame=CGRectMake(width*0.8-rightSpace-60-rightSpace, height*0.3-bottomSpace-30, 60, 30);
    sureBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [sureBTN setTitle:@"确定" forState:UIControlStateNormal];
    [sureBTN setTitleColor:[self colorWithHexString:@"757474"] forState:UIControlStateNormal];
    [sureBTN addTarget:self action:@selector(sureBTN:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:sureBTN];
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
//加入船队   18657152192
-(void)joinTeam
{
    if (!_pwd.text || [_pwd.text isEqualToString:@""])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"船队密码不能为空";

    }else
    {
        _backView.hidden=YES;
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"加入中...";
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        NSNumber *loginId=[user objectForKey:@"loginId"];
        NSNumber *shipOwnerId=[user objectForKey:@"shipOwnerId"];
        [NetWorkInterface joinTeamWithCode:_pwd.text loginId:[loginId intValue] shipOwnerId:[shipOwnerId intValue] finished:^(BOOL success, NSData *response) {
            NSLog(@"!!-------加入船队:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            
            if (success)
            {
                id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                    {
                        [hud setHidden:YES];
                        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"恭喜成功加入船队!" message:@"请在'我的任务'中查看" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [alertView show];
                        
                    }else
                    {
                        NSString *message=[object objectForKey:@"message"];
                        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [alertView show];

                        //hud.labelText=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    }
                }else
                {
                    hud.labelText=kServiceReturnWrong;
                }
            }else
            {
                hud.labelText=kNetworkFailed;
            }
            
        }];

    }
    
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
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    double latitude=[[user objectForKey:@"latitude"] doubleValue];
    double longitude=[[user objectForKey:@"longitude"] doubleValue];
    [NetWorkInterface getOrderListWithPage:page status:0 keys:@"" mLat1:latitude mLon1:longitude finished:^(BOOL success, NSData *response) {
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
    
    [_tableView reloadData];
}
#pragma mark ----------------UITableViewDelegate----------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndetifier =@"taskCell";
    CommonCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell==nil)
    {
        cell=[[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
//    OrdersModel *order=_ordersArray[indexPath.row];
//    cell.fromLabel.text=order.beginPortName;
//    cell.toLabel.text=order.endPortName;
//    cell.whatLabel.text=order.cargos;
////    double allPay=[order.allPay doubleValue];
////    NSString *pay=[NSString stringWithFormat:@"%.2f",allPay];
//    cell.moneyLabel.text=[NSString stringWithFormat:@"%@吨",order.amount];
//     cell.distanceImV.image=kImageName(@"where.png");
//    cell.whereLabel.text=order.longDistance;
    
    //cell.backgroundColor=[UIColor redColor];
    
    cell.companyName.text=@"中宁物流";
    cell.fromCity.text=@"南通";
    cell.fromPort.text=@"马达加斯加港口";
    cell.toCity.text=@"芜湖";
    cell.toPort.text=@"安达曼港";
    cell.price.text=@"12.00元";
    cell.weight.text=@"2000吨";
    cell.loadTime.text=@"2015年7月6号装船";
    cell.goods.text=@"水泥";
    cell.endTime.text=@"2小时53分34秒后结束";
    cell.deposit.text=@"保证金:200.00元";
    
    return cell;
        
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    OrdersModel *order=_ordersArray[indexPath.row];
//    int ID=[order.ID intValue];
    TaskDetailViewController *detail=[[TaskDetailViewController alloc]init];
    detail.selectedIndex=_index;
    //detail.ID=ID;
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark ---UITextFieldDelegate----
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex==buttonIndex) {
        
    }else
    {
        //升级
        [self upShip];
    }
}
-(void)upShip
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"请耐心等待";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefaults objectForKey:@"loginId"] intValue];
    int shipOwnerId=[[userDefaults objectForKey:@"shipOwnerId"] intValue];
    
    [NetWorkInterface upShipWithshipId:shipOwnerId loginId:loginId finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------升级为高级船----:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            hud.customView=[[UIImageView alloc]init];
            [hud hide:YES afterDelay:0.3];
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    
                    NSString *urlString=[object objectForKey:@"result"];
                    WebViewViewController *webView=[[WebViewViewController alloc]init];
                    webView.urlString=urlString;
                    webView.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:webView animated:YES];
                    
                    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                    
                }else
                {
                    hud.labelText=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
            }else
            {
                hud.labelText=kServiceReturnWrong;
            }
        }else
        {
            hud.labelText=kNetworkFailed;
        }
        
    }];
    
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
