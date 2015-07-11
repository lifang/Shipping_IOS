//
//  OrdersModel.m
//  GoodMore
//
//  Created by lihongliang on 15/6/2.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "OrdersModel.h"

@implementation OrdersModel

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self=[super init])
    {
        [self setValuesForKeysWithDictionary:dictionary];
        self.ID=[dictionary objectForKey:@"id"];
        self.payMoney = [dictionary objectForKey:@"payMoney"];
        self.quote = [dictionary objectForKey:@"quote"];
        self.outAccount = [dictionary objectForKey:@"outAccount"];
        self.outWriteTimeStr = [dictionary objectForKey:@"outWriteTimeStr"];
        self.inAccount = [dictionary objectForKey:@"inAccount"];
        self.inWriteTimeStr = [dictionary objectForKey:@"inWriteTimeStr"];

    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
