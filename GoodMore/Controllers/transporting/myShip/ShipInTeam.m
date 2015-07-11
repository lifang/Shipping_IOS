//
//  ShipInTeam.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipInTeam.h"

@implementation ShipInTeam
- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }else
        {
            _ID = @"";
        }
        if ([dict objectForKey:@"shipName"]) {
            _shipName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shipName"]];
        }else
        {
            _shipName = @"-";
        }
        if ([dict objectForKey:@"shipNumber"]) {
            _shipNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shipNumber"]];
        }else
        {
            _shipNumber = @"-";
        }
        if ([dict objectForKey:@"name"]) {
            _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        else{
            _name = @"-";
        }
        if ([dict objectForKey:@"volume"]) {
            _volume = [NSString stringWithFormat:@"%@",[dict objectForKey:@"volume"]];
        }else{
            _volume = @"-";
        }
        if ([dict objectForKey:@"phone"]) {
            _phone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
        }else{
            _phone = @"-";
        }
        if ([dict objectForKey:@"quote"]) {
            _submitMoney = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quote"]];
        }else{
            _submitMoney = @"-";
        }
        if ([dict objectForKey:@"isLeader"]) {
            _isLeader = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isLeader"]];
        }else{
            _isLeader = @"";
        }
        if ([dict objectForKey:@"isSelf"]) {
            _isSelf = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isSelf"]];
        }else{
            _isSelf = @"";
        }
        if ([dict objectForKey:@"defaultMoney"]) {
            _defaultMoney = [NSString stringWithFormat:@"%@",[dict objectForKey:@"defaultMoney"]];
        }
    }
    return self;
}
@end
