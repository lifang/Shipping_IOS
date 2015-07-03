//
//  NoPayModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/11.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoPayModel : NSObject
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSNumber *cargoOwnerId;
@property(nonatomic,strong)NSNumber *shipOwnerId;
@property(nonatomic,strong)NSNumber *toPay;
@property(nonatomic,strong)NSNumber *allPay;

@property(nonatomic,strong)NSNumber *Type;
@property(nonatomic,strong)NSNumber *creator;
@property(nonatomic,strong)NSNumber *createtime;
@property(nonatomic,strong)NSNumber *updator;
@property(nonatomic,strong)NSNumber *updatetime;
@property(nonatomic,strong)NSString *companyName;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
