//
//  PortModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/2.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PortModel : NSObject
@property(nonatomic,strong)NSString *coordinate;
@property(nonatomic,strong)NSNumber *createTime;
@property(nonatomic,strong)NSNumber *cancelSign;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSNumber *creatorId;
@property(nonatomic,strong)NSNumber *updateTime;
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSNumber *updatorId;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
