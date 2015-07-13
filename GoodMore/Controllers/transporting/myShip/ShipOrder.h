//
//  ShipOrder.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipOrder : NSObject

@property(nonatomic,strong)NSString *applyNumbers;

@property(nonatomic,strong)NSString *ID;

@property(nonatomic,strong)NSString *beginPortName;

@property(nonatomic,strong)NSString *beginDockName;

@property(nonatomic,strong)NSString *endDockName;

@property(nonatomic,strong)NSString *endPortName;

@property(nonatomic,strong)NSString *cargos;

@property(nonatomic,strong)NSString *workTime;

@property(nonatomic,strong)NSString *storage;

@property(nonatomic,assign)double maxPay;

@property(nonatomic,assign)double quote;
//总运货量
@property(nonatomic,strong)NSString *amount;

@property(nonatomic,strong)NSString *companyName;

@property(nonatomic,strong)NSString *teamStatus;

@property(nonatomic,strong)NSString *code;

@property(nonatomic,strong)NSString *status;

@property(nonatomic,assign)double allPay;

- (id)initWithParseDictionary:(NSDictionary *)dict;
@end
