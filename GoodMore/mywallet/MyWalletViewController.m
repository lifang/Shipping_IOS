//
//  MyWalletViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MyWalletViewController.h"
#import "Constants.h"
#import "WalletCell.h"
#import "NopayViewController.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "RefreshView.h"
#import "AvaliblePayModel.h"
#import "SureCashViewController.h"
#import "MoneyNumModel.h"
@interface MYButton : UIButton

@end

@implementation MYButton

-(void)setSelected:(BOOL)selected
{
    if (!selected)
    {
        [self setTitleColor:kTitleColor forState:UIControlStateNormal];
    }else
    {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end

@interface MyWalletViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    MYButton *_leftButton;
    MYButton *_rightButton;
    UIImageView *_icon;
    UIView *_backView;
    UIView *_blueView;
    UITableView *_tableView;
    NopayViewController *_NoPay;
    NSMutableArray *_dataArray;
    UILabel *_totalVal;
    UITextField *_moneyNum;
}
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
@property (nonatomic,assign)NSInteger selectIndex;//当前点击的按钮
@end

@implementation MyWalletViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _icon.hidden=NO;
    //[self firstLoadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigation];
    [self initAndLayoutUI];
    [self initBackView];
    [self firstLoadData];
    _backView.hidden=YES;
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];

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
-(void)initNavigation
{
    //去除下面的黑色边框
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage=[[UIImage alloc]init];
//    self.navigationController.navigationBar.barTintColor=kMainColor;
    
    CGFloat leftSpace;
    CGFloat rightSpace;
    leftSpace=rightSpace=20;
    CGFloat space=20;
    CGFloat width=(kScreenWidth-60)/2;
    _leftButton=[MYButton buttonWithType:UIButtonTypeCustom];
    _leftButton.selected=YES;
    _leftButton.tag=110;
    [_leftButton setTitle:@"可提现金额" forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.frame=CGRectMake(leftSpace, 20, width, 44);
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    //[self.navigationController.view addSubview:_leftButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    _rightButton=[MYButton buttonWithType:UIButtonTypeCustom];
    _rightButton.selected=NO;
    _rightButton.tag=111;
    [_rightButton setTitle:@"未支付运费" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.frame=CGRectMake(leftSpace+width+space, 20, width, 44);
    //[self.navigationController.view addSubview:_rightButton];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    _icon=[[UIImageView alloc]initWithImage:kImageName(@"sanjiao.png")];
    _icon.frame=CGRectMake(_leftButton.center.x-10, 64-8, 20, 8);
    [self.navigationController.view addSubview:_icon];
    
}
-(void)initAndLayoutUI
{
    CGFloat leftSpace=10;
    CGFloat topSpace=10;
    _blueView=[[UIView alloc]init];
    _blueView.translatesAutoresizingMaskIntoConstraints=NO;
    _blueView.frame=CGRectMake(leftSpace, topSpace, kScreenWidth-leftSpace*2, kScreenHeight/4);
    _blueView.backgroundColor=[self colorWithHexString:@"09BAE0"];
    [self.view addSubview:_blueView];
    
    UIButton *cash=[UIButton buttonWithType:UIButtonTypeCustom];
    [cash setTitle:@"提现" forState:UIControlStateNormal];
    cash.titleLabel.font=[UIFont systemFontOfSize:15];
    cash.frame=CGRectMake(_blueView.bounds.size.width-60-leftSpace, topSpace, 60, 25);
    cash.layer.cornerRadius=12;
    cash.layer.borderColor=[UIColor whiteColor].CGColor;
    cash.layer.borderWidth=1;
    [cash addTarget:self action:@selector(cash:) forControlEvents:UIControlEventTouchUpInside];
    [_blueView addSubview:cash];
    
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=CGRectMake(leftSpace*4, topSpace+cash.bounds.size.height+20, 30, 30);
    label1.text=@"￥";
    label1.font=[UIFont boldSystemFontOfSize:24];
    label1.textColor=[UIColor whiteColor];
    [_blueView addSubview:label1];
    
    _totalVal=[[UILabel alloc]init];
    _totalVal.frame=CGRectMake(leftSpace*4+30, topSpace+cash.bounds.size.height+5, kScreenWidth-leftSpace*2-leftSpace*4-30, 60);
    _totalVal.textColor=[UIColor whiteColor];
    _totalVal.font=[UIFont boldSystemFontOfSize:36];
    [_blueView addSubview:_totalVal];
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"日期",@"说明",@"金额", nil];
    for (int i=0; i<titleArray.count; i++)
    {
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(2*leftSpace+(60+(kScreenWidth-leftSpace*4-60*3)/2)*i, CGRectGetMaxY(_blueView.frame)+leftSpace/2, 60, 30)];
        titleLabel.text=titleArray[i];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.textColor=[self colorWithHexString:@"757474"];
        [self.view addSubview:titleLabel];
    }
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_blueView.frame)+leftSpace/2+30, kScreenWidth, 1)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line];
    
    _tableView=[[UITableView alloc]init];
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.frame=CGRectMake(0, CGRectGetMaxY(_blueView.frame)+leftSpace/2+30+1, kScreenWidth, kScreenHeight-(CGRectGetMaxY(_blueView.frame)+leftSpace/2+30));
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=50;
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

//提现
-(void)cash:(UIButton*)btn
{
    _backView.hidden=NO;
}
-(IBAction)leftButton:(MYButton*)sender
{
    if (_selectIndex==sender.tag)
    {
        //点击是同一个按钮
    }else
    {
        _selectIndex=sender.tag;
        _icon.frame=CGRectMake(_leftButton.center.x-10, 64-8, 20, 8);
        sender.selected=YES;
        _rightButton.selected=NO;
        [_NoPay.view removeFromSuperview];
        [self firstLoadData];
    }
    
}
-(IBAction)rightButton:(MYButton*)sender
{
    if (_selectIndex==sender.tag)
    {
        //点击是同一个按钮
        
    }else
    {
        _selectIndex=sender.tag;
        _icon.frame=CGRectMake(_rightButton.center.x-10, 64-8, 20, 8);
        sender.selected=YES;
        _leftButton.selected=NO;
        _NoPay=[[NopayViewController alloc]init];
        _NoPay.icon=_icon;
        [self.view addSubview:_NoPay.view];
        [self addChildViewController:_NoPay];
        [_NoPay didMoveToParentViewController:self];
    }
    
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
    
    UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake((width-width*0.8)/2, 120, width*0.8, height*0.3)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [_backView addSubview:whiteView];
    
    UILabel *title=[[UILabel alloc]init];
    title.font=[UIFont systemFontOfSize:16];
    title.text=@"输入提现金额";
    title.textColor=[self colorWithHexString:@"757474"];
    title.frame=CGRectMake(leftSpace, topSpace, 180, 30);
    [whiteView addSubview:title];
    
    _moneyNum=[[UITextField alloc]init];
    _moneyNum.delegate=self;
    _moneyNum.clearButtonMode=UITextFieldViewModeAlways;
    _moneyNum.backgroundColor=[UIColor lightGrayColor];
    _moneyNum.layer.cornerRadius=0;
    _moneyNum.layer.borderColor=[UIColor grayColor].CGColor;
    _moneyNum.layer.borderWidth=1;
    _moneyNum.frame=CGRectMake(leftSpace, topSpace+30, width*0.8-leftSpace*2, 30);
    _moneyNum.placeholder=@"请输入金额";
    [whiteView addSubview:_moneyNum];
    
    UILabel *prompt=[[UILabel alloc]init];
    prompt.text=@"可提现金额:99999.99元";
    prompt.textColor=[self colorWithHexString:@"757474"];
    prompt.textAlignment=NSTextAlignmentRight;
    prompt.font=[UIFont systemFontOfSize:12];
    prompt.frame=CGRectMake(width*0.8-160-rightSpace, topSpace+30+30, 160, 30);
    [whiteView addSubview:prompt];
    
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
-(void)cancelBTN:(UIButton*)btn
{
    _backView.hidden=YES;
}

-(void)sureBTN:(UIButton*)btn
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"正在提现";
    [NetWorkInterface checkGetCashWithmoneyNum:[_moneyNum.text intValue] finished:^(BOOL success, NSData *response) {
    
         hud.customView=[[UIImageView alloc]init];
         [hud hide:YES afterDelay:0.3];
         NSLog(@"------------可提现金额:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
         if (success)
         {
             id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
             if ([object isKindOfClass:[NSDictionary class]])
             {
                 if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                 {
                     [hud setHidden:YES];
                     
                     [self parseLoginDataWithDictionary:object];
                     
                     
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
-(void)parseLoginDataWithDictionary:(NSDictionary*)dic
{
    
    if (![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *result = [dic objectForKey:@"result"];
    MoneyNumModel *moneyNum=[[MoneyNumModel alloc]initWithDictionary:result];
    SureCashViewController *sure=[[SureCashViewController alloc]init];
    sure.hidesBottomBarWhenPushed=YES;
    sure.icon=_icon;
    sure.moneyNum=moneyNum;
    [self.navigationController pushViewController:sure animated:YES];


}

#pragma mark --------------UITableView-------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier =@"walletCell";
    WalletCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell==nil)
    {
        cell=[[WalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    AvaliblePayModel *avalible=_dataArray[indexPath.row];
    cell.date.text=[NSString stringWithFormat:@"%@",avalible.createTimeStr];
    cell.date.textAlignment=NSTextAlignmentCenter;
    cell.date.textColor=[self colorWithHexString:@"757474"];
    
    cell.explanation.text=avalible.typeName;
    cell.explanation.textAlignment=NSTextAlignmentCenter;
    cell.explanation.textColor=[self colorWithHexString:@"757474"];
    
    cell.money.text=[NSString stringWithFormat:@"%.2f",[avalible.nums doubleValue]];
    cell.money.textAlignment=NSTextAlignmentCenter;
    if (indexPath.row==0)
    {
        cell.money.textColor=[self colorWithHexString:@"18A90D"];
    }else
    {
        cell.money.textColor=[self colorWithHexString:@"F90824"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -------UITextField-------
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    [NetWorkInterface availblePayWithshipOwerId:[shipOwerId intValue] page:page finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        if (success) {
            NSLog(@"!!---------------可提现:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
    NSNumber *totalAvailble=[result objectForKey:@"totalAvailble"];
    double total=[totalAvailble doubleValue];
    _totalVal.text=[NSString stringWithFormat:@"%.2f",total];
    NSDictionary *recordList=[result objectForKey:@"recordList"];
    NSArray *content=[recordList objectForKey:@"content"];
    [content enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        AvaliblePayModel *avalible=[[AvaliblePayModel alloc]initWithDictionary:obj];
        [_dataArray addObject:avalible];
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
