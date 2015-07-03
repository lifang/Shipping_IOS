//
//  BankInfoViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/6/11.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "BankInfoViewController.h"
#import "Constants.h"
#import "BanksListViewController.h"
#import "NetWorkInterface.h"
#import "MBProgressHUD.h"
#import "CityModel.h"
#import "CityHandle.h"
@interface BankInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BanksListDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray *_staticDate;
    UILabel *_which;
    UILabel *_where;
    UIButton *_selectWhich;
    UITextField *_bankName;
    UIButton *_selectWhere;
    UITextField *_people;
    UITextField *_number;
    UIToolbar *_toolbar;
    UIPickerView *_pickerView;
    NSMutableArray *_province;
    NSMutableArray *_citys;
    UIButton *_commit;
    NSString *_orderId;//流水号
}
@property(nonatomic,strong)UITextField *editingField;//处于编辑状态的输入框
@property(nonatomic,strong)UIButton *downButton;//数字键盘上的完成按钮
@end

@implementation BankInfoViewController

-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"填写银行卡信息";
    [self initStaticData];
    [self initAndLayoutUI];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)initStaticData
{
    _staticDate=[[NSArray alloc]initWithObjects:@"所属银行", @"开户行名称",@"开户行所在地",@"收款人",@"卡号",nil];
    _province=[[NSMutableArray alloc]initWithCapacity:0];
    _citys=[[NSMutableArray alloc]initWithCapacity:0];
}
-(void)initAndLayoutUI
{
    _tableView=[[UITableView alloc]init];
    //_tableView.scrollEnabled=NO;
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=50;
    [self setheadAndFootView];
    [self.view addSubview:_tableView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    _which=[[UILabel alloc]init];
    _which.textAlignment=NSTextAlignmentRight;
    _which.font=[UIFont systemFontOfSize:14];
    _which.textColor=[self colorWithHexString:@"757474"];
    
    _selectWhich=[UIButton buttonWithType:UIButtonTypeCustom];
    [_selectWhich addTarget:self action:@selector(which) forControlEvents:UIControlEventTouchUpInside];
    
    _bankName=[[UITextField alloc]init];
    _bankName.font=[UIFont systemFontOfSize:14];
    _bankName.textAlignment=NSTextAlignmentRight;
    _bankName.delegate=self;
    _bankName.clearButtonMode=UITextFieldViewModeWhileEditing;
    _bankName.placeholder=@"请输入开户行名称";
    _bankName.delegate=self;
    
    _where=[[UILabel alloc]init];
    _where.text=@"请选择";
    _where.font=[UIFont systemFontOfSize:14];
    _where.textAlignment=NSTextAlignmentRight;
    _where.textColor=[self colorWithHexString:@"757474"];
   
    _selectWhere=[UIButton buttonWithType:UIButtonTypeCustom];
    [_selectWhere addTarget:self action:@selector(where) forControlEvents:UIControlEventTouchUpInside];
    
    _people=[[UITextField alloc]init];
    _people.font=[UIFont systemFontOfSize:14];
    _people.textAlignment=NSTextAlignmentRight;
    _people.delegate=self;
    _people.tag=1111;
    _people.clearButtonMode=UITextFieldViewModeWhileEditing;
    _people.placeholder=@"请输入收款人";
    _people.delegate=self;
    
    _number=[[UITextField alloc]init];
    _number.font=[UIFont systemFontOfSize:14];
    _number.textAlignment=NSTextAlignmentRight;
    _number.delegate=self;
    _number.tag=2222;
    _number.keyboardType=UIKeyboardTypeNumberPad;
    _number.clearButtonMode=UITextFieldViewModeWhileEditing;
    _number.placeholder=@"请输入卡号";
    _number.delegate=self;

    [self initPickView];
}

-(void)setheadAndFootView
{
    UIView *headView=[[UIView alloc]init];
    headView.frame=CGRectMake(0, 0, kScreenWidth, 5);
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 4, kScreenWidth, 1)];
    line1.backgroundColor=kColor(201, 201, 201, 1);
    [headView addSubview:line1];
    _tableView.tableHeaderView=headView;
    
    UIView *footView=[[UIView alloc]init];
    footView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.4);
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, 1)];
    line2.backgroundColor=kColor(201, 201, 201, 1);
    [footView addSubview:line2];
    _commit=[UIButton buttonWithType:UIButtonTypeCustom];
    _commit.frame=CGRectMake(30, 50, kScreenWidth-60, 40);
    [_commit setTitle:@"提交" forState:UIControlStateNormal];
    [_commit addTarget:self action:@selector(cashCommit:) forControlEvents:UIControlEventTouchUpInside];
    //提交前颜色
    [_commit setBackgroundColor:[self colorWithHexString:@"aacae9"]];
    _commit.userInteractionEnabled=NO;
    _commit.layer.masksToBounds=YES;
    _commit.layer.cornerRadius=2;
    [footView addSubview:_commit];
    _tableView.tableFooterView=footView;
    
}
-(void)initPickView
{
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(finishLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
    
}

#pragma mark action 

-(void)which
{
    BanksListViewController *banksList=[[BanksListViewController alloc]init];
    banksList.delegate=self;
    [self.navigationController pushViewController:banksList animated:YES];
}
-(void)where
{
    //获得省列表
    
    
}
- (IBAction)finishLocation:(id)sender {
    [self pickerScrollOut];
    NSInteger index = [_pickerView selectedRowInComponent:1];
    _where.text=[[_citys objectAtIndex:index] objectForKey:@"name"];
    [self judgeAllInfo];
}
//提现
-(void)cashCommit:(UIButton*)sender
{
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"正在提现";
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *shipOwerId=[userDefaults objectForKey:@"shipOwnerId"];
    [NetWorkInterface getCashWithshipOwerId:[shipOwerId intValue] cashNum:[_cashNum intValue]provinceCity:_where.text bankName:_which.text kuaihuhang:_bankName.text creditName:_people.text bankCardNumber:_number.text finished:^(BOOL success, NSData *response) {
     
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
                 NSLog(@"------------提现cash:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
         if (success)
         {
             id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
             if ([object isKindOfClass:[NSDictionary class]])
             {
                 if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                 {
                     [hud hide:YES];
                     
                     //hud.labelText=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                     //NSDictionary *result=[object objectForKey:@"result"];
                     if ([object objectForKey:@"result"] && [[object objectForKey:@"result"]isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *result =[object objectForKey:@"result"];
                         //NSString *message=[object objectForKey:@"message"];
                         NSNumber *code=[result objectForKey:@"code"];
                         _orderId=[result objectForKey:@"orderId"];
                         switch ([code intValue])
                         {
                             case -1:
                             {
                                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"提现失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                                 alert.tag=1;
                                 [alert show];
                             }
                                 break;
                             case 0:
                             {
                                 //刷新页面,重新提现
                                 
                                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"提现失败" delegate:self cancelButtonTitle:@"重新提现" otherButtonTitles:nil];
                                 alert.tag=2;
                                 [alert show];
                             }
                                 break;
                                 
                             default:
                                 break;
                         }

                         
                     }else
                     {
                         //成功
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"提现成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                         [alert show];
                     }
                    
                     
                 }else
                 {
                     
                 }
             }else
             {
                hud.labelText=kServiceReturnWrong;
                 [hud hide:YES afterDelay:0.3];
             }
         }else
         {
             hud.labelText=kNetworkFailed;
             [hud hide:YES afterDelay:0.3];
         }
         
     }];

}

#pragma mark ------UIPickView------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        return [[CityHandle shareProvinceList] count];
    }
    else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _citys = [provinceDict objectForKey:@"cities"];
        return [_citys count];
    }
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
    }
    else {
        //市
        return [[_citys objectAtIndex:row] objectForKey:@"name"];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
    }
    else {
        _where.text = [[_citys objectAtIndex:row] objectForKey:@"name"];
        [self judgeAllInfo];
    }
}
#pragma mark - UIPickerView

- (void)pickerScrollIn {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
    }];
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

#pragma mark -----------UITableView----------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _staticDate.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text=_staticDate[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    CGFloat cellHeight=50.0;
    switch (indexPath.row)
    {
        case 0:
        {
            _which.frame=CGRectMake(cell.bounds.size.width-160-30, (cellHeight-30)/2, 160, 30);
            if (!_bank.name || [_bank.name isEqualToString:@""])
            {
                _which.text=@"请选择";
            }else{
                _which.text=_bank.name;
            }
            
            [cell.contentView addSubview:_which];
            _selectWhich.frame=CGRectMake(cell.bounds.size.width-30, (cellHeight-20)/2, 20, 20);
            [cell.contentView addSubview:_selectWhich];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {;
            _bankName.frame=CGRectMake(cell.bounds.size.width-160-10, (cellHeight-30)/2, 160, 30);
            [cell.contentView addSubview:_bankName];
        }
            break;
        case 2:
        {
            _where.frame=CGRectMake(cell.bounds.size.width-160-30, (cellHeight-30)/2, 160, 30);
           
            [cell.contentView addSubview:_where];
            _selectWhere.frame=CGRectMake(cell.bounds.size.width-30, (cellHeight-20)/2, 20, 20);
            [cell.contentView addSubview:_selectWhere];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

        }
            break;
        case 3:
        {
            _people.frame=CGRectMake(cell.bounds.size.width-160-10, (cellHeight-30)/2, 160, 30);
            [cell.contentView addSubview:_people];
        }
            break;
        case 4:
        {
            _number.frame=CGRectMake(cell.bounds.size.width-200-10, (cellHeight-30)/2, 200, 30);
            [cell.contentView addSubview:_number];

        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            [self which];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            [self where];
            [self pickerScrollIn];
            [self.view endEditing:YES];
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
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
#pragma mark --------BanksListDelegate--------
-(void)getSelectBank:(BanksModel *)bank
{
    _bank=bank;
    [_tableView reloadData];
}

#pragma mark 键盘
//键盘出现
-(void)handleKeyboardDidShow:(NSNotification*)notification
{
   
    if (self.editingField.keyboardType==UIKeyboardTypeNumberPad)
    {
       
        if (_downButton==nil)
        {
            _downButton=[UIButton buttonWithType:UIButtonTypeCustom];
            
            CGFloat screenHeight=[[UIScreen mainScreen] bounds].size.height;
            CGFloat screenwidth=[[UIScreen mainScreen] bounds].size.width;
            
            NSLog(@"------尺寸:%f  宽度:%f",screenHeight,screenwidth);
            // 667 iphone6   960 iPhone6 Plus
            if(screenHeight==568.0f)
            {
                _downButton.frame = CGRectMake(0, 568 - 53, 106, 53);
            }
            
            if(screenHeight==667.0f)
            {
                _downButton.frame = CGRectMake(0, 667 - 53, 125, 53);
            }
            if (screenHeight==736.0f)
            {
                _downButton.frame = CGRectMake(0, 736 - 53, 138, 53);
            }
            if (screenHeight==480.0f)
            {//3.5寸
                _downButton.frame = CGRectMake(0, 480 - 53, 106, 53);
            }
            
            _downButton.adjustsImageWhenHighlighted=NO;
            
            [_downButton setTitle:@"完成" forState:UIControlStateNormal];
            [_downButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_downButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
        
        if (_downButton.superview == nil)
        {
            [tempWindow addSubview:_downButton];    // 注意这里直接加到window上
        }
        
    }
    
}
//键盘将要隐藏
-(void)handleKeyboardWillHide:(NSNotification*)notification
{
    
    if (_downButton.superview)
    {
        [_downButton removeFromSuperview];
    }
}

-(void)finishAction
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    [self judgeAllInfo];
}


#pragma mark ---------UITextField-----
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    [self judgeAllInfo];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.editingField=textField;
    if (textField.tag==2222)
    {
        _downButton.hidden=NO;
    }else
    {
        _downButton.hidden=YES;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    if (textField.tag==1111 || textField.tag==2222 ) {
    
        _tableView.contentOffset=CGPointMake(0, 100);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag==1111 || textField.tag==2222 ) {
        
        _tableView.contentOffset=CGPointZero;
    }
}



#pragma mark --------UIAlertView---
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2)
    {
        if (buttonIndex==0)
        {
            //确认,重新提现
            [self refreshCash];
        }

    }
    }
//刷新重新提现
-(void)refreshCash
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"重新提现...";

    [NetWorkInterface getRefreshWithorderId:_orderId finished:^(BOOL success, NSData *response) {
        
        hud.customView=[[UIImageView alloc]init];
        [hud hide:YES afterDelay:0.3];
        NSLog(@"------------刷新提现cash:%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success)
        {
            id object=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"code"]integerValue] == RequestSuccess)
                {
                    
                    hud.labelText=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    
                }else
                {
                    NSString *message=[NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                    hud.labelText=message;
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
//判断是否输入所有信息
-(BOOL)judgeAllInfo
{
    if (_which.text && ![_which.text isEqualToString:@"请选择"] && _where.text && ![_where.text isEqualToString:@"请选择"])
    {
        if (_bankName.text && ![_bankName.text isEqualToString:@""] &&_people.text && ![_people.text isEqualToString:@""] && _number.text && ![_number.text isEqualToString:@""])
        {
             _commit.userInteractionEnabled=YES;
            [_commit setBackgroundColor:kMainColor];
            return YES;
    
            
        }else
        {
            [_commit setBackgroundColor:[self colorWithHexString:@"aacae9"]];
            _commit.userInteractionEnabled=NO;
            return NO;
        }
        
    }else
    {
        [_commit setBackgroundColor:[self colorWithHexString:@"aacae9"]];
        _commit.userInteractionEnabled=NO;
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
