//
//  ShipTeam.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipTeam.h"

@implementation ShipTeam
- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _shipTeamID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"code"]) {
            _code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        }else
        {
            _code = @"-";
        }
        if ([dict objectForKey:@"allAccount"]) {
            _allAccount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"allAccount"]];
        }
        else{
            _allAccount = @"-";
        }
        if ([dict objectForKey:@"timeLeft"]) {
            _timeLeft = [NSString stringWithFormat:@"%@",[dict objectForKey:@"timeLeft"]];
        }
        else{
            _timeLeft = @"-";
        }
    }
    return self;
}
@end
