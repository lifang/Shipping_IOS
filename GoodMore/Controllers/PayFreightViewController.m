//
//  PayFreightViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/25.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "PayFreightViewController.h"
#import "Constants.h"
#import "ShipListModel.h"
#import "ShipInfoCell.h"
#import "ShipInfoCell1.h"
#import "MBProgressHUD.h"
#import "NetWorkInterface.h"

@interface PayFreightViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UITableView *_list;
    UILabel *_Pay;
    UIView *_backView;
    UIView *_divideBackView;//分配金额
    UILabel *_noPaylabel;
    UITextField *_number;
    NSMutableArray *_localData;
    //NSMutableArray *_test1;
}
@property(nonatomic,assign)int noPay;//记录当前的未分配的金额
@property(nonatomic,strong)UIButton *currentButton;
@end

@implementation PayFreightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"结算运费";
    //初始化一个本地数据数组
    [self initloaclData];
    [self initAndLayoutUI];
    [self surePayfreight];
    [self initBackView];
    _backView.hidden=YES;
    //_divideBackView.hidden=YES;
    
    _noPay=[_paidMoney intValue];
    
}
-(void)initloaclData
{
    _localData=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<_shipListArray.count; i++)
    {
        NSString *num=@"";
        [_localData addObject:num];
    }
}
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=80;
    _tableView.tag=10086;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self setHeadAndFootView];
    [self.view addSubview:_tableView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

}
-(void)setHeadAndFootView
{
    
    CGFloat leftSpace=20;
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.25)];
    UIView *blueView=[[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, headView.bounds.size.height-24)];
    blueView.backgroundColor=kMainColor;
    //￥
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=CGRectMake(leftSpace, blueView.bounds.size.height/2-15, kScreenWidth-leftSpace*2, 30);
    label1.text=[NSString stringWithFormat:@"￥%@",_paidMoney];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.font=[UIFont boldSystemFontOfSize:24];
    label1.textColor=[UIColor whiteColor];
    [blueView addSubview:label1];
    _Pay=[[UILabel alloc]init];
    _Pay.frame=CGRectMake(leftSpace*4+30, (blueView.bounds.size.height-60)/2, kScreenWidth-leftSpace*2-leftSpace*4-30, 60);
    _Pay.textColor=[UIColor whiteColor];
    _Pay.font=[UIFont boldSystemFontOfSize:36];
    [blueView addSubview:_Pay];
    [headView addSubview:blueView];
    UILabel *shipPartIn=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(blueView.bounds)+5, 100, 13)];
    shipPartIn.text=@"参与船舶";
    shipPartIn.textColor=kGrayColor;
    shipPartIn.font=[UIFont systemFontOfSize:13];
    [headView addSubview:shipPartIn];
    
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(shipPartIn.bounds)+5, kScreenWidth-20, 1)];
    line.translatesAutoresizingMaskIntoConstraints=NO;
    line.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:headView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth]];
    [headView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
    _tableView.tableHeaderView=headView;
    
}
-(void)surePayfreight
{
    UIView *tabBar=[[UIView alloc]init];
    tabBar.translatesAutoresizingMaskIntoConstraints=NO;
    tabBar.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tabBar];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:61]];
    
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line.translatesAutoresizingMaskIntoConstraints=NO;
    line.backgroundColor=kColor(201, 201, 201, 1);
    [tabBar addSubview:line];
    
    _noPaylabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, (kScreenWidth-20)*0.7, 40)];
    
    _noPaylabel.text=[NSString stringWithFormat:@"未分配金额:￥%@",_paidMoney];
    _noPaylabel.font=[UIFont systemFontOfSize:15];
    //_noPaylabel.textAlignment=NSTextAlignmentCenter;
    _noPaylabel.textColor=[UIColor blackColor];
    [tabBar addSubview:_noPaylabel];
    
    UIButton *SurePay=[UIButton buttonWithType:UIButtonTypeCustom];
    SurePay.frame=CGRectMake(kScreenWidth-10-(kScreenWidth-20)*0.3, 10, (kScreenWidth-20)*0.3, 40);
    SurePay.layer.cornerRadius=4;
    SurePay.layer.masksToBounds=YES;
    [SurePay setTitle:@"确认" forState:UIControlStateNormal];
    [SurePay setBackgroundColor:kMainColor];
    [SurePay addTarget:self action:@selector(SurePay:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:SurePay];
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
    
    UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake((width-width*0.8)/2, 100, width*0.8, height*0.4)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [_backView addSubview:whiteView];
    
    UILabel *title=[[UILabel alloc]init];
    title.font=[UIFont systemFontOfSize:16];
    title.text=@"请再次确认以下船舶获得运费";
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=[UIColor blackColor];
    title.frame=CGRectMake(leftSpace, topSpace, whiteView.bounds.size.width-leftSpace*2, 30);
    [whiteView addSubview:title];
    
    _list=[[UITableView alloc]initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(title.frame)+10, width*0.8-leftSpace*2, height*0.4-topSpace-30-30-bottomSpace-10-10)];
    _list.dataSource=self;
    _list.delegate=self;
    _list.rowHeight=30;
    _list.tag=10087;
    _list.tableFooterView=[[UIView alloc]init];
    [whiteView addSubview:_list];
    
    UIButton *cancelBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBTN.frame=CGRectMake(2*leftSpace, height*0.4-bottomSpace-30, 60, 30);
    [cancelBTN setTitle:@"取消" forState:UIControlStateNormal];
    cancelBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [cancelBTN setTitleColor:[self colorWithHexString:@"757474"] forState:UIControlStateNormal];
    [cancelBTN addTarget:self action:@selector(cancelBTN:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelBTN];
    
    UIButton *sureBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBTN.frame=CGRectMake(width*0.8-rightSpace-60-rightSpace, height*0.4-bottomSpace-30, 60, 30);
    sureBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [sureBTN setTitle:@"确定" forState:UIControlStateNormal];
    [sureBTN setTitleColor:[self colorWithHexString:@"757474"] forState:UIControlStateNormal];
    [sureBTN addTarget:self action:@selector(sureBTN:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:sureBTN];
}
//设置分配金额
-(void)showPayMoneyWith:(NSInteger)index
{
    CGFloat width=kScreenWidth;
    CGFloat height=kScreenHeight;
    CGFloat leftSpace=20;
    CGFloat rightSpace=20;
    CGFloat topSpace=20;
    CGFloat bottomSpace=20;
    //CGFloat vSpace=5;
    
    _divideBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _divideBackView.backgroundColor=[UIColor colorWithRed:95/255.0 green:114/255.0 blue:114/255.0 alpha:0.5];
    [self.view addSubview:_divideBackView];
    
    UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake((width-width*0.8)/2, 100, width*0.8, height*0.3)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [_divideBackView addSubview:whiteView];
    
    UILabel *title=[[UILabel alloc]init];
    title.font=[UIFont systemFontOfSize:16];
    title.text=@"请输入分配金额:";
    title.textColor=[UIColor blackColor];
    title.frame=CGRectMake(leftSpace, topSpace, whiteView.bounds.size.width-leftSpace*2, 30);
    [whiteView addSubview:title];
    
    _number=[[UITextField alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+topSpace/2, whiteView.bounds.size.width-leftSpace*2, 30)];
    //_number.backgroundColor=kColor(169, 179, 179, 0.5);
    _number.delegate=self;
    _number.keyboardType=UIKeyboardTypeNumberPad;
    _number.placeholder=@"请输入分配金额";
     _number.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    
    _number.clearButtonMode=UITextFieldViewModeWhileEditing;
    _number.leftViewMode=UITextFieldViewModeAlways;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
    _number.leftView=view;
    _number.layer.cornerRadius=0;
    _number.layer.borderColor=[UIColor grayColor].CGColor;
    _number.layer.borderWidth=1;
    [whiteView addSubview:_number];
    
    UIButton *cancelBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBTN.frame=CGRectMake(2*leftSpace, height*0.3-bottomSpace-30, 60, 30);
    [cancelBTN setTitle:@"取消" forState:UIControlStateNormal];
    cancelBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [cancelBTN setTitleColor:[self colorWithHexString:@"757474"] forState:UIControlStateNormal];
    [cancelBTN addTarget:self action:@selector(divideCancelBTN:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelBTN];
    
    UIButton *sureBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBTN.tag=index;
    sureBTN.frame=CGRectMake(width*0.8-rightSpace-60-rightSpace, height*0.3-bottomSpace-30, 60, 30);
    sureBTN.titleLabel.font=[UIFont systemFontOfSize:16];
    [sureBTN setTitle:@"确定" forState:UIControlStateNormal];
    [sureBTN setTitleColor:[self colorWithHexString:@"757474"] forState:UIControlStateNormal];
    [sureBTN addTarget:self action:@selector(divideSureBTN:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark ----action-----

-(void)SurePay:(UIButton*)button
{
    
    _backView.hidden=NO;
    [_list reloadData];
}
-(void)cancelBTN:(UIButton*)button
{
    _backView.hidden=YES;
}
//确认运费分配
-(void)sureBTN:(UIButton*)button
{
    _backView.hidden=YES;
    [self setEveryShipPay];
}
//设置运费
-(void)setFreight:(UIButton*)sender
{
    _currentButton=sender;
    [self showPayMoneyWith:sender.tag];
    
}
//重设运费
-(void)refreshSetFreight:(UIButton*)sender
{
    _currentButton=sender;
    [self showPayMoneyWith:sender.tag];
}
-(void)divideCancelBTN:(UIButton*)sender
{
    [_divideBackView removeFromSuperview];
}
-(void)divideSureBTN:(UIButton*)sender
{
    
    if ([_currentButton.titleLabel.text isEqualToString:@"设置运费"])
    {
        NSArray *array=[_noPaylabel.text componentsSeparatedByString:@"￥"];
        NSString *noPay=array[1];
        if ([_number.text intValue]>[noPay intValue])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"超过未分配金额";
            
        }else
        {
            [_localData replaceObjectAtIndex:sender.tag withObject:_number.text];
            _noPay=_noPay-[_number.text intValue];
            _noPaylabel.text=[NSString stringWithFormat:@"未分配金额:￥%d",_noPay];
            _noPaylabel.font=[UIFont systemFontOfSize:15];
            [_tableView reloadData];
            [_divideBackView removeFromSuperview];
        }

        
    }else if ([_currentButton.titleLabel.text isEqualToString:@"重设运费"])
    {
        //把先前设置的扔回来
        NSString *str=_localData[_currentButton.tag];
        //NSLog(@"--------先前的-----%@",str);
        int noPay=_noPay + [str intValue];
        //NSLog(@"----------点击重设--%d",noPay);
        //再减去重新设置的金额
        //_noPay=noPay - [_number.text intValue];
        _noPaylabel.text=[NSString stringWithFormat:@"未分配金额:￥%d",noPay];
        
        NSArray *array=[_noPaylabel.text componentsSeparatedByString:@"￥"];
        NSString *noPay1=array[1];
        if ([_number.text intValue]>[noPay1 intValue])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"超过未分配金额";
            _noPaylabel.text=[NSString stringWithFormat:@"未分配金额:￥%d",_noPay];
            
        }else
        {
//            //把先前设置的扔回来
//            NSString *str=_localData[_currentButton.tag];
//            //NSLog(@"--------先前的-----%@",str);
//            int noPay=_noPay + [str intValue];
//            //NSLog(@"----------点击重设--%d",noPay);
//            //再减去重新设置的金额
            
            _noPay=noPay - [_number.text intValue];
            //NSLog(@"--------最新的-----%@",str);
            
            [_localData replaceObjectAtIndex:sender.tag withObject:_number.text];
            _noPaylabel.text=[NSString stringWithFormat:@"未分配金额:￥%d",_noPay];
            _noPaylabel.font=[UIFont systemFontOfSize:15];
            [_tableView reloadData];
            [_divideBackView removeFromSuperview];
 
        }
        
    }
    
}
#pragma mark 发送分配运费
-(void)setEveryShipPay
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"分配中...";
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    int loginId=[[userDefault objectForKey:@"loginId"] intValue];
    
    
    NSMutableArray *data=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<_shipListArray.count; i++)
    {
        ShipListModel *shipModel=_shipListArray[i];
        NSString *moneyNum=_localData[i];
        NSString *str=[NSString stringWithFormat:@"%@_%@",shipModel.ID,moneyNum];
        [data addObject:str];
    }
    
    NSString *shipSetStr=@"";
    for (int i=0; i<data.count; i++)
    {
        NSString *value = [NSString stringWithFormat:@"%@",data[i]];
        if (i==0)
        {
            shipSetStr = [shipSetStr stringByAppendingString:value];
            
        }
        else {
            shipSetStr = [shipSetStr stringByAppendingString:[NSString stringWithFormat:@"|%@",value]];
        }
        
    }

    NSLog(@"请求参数:%@",shipSetStr);
    
    [NetWorkInterface setPayEveryShipWithshipTeamId:[_shipTeamID intValue] loginId:loginId shipSetStr:shipSetStr finished:^(BOOL success, NSData *response) {

        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------分配船队运费:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    [hud setHidden:YES];
                    //[self parseDataWithDictionary:object];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"分配运费成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alert show];
                    
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

#pragma mark ---UITableView-----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==10086)
    {
        return _shipListArray.count;
    }else
    {
        return _shipListArray.count;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView.tag==10086)
    {
       ShipListModel *shipModel=_shipListArray[indexPath.row];
        
    
        
        NSString *number=_localData[indexPath.row];
        if (number && ![number isEqualToString:@""])
        {
            
            //已设置运费
            NSString *cellIdentifier=@"payFreigh1";
            ShipInfoCell1 *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell==nil)
            {
                cell=[[ShipInfoCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
           
            
            if ([shipModel.isLeader intValue]==1)
            {
                cell.headImageView.image=kImageName(@"headShip.png");
            }else{
                cell.headImageView.hidden=YES;
            }

            cell.ship.text=shipModel.shipName;
            cell.person.text=shipModel.name;
            cell.weight.text=[NSString stringWithFormat:@"%@吨",shipModel.volume];
            cell.weight.textColor=kGrayColor;
            cell.phone.text=shipModel.phone;
            cell.phone.textColor=kGrayColor;
            cell.money.text=_localData[indexPath.row];
            cell.money.textAlignment=NSTextAlignmentCenter;
            [cell.button setTitle:@"重设运费" forState:UIControlStateNormal];
            cell.button.tag=indexPath.row;
            cell.button.titleLabel.font=[UIFont systemFontOfSize:12];
            [cell.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [cell.button addTarget:self action:@selector(refreshSetFreight:) forControlEvents:UIControlEventTouchUpInside];
            return cell;

            
        }else
        {
            
            //ShipListModel *shipModel=_shipListArray[indexPath.row];
            NSString *cellIdentifier=@"payFreigh";
            ShipInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell==nil)
            {
                cell=[[ShipInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            if ([shipModel.isLeader intValue]==1)
            {
                cell.headImageView.image=kImageName(@"headShip.png");
            }else
            {
                cell.headImageView.hidden=YES;
            }
            
            cell.ship.text=shipModel.shipName;
            cell.person.text=shipModel.name;
            cell.weight.text=[NSString stringWithFormat:@"%@吨",shipModel.volume];
            cell.weight.textColor=kGrayColor;
            cell.phone.text=shipModel.phone;
            cell.phone.textColor=kGrayColor;
            cell.button.tag=indexPath.row;
            [cell.button setTitle:@"设置运费" forState:UIControlStateNormal];
            cell.button.titleLabel.font=[UIFont systemFontOfSize:14];
            [cell.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [cell.button addTarget:self action:@selector(setFreight:) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }
        
        
    }else
    {
        
        NSString *cellIdentifier=@"list";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        ShipListModel *shipModel=_shipListArray[indexPath.row];
        cell.textLabel.text=shipModel.shipName;
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        cell.textLabel.textColor=kGrayColor;
        cell.detailTextLabel.text=_localData[indexPath.row];
       
        return cell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark UITextFieldDelegate 
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
