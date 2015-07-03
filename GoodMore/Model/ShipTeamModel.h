//
//  ShipTeamModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipTeamModel : NSObject

@property(nonatomic,strong)NSNumber *amount;
@property(nonatomic,strong)NSString *endPortName;
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSNumber *days;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSString *workTime;
@property(nonatomic,strong)NSString *cargos;
@property(nonatomic,strong)NSString *beginPortName;
@property(nonatomic,strong)NSNumber *code;
@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSString *shipList;
@property(nonatomic,strong)NSNumber *paidMoney;
@property(nonatomic,strong)NSNumber *cargoPay;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
