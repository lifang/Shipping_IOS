//
//  Distance.h
//  GoodMore
//
//  Created by lihongliang on 15/7/15.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Distance : NSObject

@property(nonatomic,strong)NSNumber *ID;

@property(nonatomic,strong)NSString *content;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
