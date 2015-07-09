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

@property(nonatomic,strong)NSString *endPortName;

@property(nonatomic,strong)NSString *endDockName;

@property(nonatomic,strong)NSString *cargos;



@end
