//
//  ShipRelation.h
//  GoodMore
//
//  Created by lihongliang on 15/6/3.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipRelation : NSObject
@property(nonatomic,strong)NSNumber *creator;
@property(nonatomic,strong)NSString *inWriteTimeNew;
@property(nonatomic,strong)NSNumber *loginId;
@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSNumber *updateTime;
@property(nonatomic,strong)NSNumber *outAccount;
@property(nonatomic,strong)NSNumber *outWriteTime;
@property(nonatomic,strong)NSNumber *shipBusinessRelationId;
@property(nonatomic,strong)NSString *longDistance;
@property(nonatomic,strong)NSNumber *volume;
@property(nonatomic,strong)NSNumber *shipOwnerId;
@property(nonatomic,strong)NSNumber *payMoney;
@property(nonatomic,strong)NSNumber *businessOrderId;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSNumber *createTime;
@property(nonatomic,strong)NSString *outWriteTimeNew;
@property(nonatomic,strong)NSNumber *inAccount;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSNumber *updator;
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSString *shipNumber;
@property(nonatomic,strong)NSNumber *inWriteTime;
@property(nonatomic,strong)NSNumber *status;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;


@end
