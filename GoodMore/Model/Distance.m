//
//  Distance.m
//  GoodMore
//
//  Created by lihongliang on 15/7/15.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "Distance.h"

@implementation Distance

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self=[super init])
    {
        self.ID=[dictionary objectForKey:@"id"];
        self.content=[dictionary objectForKey:@"content"];
    }
    return self;
}

@end
