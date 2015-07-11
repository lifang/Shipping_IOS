//
//  ShipInTeam.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipInTeam : NSObject

@property(nonatomic,strong)NSString *ID;

@property(nonatomic,strong)NSString *shipName;

@property(nonatomic,strong)NSString *name;

@property(nonatomic,strong)NSString *volume;

@property(nonatomic,strong)NSString *phone;

@property(nonatomic,strong)NSString *submitMoney;

@property(nonatomic,strong)NSString *isLeader;

@property(nonatomic,strong)NSString *isSelf;

@property(nonatomic,strong)NSString *shipNumber;

- (id)initWithParseDictionary:(NSDictionary *)dict;
@end
