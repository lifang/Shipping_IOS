//
//  CityHandle.h
//  GoodMore
//
//  Created by lihongliang on 15/6/23.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface CityHandle : NSObject

+ (NSArray *)shareProvinceList;  //省份数组
+ (NSArray *)shareCityList;      //城市数组

@end
