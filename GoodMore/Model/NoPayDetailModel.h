//
//  NoPayDetailModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/11.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoPayDetailModel : NSObject
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSNumber *shipOwnerId;
@property(nonatomic,strong)NSNumber *type;
@property(nonatomic,strong)NSString *typeName;
@property(nonatomic,strong)NSNumber *toPay;
@property(nonatomic,strong)NSNumber *allPay;
@property(nonatomic,strong)NSString *createTimeStr;
@property(nonatomic,strong)NSNumber *shipNumber;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
