//
//  ShipTeamModel.m
//  GoodMore
//
//  Created by lihongliang on 15/6/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipTeamModel.h"

@implementation ShipTeamModel

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
