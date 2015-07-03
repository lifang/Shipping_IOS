//
//  MoneyNumModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/23.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyNumModel : NSObject
@property(nonatomic,strong)NSString *actualNum;
@property(nonatomic,strong)NSString *sxf;
@property(nonatomic,strong)NSString *allNum;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
