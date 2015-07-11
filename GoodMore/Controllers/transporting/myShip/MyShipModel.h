//
//  MyShipModel.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShipOrder.h"
#import "ShipTeam.h"
#import "ShipInTeam.h"

@interface MyShipModel : NSObject

@property(nonatomic,strong)ShipOrder *shipOder;

@property(nonatomic,strong)ShipTeam *shipTeam;

@property(nonatomic,strong)ShipInTeam *shipInTeam;

@property(nonatomic,strong)NSString *isTeamLeader;

- (id)initWithParseDictionary:(NSDictionary *)dict;
@end
