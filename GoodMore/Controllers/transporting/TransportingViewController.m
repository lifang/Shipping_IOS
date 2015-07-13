//
//  TransportingViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/7.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "TransportingViewController.h"
#import "Constants.h"
#import "MYInfoView.h"
#import "UIViewController+MMDrawerController.h"
#import "TransportingTableViewCell.h"
#import "LoadGoodsViewController.h"
#import "LoadGoodsViewController2.h"
#import "TransportingModel.h"

#import "DetailsListViewController.h"
@interface TransportingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *marginLable;
@property(nonatomic,strong)UILabel *fromCity;
@property(nonatomic,strong)UILabel *toCity;
@property(nonatomic,strong)UILabel *fromPort;
@property(nonatomic,strong)UILabel *toPort;
@property(nonatomic,strong)UILabel *price;

@property(nonatomic,strong)UILabel *weight;

@property(nonatomic,strong)UILabel *loadTime;
@property(nonatomic,strong)NSString *levelstatus;
@property(nonatomic,strong)NSString *ids;
@property(nonatomic,strong)NSString *shipRelationID;

@property(nonatomic,strong)UILabel *goods;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataItem;

@end

@implementation TransportingViewController
- (void)viewWillAppear:(BOOL)animated {
    [self downloadGoodDetail];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"运输任务";
    _dataItem = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList:)
                                                 name:RefreshListNotification
                                               object:nil];
    

    self.view.backgroundColor=[UIColor whiteColor];
    
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithImage:kImageName(@"head_small.png") style:UIBarButtonItemStyleDone target:self action:@selector(showRight:)];
//    self.navigationItem.rightBarButtonItem=rightItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"历史记录" style:UIBarButtonItemStyleDone target:self action:@selector(leftClick:)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:kImageName(@"personal.png") style:UIBarButtonItemStyleDone target:self action:@selector(showRight:)];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.navigationItem.rightBarButtonItem = rightItem;
    [self downloadGoodDetail];
    


    
    
}
#pragma mark - UI
//- (void)loadDetails
//{
//    _titleLable.text = @"中宁物流";
//    _fromCity.text = @"南通";
//    _fromPort.text = @"马达加斯加";
//    _toCity.text = @"芜湖";
//    _toPort.text = @"安达曼";
//    _price.text = @"12.00元";
//    _weight.text = @"2000 吨";
//    _loadTime.text = @"2015年12月7日装船";
//    _goods.text = @"水泥";
//
//
//}
- (void)initAndlayoutUI
{
    CGFloat topSpace=10;
    CGFloat leftSpace=20;
    CGFloat cityWidth=100;
    CGFloat PortWidth=kScreenWidth/3;//港口label的宽度
    CGFloat jianTouWidth=42;//箭头的长度
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 142)];
    [self.view addSubview:_titleView];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    backview.backgroundColor=kColor(224, 227, 228, 1);
    [_titleView addSubview:backview];
    
    UIImageView *titleimageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 20, 20)];
    [backview addSubview:titleimageview];
    titleimageview.image = kImageName(@"company");
    
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(45, 5, kScreenWidth/2-60, 20)];
//    _titleLable.text = @"中宁物流";
    _titleLable.font = [UIFont systemFontOfSize:14.0];
    [backview addSubview:_titleLable];

    
    UIImageView *fromImaV = [[UIImageView alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+20+20, 12, 12)];
    fromImaV.image= kImageName(@"from.png");
    [_titleView addSubview:fromImaV];
    
    _fromCity = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2+12+10, topSpace+20+15,  cityWidth, 20)];
//    _fromCity.font = [UIFont boldSystemFontOfSize:20];
    [_titleView addSubview:_fromCity];

    
    _fromPort=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+10, topSpace+20+10+20+5, PortWidth, 20)];
    _fromPort.font=[UIFont systemFontOfSize:14];
    _fromPort.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:_fromPort];

    
    UIImageView *jianTou= [[UIImageView alloc]initWithFrame:CGRectMake(0, 20+10+15, jianTouWidth, 3)];
    jianTou.center = CGPointMake(kScreenWidth/2, 70);
    jianTou.image = kImageName(@"jianTou.png");
    [_titleView addSubview:jianTou];
    
    UIImageView *toImaV=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+20+20, 12, 12)];
    toImaV.image=kImageName(@"to.png");
    [_titleView addSubview:toImaV];
    
    _toCity = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2+12+10, topSpace+20+15, cityWidth, 20)];
//    _toCity.font = [UIFont boldSystemFontOfSize:20];
    [_titleView addSubview:_toCity];

    
    _toPort = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+20+10+20+5, PortWidth, 20)];
    _toPort.textAlignment = NSTextAlignmentCenter;
    _toPort.font = [UIFont systemFontOfSize:14];
    [_titleView addSubview:_toPort];

    
    UIView *hLine = [[UIView alloc]initWithFrame:CGRectMake(0, topSpace+20+10+20+20+4+5, kScreenWidth, 1)];
    hLine.backgroundColor=kColor(201, 201, 201, 1);;
    [_titleView addSubview:hLine];
    
    _price = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+20+10+20+20+4+5+5, 100, 20)];
    _price.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_price];
    _price.textColor=kColor(251, 115, 0, 1);

    _weight = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+20+10+20+20+4+5+5, 100, 20)];
    _weight.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:_weight];
    _weight.textColor=kColor(251, 115, 0, 1);
    
    _loadTime = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+20+10+20+20+4+5+20+5, PortWidth, 20)];
    _loadTime.font = [UIFont systemFontOfSize:10];
    _loadTime.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_loadTime];

    _goods = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+20+10+20+20+4+1+5+20+5, PortWidth, 20)];
    _goods.font=[UIFont systemFontOfSize:12];
    _goods.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:_goods];

    UIView *vLine = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2+4, topSpace+20+10+20+20+4+5+5, 1, 40)];
    vLine.backgroundColor = kColor(201, 201, 201, 1);;
    [_titleView addSubview:vLine];
    UIView *lastline = [[UIView alloc]initWithFrame:CGRectMake(0,topSpace+20+10+20+20+4+1+5+20+5+20+5, kScreenWidth, 1)];
    lastline.backgroundColor = kColor(201, 201, 201, 1);;
    [_titleView addSubview:lastline];
    

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 142, kScreenWidth, kScreenHeight-142-110) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];


}
#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_levelstatus intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"transportingIdentifier";

    TransportingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TransportingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(indexPath.row == 0)
    {
        NSString *selectstrings=[NSString stringWithFormat:@"imageHeight%@",_levelstatus];
        cell.selectButton.enabled = YES;

        [cell.selectButton setBackgroundImage:kImageName(selectstrings) forState:UIControlStateNormal];
    }else
    {
        
        int selectimage;
        selectimage = [_levelstatus intValue]- indexPath.row;
                       
        NSString *selectstring=[NSString stringWithFormat:@"imageNormal%d",selectimage];

        [cell.selectButton setBackgroundImage:kImageName(selectstring) forState:UIControlStateNormal];
        cell.selectButton.enabled = NO;
        
    }
    if ([_levelstatus intValue]==5) {
        if (indexPath.row == 1||indexPath.row == 3) {
            cell.modifyButton.hidden=NO;
            
        }
        else
        {
            cell.modifyButton.hidden = YES;
            
        }
        
    }
    if ([_levelstatus intValue] < 5&&[_levelstatus intValue]>2) {
        
        if (indexPath.row==[_levelstatus intValue]-2)
        {
            cell.modifyButton.hidden = NO;

        }
        else
        {
            cell.modifyButton.hidden = YES;

        }

    }
    if ([_levelstatus intValue] < ArriveUnloading) {
        cell.modifyButton.hidden = YES;

    }
    cell.detailLabel.text = [_dataItem objectAtIndex:indexPath.row];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modifyButton.tag = indexPath.row;
    
    [cell.modifyButton addTarget:self action:@selector(nextview:) forControlEvents:UIControlEventTouchUpInside];
    [cell.selectButton addTarget:self action:@selector(selectclick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - Request

- (void)downloadGoodDetail
{
   

//    [self loadDetails];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetWorkInterface getdetailsWithloginid:[userDefault objectForKey:@"loginId"] finished:^(BOOL success, NSData *response) {
        
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    
                    [hud hide:YES];
                    [_dataItem removeAllObjects];
                    [_titleView removeFromSuperview];
                    
                    [self initAndlayoutUI];
                    [self parseTerminalListWithDictionary:object];
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
- (void)parseTerminalListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    _levelstatus=[[dict objectForKey:@"result"] objectForKey:@"level"];
    
    _ids=[[dict objectForKey:@"result"] objectForKey:@"id"];
    
     TransportingModel *model = [[TransportingModel alloc] initWithParseDictionary:[dict objectForKey:@"result"]];
    _titleLable.text = model.title;
    _fromCity.text = model.fromCity;
    _fromPort.text = model.fromPort;
    _toCity.text = model.toCity;
    _toPort.text = model.toPort;
    _price.text = [NSString stringWithFormat:@"%@ 元",model.price];
    _weight.text = [NSString stringWithFormat:@"%@ 吨",model.weight];;
    _loadTime.text = model.loadTime;
    _goods.text = model.goods;
    _fromPort.text = model.beginDockName;
    _toCity.text = model.ePortName;
    if ([_levelstatus integerValue] == 1) {
        _dataItem = [NSMutableArray arrayWithObjects:@"", nil];
        
    }
    if ([_levelstatus integerValue] == 2) {
_dataItem = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"我于%@到达装货港",model.toBPortTimeStr], nil];
    }
    if ([_levelstatus integerValue] == 3) {
_dataItem = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"我于%@装货%@吨",model.inWriteTimeStr,model.weight],[NSString stringWithFormat:@"我于%@到达装货港",model.toBPortTimeStr], nil];
    }
    if ([_levelstatus integerValue] == 4) {
_dataItem = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"我于%@到达卸货港",model.toEPortTimeStr],[NSString stringWithFormat:@"我于%@装货%@吨",model.inWriteTimeStr,model.weight],[NSString stringWithFormat:@"我于%@到达装货港",model.toBPortTimeStr], nil];
    }
    if ([_levelstatus integerValue] == 5) {
_dataItem = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"我于%@卸货%@吨",model.outWriteTimeStr,model.weight],[NSString stringWithFormat:@"我于%@到达卸货港",model.toEPortTimeStr],[NSString stringWithFormat:@"我于%@装货%@吨",model.inWriteTimeStr,model.weight],[NSString stringWithFormat:@"我于%@到达装货港",model.toBPortTimeStr], nil];
    }
    
    
    [_tableView reloadData];
    

}
- (void)refreshList:(NSNotification *)notification {
    [self downloadGoodDetail];
}
- (void)selectclick:(UIButton *)send
{
    if([_levelstatus intValue] == Loading||[_levelstatus intValue] == Unloading)
    {
        LoadGoodsViewController *loadview = [[LoadGoodsViewController alloc]init];
        loadview.index = [_levelstatus intValue];
        loadview.shipRelationID = [_ids intValue];
        loadview.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:loadview animated:YES];

    
    }
    else
    {
        NSString *type ;
        if([_levelstatus intValue] == ArriveLoading)
        {
        
        type = @"2";
        
        }
        else
        {
            type = @"1";

        }
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        NSString*coordinate = [NSString stringWithFormat:@"%@,%@",[userDefault objectForKey:@"latitude"],[userDefault objectForKey:@"longitude"]];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"加载中...";
        [NetWorkInterface signWithid:_ids type:type loginid:[userDefault objectForKey:@"loginId"] coordimate:coordinate finished:^(BOOL success, NSData *response) {
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:0.5f];
            if (success) {
                id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSString *errorCode = [object objectForKey:@"code"];
                    if ([errorCode intValue] == RequestFail) {
                        //返回错误代码
                        hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    }
                    else if ([errorCode intValue] == RequestSuccess) {
                        [hud hide:YES];
                        [self downloadGoodDetail];
                        
                        //                [self parseGoodDetailDateWithDictionary:object];
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
    
}
#pragma mark - Action
- (void)leftClick:(id)send
{
    DetailsListViewController *detailsV = [[DetailsListViewController alloc]init];
    detailsV.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:detailsV animated:YES];
    

}

- (void)nextview:(UIButton *)sender
{
    LoadGoodsViewController *loadview = [[LoadGoodsViewController alloc]init];
    if ([_levelstatus intValue] == Complete) {
        if(sender.tag == 1)
        {
            loadview.index = 4;
        }
        if(sender.tag == 3)
        {
            loadview.index = 2;
        }

    }
    if ([_levelstatus intValue] < Complete) {
     
            loadview.index = 2;

    }
    loadview.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:loadview animated:YES];
    

}
- (IBAction)showRight:(id)sender
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
