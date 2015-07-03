//
//  ShipListModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/26.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipListModel : NSObject

@property(nonatomic,strong)NSNumber *createTime;
@property(nonatomic,strong)NSNumber *loginId;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSNumber *updateTime;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSNumber *updator;
@property(nonatomic,strong)NSString *shipName;
@property(nonatomic,strong)NSNumber *isLeader;
@property(nonatomic,strong)NSString *joinCode;
@property(nonatomic,strong)NSString *shipNumber;
@property(nonatomic,strong)NSNumber *creator;
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSString *imgList;
@property(nonatomic,strong)NSString *ownCode;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSNumber *volume;
@property(nonatomic,strong)NSNumber *isSelf;
@property(nonatomic,strong)NSString *builderTime;
@property(nonatomic,strong)NSNumber *payMoney;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
