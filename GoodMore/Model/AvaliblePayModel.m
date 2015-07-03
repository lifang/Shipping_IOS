//
//  AvaliblePayModel.m
//  GoodMore
//
//  Created by lihongliang on 15/6/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "AvaliblePayModel.h"

@implementation AvaliblePayModel

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
