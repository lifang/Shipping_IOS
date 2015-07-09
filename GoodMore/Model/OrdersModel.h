//
//  OrdersModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/2.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrdersModel : NSObject
@property(nonatomic,strong)NSString *endPortName;
@property(nonatomic,strong)NSString *longDistance;
@property(nonatomic,strong)NSNumber *amount;
@property(nonatomic,strong)NSNumber *shipTeamId;
@property(nonatomic,strong)NSNumber *cargoBossId;
@property(nonatomic,strong)NSNumber *cargoType;
@property(nonatomic,strong)NSNumber *waterEat;
@property(nonatomic,strong)NSNumber *creator;
@property(nonatomic,strong)NSString *coordinate;
@property(nonatomic,strong)NSNumber *beginPortId;
@property(nonatomic,strong)NSNumber *updateTime;
@property(nonatomic,strong)NSString *cargos;
@property(nonatomic,strong)NSString *workTime;
@property(nonatomic,strong)NSNumber *allPay;
@property(nonatomic,strong)NSNumber *publishId;
@property(nonatomic,strong)NSNumber *endPortId;
@property(nonatomic,strong)NSNumber *createTime;
@property(nonatomic,strong)NSNumber *price;
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSString *applyNumbers;
@property(nonatomic,strong)NSString *beginPortName;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSNumber *outDays;
@property(nonatomic,strong)NSNumber *inDays;
@property(nonatomic,strong)NSNumber *endDockId;
@property(nonatomic,strong)NSNumber *maxAmount;
@property(nonatomic,strong)NSNumber *minAmount;
@property(nonatomic,strong)NSNumber *maxPay;
@property(nonatomic,strong)NSNumber *storage;
@property(nonatomic,strong)NSString *showTime;
@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSString *beginDockName;
@property(nonatomic,strong)NSString *endDockName;


-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
