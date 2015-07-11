//
//  PayForShipController.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"
#import "ShipOrder.h"
#import "HistoryController.h"

@interface PayForShipController : CommonViewController

@property(nonatomic,strong)ShipOrder *shipOrderModel;

@property(nonatomic,strong)NSMutableArray *contentArray;

@end
