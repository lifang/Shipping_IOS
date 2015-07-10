//
//  MessageModel.h
//  GoodMore
//
//  Created by lihongliang on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSNumber *shipOwnerId;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSNumber *loginId;
@property(nonatomic,strong)NSString *updateTime;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
