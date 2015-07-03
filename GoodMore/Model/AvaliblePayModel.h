//
//  AvaliblePayModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvaliblePayModel : NSObject
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSNumber *shipOwnerId;
@property(nonatomic,strong)NSString *cargoOwnerName;
@property(nonatomic,strong)NSNumber *type;
@property(nonatomic,strong)NSString*typeName;
@property(nonatomic,strong)NSNumber *nums;
@property(nonatomic,strong)NSNumber *createTimeStr;
@property(nonatomic,strong)NSNumber *totalNums;
@property(nonatomic,strong)NSNumber *shipNumber;
@property(nonatomic,strong)NSNumber *cargoOwnerId;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
