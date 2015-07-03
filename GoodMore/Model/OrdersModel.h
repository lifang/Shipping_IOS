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

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
