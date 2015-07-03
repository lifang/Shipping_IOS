//
//  BankInfoViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/6/11.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"
#import "BanksModel.h"
@interface BankInfoViewController : CommonViewController
@property(nonatomic,strong)BanksModel *bank;
@property(nonatomic,strong)NSString *cashNum;
@end
