//
//  PayForShipController.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "PayForShipController.h"
#import "MyShipModel.h"
#import "PayNumberCell.h"

@interface PayForShipController ()<UITableViewDataSource,UITableViewDelegate,PayNumberCellDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)double allPay;

@property(nonatomic,assign)double nowPay;

@property(nonatomic,strong)UILabel *undistributedLabel;

@property(nonatomic,strong)UIImageView *backView;

@property(nonatomic,strong)UITextField *payTextField;

@property(nonatomic,strong)NSMutableArray *selectedIndexArray;

@property(nonatomic,strong)NSMutableDictionary *moneyDic;

@property(nonatomic,strong)NSMutableDictionary *reMoneyDic;

@property(nonatomic,strong)NSMutableDictionary *MoneyDataDic;


@end

@implementation PayForShipController

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(0, 80, K_MainWidth, K_MainHeight - 200);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算运费";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    _selectedIndexArray = [[NSMutableArray alloc]init];
    _moneyDic = [[NSMutableDictionary alloc]init];
    _reMoneyDic = [[NSMutableDictionary alloc]init];
    _MoneyDataDic = [[NSMutableDictionary alloc]init];
    
    int allPay  = 0;
    for (NSInteger i = 0; i < _contentArray.count; i++) {
        ShipInTeam *shipInTeamModel = [_contentArray objectAtIndex:i];
        [_selectedIndexArray addObject:[NSNumber numberWithInteger:i]];
        allPay = allPay +  [shipInTeamModel.defaultMoney intValue];
        NSString *selected = [NSString stringWithFormat:@"%ld",i];
        NSString *money = [NSString stringWithFormat:@"￥%@",shipInTeamModel.defaultMoney];
        [_moneyDic setObject:money forKey:selected];
        [_reMoneyDic setObject:[NSNumber numberWithInt:[shipInTeamModel.defaultMoney intValue]] forKey:selected];
        [self.tableView reloadData];
    }
    
    _allPay = _shipOrderModel.allPay - allPay;
    UILabel *blueTopLabel = [[UILabel alloc]init];
    blueTopLabel.textColor = [UIColor whiteColor];
    blueTopLabel.textAlignment = NSTextAlignmentCenter;
    blueTopLabel.backgroundColor = kLightColor;
    blueTopLabel.font = [UIFont systemFontOfSize:25];
    blueTopLabel.text = [NSString stringWithFormat:@"￥%.2f",_shipOrderModel.allPay];
    blueTopLabel.frame = CGRectMake(0, 1, K_MainWidth, 80);
    [self.view addSubview:blueTopLabel];
    
    _undistributedLabel = [[UILabel alloc]init];
    _undistributedLabel.textColor = [UIColor blackColor];
    _undistributedLabel.backgroundColor = [UIColor clearColor];
    _undistributedLabel.text = [NSString stringWithFormat:@"未分配金额:￥%.2f",_allPay];
    _undistributedLabel.font = [UIFont systemFontOfSize:16];
    _undistributedLabel.frame = CGRectMake(20, K_MainHeight - 120, 200, 40);
    [self.view addSubview:_undistributedLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(188, 188, 188, 0.7);
    line.frame = CGRectMake(0, _undistributedLabel.frame.origin.y, K_MainWidth, 1);
    [self.view addSubview:line];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn addTarget:self action:@selector(tikuanClicked) forControlEvents:UIControlEventTouchUpInside];
    CALayer *readBtnLayer = [sureBtn layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:3.0];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"lanse"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(K_MainWidth / 2 + 60, line.frame.origin.y + 5, K_MainWidth / 4, 40);
    [self.view addSubview:sureBtn];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selected = 0;
    for (int i = 0; i < _selectedIndexArray.count; i++) {
        selected = [[_selectedIndexArray objectAtIndex:i] integerValue];
        if (_selectedIndexArray.count != 0 && selected == indexPath.row) {
            
            ShipInTeam *shipInTeamModel = [_contentArray objectAtIndex:indexPath.row];
            PayNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell2"];
            cell = [[PayNumberCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"payCell2"];
            [cell setPayNumContentWithShipInTeamModel:shipInTeamModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.index = indexPath;
            cell.setBtn.hidden = YES;
            cell.priceLabel.hidden = NO;
            NSString *datastr = [NSString stringWithFormat:@"%@_%@",shipInTeamModel.ID,[_reMoneyDic objectForKey:[NSString stringWithFormat:@"%ld",selected]]];
            [_MoneyDataDic setObject:datastr forKey:[NSString stringWithFormat:@"%ld",selected]];
            cell.priceLabel.text = [_moneyDic objectForKey:[NSString stringWithFormat:@"%ld",selected]];
            cell.delegate = self;
            return cell;
        }
    }
        PayNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell1"];
        cell = [[PayNumberCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"payCell1"];
        ShipInTeam *shipInTeamModel = [_contentArray objectAtIndex:indexPath.row];
        [cell setPayNumContentWithShipInTeamModel:shipInTeamModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.resetBtn.hidden = YES;
        cell.index = indexPath;
        cell.delegate = self;
        return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *fistV = [[UIView alloc]init];
    fistV.frame = CGRectMake(0, 0, K_MainWidth, 30);
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.font = [UIFont systemFontOfSize:13];
    firstLabel.text =@"参与船舶";
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

-(void)setClickedWithIndex:(NSIndexPath *)index{
    [self setPriceViewWithIndex:index];
}

-(void)resetClickedWithIndex:(NSIndexPath *)index {
    [self setrePriceViewWithIndex:index];
}

-(void)cancelClicked {
    [_backView removeFromSuperview];
}

-(void)setPriceViewWithIndex:(NSIndexPath *)index {
    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -60, K_MainWidth, K_MainHeight + 60)];
    _backView.image = [UIImage imageNamed:@"backimage"];
    _backView.userInteractionEnabled = YES;
    [self.view addSubview:_backView];
    
    UIView *whiteV = [[UIView alloc]init];
    whiteV.backgroundColor = [UIColor whiteColor];
    whiteV.frame = CGRectMake(K_MainWidth / 7 + 10, K_MainHeight / 4, K_MainWidth / 1.5, K_MainWidth / 2.2);
    [_backView addSubview:whiteV];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"设置运费:";
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.frame = CGRectMake(10, 30, 80, 30);
    [whiteV addSubview:label];
    
    _payTextField = [[UITextField alloc]init];
    _payTextField.font = [UIFont systemFontOfSize:13];
    _payTextField.backgroundColor = [UIColor clearColor];
    _payTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, 10, 30);
    _payTextField.leftView = v;
    CALayer *readBtnLayer = [_payTextField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:4.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:kColor(188, 188, 188, 0.7).CGColor];
    _payTextField.frame = CGRectMake(CGRectGetMaxX(label.frame) - 10, label.frame.origin.x + 20, 100, 30);
    [whiteV addSubview:_payTextField];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 30, whiteV.frame.size.width /2, 20);
    [whiteV addSubview:cancelBtn];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.tag = index.row;
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClicked:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(whiteV.frame.size.width /2, CGRectGetMaxY(label.frame) + 30, whiteV.frame.size.width /2,20);
    [whiteV addSubview:sureBtn];
}

-(void)setrePriceViewWithIndex:(NSIndexPath *)index {
    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -60, K_MainWidth, K_MainHeight + 60)];
    _backView.image = [UIImage imageNamed:@"backimage"];
    _backView.userInteractionEnabled = YES;
    [self.view addSubview:_backView];
    
    UIView *whiteV = [[UIView alloc]init];
    whiteV.backgroundColor = [UIColor whiteColor];
    whiteV.frame = CGRectMake(K_MainWidth / 7 + 10, K_MainHeight / 4, K_MainWidth / 1.5, K_MainWidth / 2.2);
    [_backView addSubview:whiteV];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"重置运费:";
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.frame = CGRectMake(10, 30, 80, 30);
    [whiteV addSubview:label];
    
    _payTextField = [[UITextField alloc]init];
    _payTextField.font = [UIFont systemFontOfSize:13];
    _payTextField.backgroundColor = [UIColor clearColor];
    _payTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, 10, 30);
    _payTextField.leftView = v;
    CALayer *readBtnLayer = [_payTextField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:4.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:kColor(188, 188, 188, 0.7).CGColor];
    _payTextField.frame = CGRectMake(CGRectGetMaxX(label.frame) - 10, label.frame.origin.x + 20, 100, 30);
    [whiteV addSubview:_payTextField];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 30, whiteV.frame.size.width /2, 20);
    [whiteV addSubview:cancelBtn];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.tag = index.row;
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(resureClicked:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(whiteV.frame.size.width /2, CGRectGetMaxY(label.frame) + 30, whiteV.frame.size.width /2,20);
    [whiteV addSubview:sureBtn];
}

-(void)resureClicked:(UIButton *)button {
    
    NSString *selected = [NSString stringWithFormat:@"%ld",button.tag];
    NSLog(@"%d",[[_reMoneyDic objectForKey:selected] intValue]);
    _nowPay = _allPay - [_payTextField.text doubleValue] + [[_reMoneyDic objectForKey:selected] intValue];
    if (_nowPay < 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"对不起，可分配金额不足！";
        [hud hide:YES afterDelay:1.0f];
        return;
    }
    _allPay = _nowPay;
    _undistributedLabel.text = [NSString stringWithFormat:@"未分配金额:￥%.2f",_allPay];
    [_backView removeFromSuperview];
    
    NSString *money = [NSString stringWithFormat:@"￥%@",_payTextField.text];
    [_moneyDic setObject:money forKey:selected];
    [_reMoneyDic setObject:[NSNumber numberWithInt:[_payTextField.text intValue]] forKey:selected];
    [self.tableView reloadData];
}


-(void)sureClicked:(UIButton *)button{
    if ([_payTextField.text doubleValue] > _allPay) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"对不起，可分配金额不足！";
        [hud hide:YES afterDelay:1.0f];
        return;
    }
    NSLog(@"%d",button.tag);
    NSLog(@"%@",[NSNumber numberWithInteger:button.tag]);
    [_selectedIndexArray addObject:[NSNumber numberWithInteger:button.tag]];
    NSString *selected = [NSString stringWithFormat:@"%ld",button.tag];
    NSString *money = [NSString stringWithFormat:@"￥%@",_payTextField.text];
    [_moneyDic setObject:money forKey:selected];
    [_reMoneyDic setObject:[NSNumber numberWithInt:[_payTextField.text intValue]] forKey:selected];
    [self.tableView reloadData];
    
    _nowPay = _allPay - [_payTextField.text doubleValue];
    _allPay = _nowPay;
    
    _undistributedLabel.text = [NSString stringWithFormat:@"未分配金额:￥%.2f",_allPay];
    [_backView removeFromSuperview];
}

-(void)tikuanClicked {
    if (!_allPay == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"对不起，请分配所有余款！";
        [hud hide:YES afterDelay:0.3f];
        return;
    }
    [self AllocationRequest];
}
#pragma mark -- Request
-(void)AllocationRequest {
    NSLog(@"%@",_MoneyDataDic);
    NSString *shipSetStr=@"";
    for (int i=0; i<_selectedIndexArray.count; i++)
    {
        NSString *selected = [NSString stringWithFormat:@"%d",i];
        NSString *value = [NSString stringWithFormat:@"%@",[_MoneyDataDic objectForKey:selected]];
        if (i==0)
        {
            shipSetStr = [shipSetStr stringByAppendingString:value];
        }
        else {
            shipSetStr = [shipSetStr stringByAppendingString:[NSString stringWithFormat:@"|%@",value]];
        }
    }
    NSLog(@"%@",shipSetStr);
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"分配中...";
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    int loginId = [[userDefault objectForKey:@"loginId"] intValue];
    [NetWorkInterface setPayEveryShipWithshipTeamId:[_shipOrderModel.ID intValue] loginId:loginId shipSetStr:shipSetStr finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    [hud hide:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:HistoryDetailControllerRefreshNotification object:nil userInfo:nil];
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

@end
