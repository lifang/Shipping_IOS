//
//  MessageModel.m
//  GoodMore
//
//  Created by lihongliang on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self=[super init])
    {
        [self setValuesForKeysWithDictionary:dictionary];
        self.ID=[dictionary objectForKey:@"id"];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
