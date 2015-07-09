//
//  JoinShipController.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "JoinShipController.h"

@interface JoinShipController ()

@property(nonatomic,strong)UITextField *moneyField;

@property(nonatomic,assign)int money;

@end

@implementation JoinShipController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.money = 1;
    self.view.backgroundColor = kColor(144, 144, 144, 0.7);
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.frame = CGRectMake(K_MainWidth / 5.5, K_MainHeight / 5, K_MainWidth / 1.5, K_MainHeight / 3);
    [self.view addSubview:whiteView];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"船队密码:";
    label1.font = [UIFont systemFontOfSize:11];
    label1.frame = CGRectMake(10, 20, 100, 10);
    [whiteView addSubview:label1];
    
    UITextField *passwordField = [[UITextField alloc]init];
    passwordField.backgroundColor = [UIColor clearColor];
    passwordField.frame = CGRectMake(label1.frame.origin.x + 20, CGRectGetMaxY(label1.frame) + 5, whiteView.frame.size.width / 1.5, 30);
    CALayer *readBtnLayer = [passwordField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:4.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:kColor(188, 188, 188, 0.7).CGColor];
    [whiteView addSubview:passwordField];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:11];
    label2.text = @"你的报价:";
    label1.font = [UIFont systemFontOfSize:11];
    label2.frame = CGRectMake(10, CGRectGetMaxY(passwordField.frame) + 5, 100, 10);
    [whiteView addSubview:label2];
    
    UIButton *reduceBtn = [[UIButton alloc]init];
    reduceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [reduceBtn addTarget:self action:@selector(reduceClicked) forControlEvents:UIControlEventTouchUpInside];
    [reduceBtn setTitle:@"-" forState:UIControlStateNormal];
    [reduceBtn setBackgroundColor:[UIColor clearColor]];
    [reduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CALayer *readBtnLayer2 = [reduceBtn layer];
    [readBtnLayer2 setMasksToBounds:YES];
    [readBtnLayer2 setCornerRadius:2.0];
    [readBtnLayer2 setBorderWidth:1.0];
    [readBtnLayer2 setBorderColor:kColor(188, 188, 188, 0.7).CGColor];
    reduceBtn.frame = CGRectMake(passwordField.frame.origin.x, CGRectGetMaxY(label2.frame) + 10, passwordField.frame.size.width / 4, 30);
    [whiteView addSubview:reduceBtn];
    
    _moneyField = [[UITextField alloc]init];
    _moneyField.userInteractionEnabled = NO;
    _moneyField.textAlignment = NSTextAlignmentCenter;
    _moneyField.font = [UIFont systemFontOfSize:12];
    _moneyField.text = @"1.00";
    CALayer *readBtnLayer3 = [_moneyField layer];
    [readBtnLayer3 setMasksToBounds:YES];
    [readBtnLayer3 setCornerRadius:2.0];
    [readBtnLayer3 setBorderWidth:1.0];
    [readBtnLayer3 setBorderColor:kColor(188, 188, 188, 0.7).CGColor];
    _moneyField.backgroundColor = kColor(188, 188, 188, 0.7);
    _moneyField.frame = CGRectMake(CGRectGetMaxX(reduceBtn.frame) + 5, reduceBtn.frame.origin.y, reduceBtn.frame.size.width * 1.7, 30);
    [whiteView addSubview:_moneyField];
    
    UIButton *addBtn = [[UIButton alloc]init];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor clearColor]];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CALayer *readBtnLayer4 = [addBtn layer];
    [readBtnLayer4 setMasksToBounds:YES];
    [readBtnLayer4 setCornerRadius:2.0];
    [readBtnLayer4 setBorderWidth:1.0];
    [readBtnLayer4 setBorderColor:kColor(188, 188, 188, 0.7).CGColor];
    addBtn.frame = CGRectMake(CGRectGetMaxX(_moneyField.frame) + 5, CGRectGetMaxY(label2.frame) + 10, passwordField.frame.size.width / 4, 30);
    [whiteView addSubview:addBtn];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(188, 188, 188, 0.7);
    line.frame = CGRectMake(0, CGRectGetMaxY(addBtn.frame) + 30, whiteView.frame.size.width, 1);
    [whiteView addSubview:line];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = kColor(188, 188, 188, 0.7);
    line2.frame = CGRectMake(whiteView.frame.size.width / 2, line.frame.origin.y, 1, whiteView.frame.size.height - line.frame.origin.y);
    [whiteView addSubview:line2];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, line.frame.origin.y, whiteView.frame.size.width / 2,line2.frame.size.height);
    [whiteView addSubview:cancelBtn];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClicked) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.frame = CGRectMake(whiteView.frame.size.width / 2, line.frame.origin.y, whiteView.frame.size.width / 2,line2.frame.size.height);
    [whiteView addSubview:sureBtn];
    
}

#pragma mark -- Action
-(void)reduceClicked {
    _money -=1;
    NSString *money = [NSString stringWithFormat:@"%d",_money];
    _moneyField.text = [NSString stringWithFormat:@"%@.00",money];
}

-(void)addBtnClicked {
    _money +=1;
    NSString *money = [NSString stringWithFormat:@"%d",_money];
    _moneyField.text = [NSString stringWithFormat:@"%@.00",money];
}

-(void)cancelClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sureClicked {
//    [self joinShipTeam];
}

#pragma mark - Request
//-(void)joinShipTeam {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.labelText = @"加载中...";
//    [NetWorkInterface joinInTeamWithLoginId:88 Code:@"374785" ShipOwnID:<#(int)#> Quote:<#(int)#> finished:^(BOOL success, NSData *response) {
//        hud.customView = [[UIImageView alloc] init];
//        hud.mode = MBProgressHUDModeCustomView;
//        [hud hide:YES afterDelay:0.3f];
//        if (success) {
//            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
//            if ([object isKindOfClass:[NSDictionary class]]) {
//                NSString *errorCode = [object objectForKey:@"code"];
//                if ([errorCode intValue] == RequestFail) {
//                    //返回错误代码
//                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
//                }
//                else if ([errorCode intValue] == RequestSuccess) {
//                    [hud hide:YES];
//        
//                }
//            }
//            else {
//                //返回错误数据
//                hud.labelText = kServiceReturnWrong;
//            }
//        }
//        else {
//            hud.labelText = kNetworkFailed;
//        }
//        
//    }];
//
//}

@end