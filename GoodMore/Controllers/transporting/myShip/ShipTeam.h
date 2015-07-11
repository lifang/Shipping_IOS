//
//  ShipTeam.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipTeam : NSObject

@property(nonatomic,strong)NSString *shipTeamID;

@property(nonatomic,strong)NSString *shipId;
//密码
@property(nonatomic,strong)NSString *code;
//吨位
@property(nonatomic,strong)NSString *allAccount;

@property(nonatomic,strong)NSString *timeLeft;

- (id)initWithParseDictionary:(NSDictionary *)dict;
@end
