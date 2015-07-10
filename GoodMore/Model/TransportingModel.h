//
//  TransportingModel.h
//  GoodMore
//
//  Created by comdosoft on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransportingModel : NSObject
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *fromCity;

@property (nonatomic, strong) NSString *fromPort;

@property (nonatomic, strong) NSString *toCity;

@property (nonatomic, strong) NSString *toPort;

@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *weight;

@property (nonatomic, strong) NSString *loadTime;

@property (nonatomic, strong) NSString *goods;
@property (nonatomic, strong) NSString *beginDockName;
@property (nonatomic, strong) NSString *ePortName;

@property (nonatomic, strong) NSString *toBPortTimeStr;
@property (nonatomic, strong) NSString *inWriteTimeStr;
@property (nonatomic, strong) NSString *toEPortTimeStr;
@property (nonatomic, strong) NSString *outWriteTimeStr;

@property(nonatomic,assign)int *levelInt;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
