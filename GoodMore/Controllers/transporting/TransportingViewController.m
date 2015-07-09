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

@property(nonatomic,strong)UILabel *goods;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TransportingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"运输任务";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithImage:kImageName(@"head_small.png") style:UIBarButtonItemStyleDone target:self action:@selector(showRight:)];
//    self.navigationItem.rightBarButtonItem=rightItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:kImageName(@"personal.png") style:UIBarButtonItemStyleDone target:self action:@selector(showRight:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;

    
    [self initAndlayoutUI];
    
}
#pragma mark - UI
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
    _titleLable.text = @"中宁物流";
    _titleLable.font = [UIFont systemFontOfSize:14.0];
    [backview addSubview:_titleLable];

    
    UIImageView *fromImaV = [[UIImageView alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+20+20, 12, 12)];
    fromImaV.image= kImageName(@"from.png");
    [_titleView addSubview:fromImaV];
    
    _fromCity = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2+12+10, topSpace+20+15,  cityWidth, 20)];
//    _fromCity.font = [UIFont boldSystemFontOfSize:20];
    [_titleView addSubview:_fromCity];
    _fromCity.text = @"南通";

    
    _fromPort=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace+10, topSpace+20+10+20+5, PortWidth, 20)];
    _fromPort.font=[UIFont systemFontOfSize:14];
    _fromPort.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:_fromPort];
    _fromPort.text = @"马达加斯加";

    
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
    _toCity.text = @"芜湖";

    
    _toPort = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace, topSpace+20+10+20+5, PortWidth, 20)];
    _toPort.textAlignment = NSTextAlignmentCenter;
    _toPort.font = [UIFont systemFontOfSize:14];
    [_titleView addSubview:_toPort];
    _toPort.text = @"安达曼";

    
    UIView *hLine = [[UIView alloc]initWithFrame:CGRectMake(0, topSpace+20+10+20+20+4+5, kScreenWidth, 1)];
    hLine.backgroundColor=kColor(201, 201, 201, 1);;
    [_titleView addSubview:hLine];
    
    _price = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+20+10+20+20+4+5+5, 100, 20)];
    _price.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_price];
    _price.text = @"12.00元";
    _price.textColor=kColor(251, 115, 0, 1);

    _weight = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+20+10+20+20+4+5+5, 100, 20)];
    _weight.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:_weight];
    _weight.text = @"2000 吨";
    _weight.textColor=kColor(251, 115, 0, 1);
    
    _loadTime = [[UILabel alloc]initWithFrame:CGRectMake(leftSpace*2, topSpace+20+10+20+20+4+5+20+5, PortWidth, 20)];
    _loadTime.font = [UIFont systemFontOfSize:10];
    _loadTime.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_loadTime];
    _loadTime.text = @"2015年12月7日装船";

    _goods = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2+leftSpace*2, topSpace+20+10+20+20+4+1+5+20+5, PortWidth, 20)];
    _goods.font=[UIFont systemFontOfSize:12];
    _goods.textAlignment=NSTextAlignmentCenter;
    [_titleView addSubview:_goods];
    _goods.text = @"水泥";

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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"transportingIdentifier";

    TransportingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TransportingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(indexPath.row==0)
    {
        
        [cell.selectButton setBackgroundImage:kImageName(@"imageHeight2") forState:UIControlStateNormal];
    }else
    {
        NSString *selectstring=[NSString stringWithFormat:@"imageNormal%d",indexPath.row];

        [cell.selectButton setBackgroundImage:kImageName(selectstring) forState:UIControlStateNormal];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.modifyButton addTarget:self action:@selector(nextview:) forControlEvents:UIControlEventTouchUpInside];
    
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
#pragma mark - Action
- (void)nextview:(UIButton*)sender
{
    LoadGoodsViewController *loadview = [[LoadGoodsViewController alloc]init];
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
