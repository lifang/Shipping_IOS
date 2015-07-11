//
//  MyShipModel.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MyShipModel.h"

@implementation MyShipModel
- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"bsOrder"]&& [[dict objectForKey:@"bsOrder"] isKindOfClass:[NSDictionary class]]) {
            _shipOder = [[ShipOrder alloc]initWithParseDictionary:[dict objectForKey:@"bsOrder"]];
        }
        if ([dict objectForKey:@"shipTeam"]&& [[dict objectForKey:@"shipTeam"] isKindOfClass:[NSDictionary class]]) {
            _shipTeam = [[ShipTeam alloc]initWithParseDictionary:[dict objectForKey:@"shipTeam"]];
        }
        if ([dict objectForKey:@"shipInTeam"] && [[dict objectForKey:@"shipInTeam"] isKindOfClass:[NSDictionary class]]) {
            _shipInTeam = [[ShipInTeam alloc]initWithParseDictionary:[dict objectForKey:@"shipInTeam"]];
        }
        if ([dict objectForKey:@"isTeamLeader"]) {
            _isTeamLeader = [NSString stringWithFormat:@"%@",[dict objectForKey:@"isTeamLeader"]];
        }
    }
    return self;

}
@end
