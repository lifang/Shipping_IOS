//
//  CityHandle.m
//  GoodMore
//
//  Created by lihongliang on 15/6/23.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CityHandle.h"

static NSArray *s_cityList = nil;
static NSArray *s_provinceList = nil;

@implementation CityHandle
//省
+ (NSArray *)shareProvinceList {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!s_provinceList) {
            s_provinceList = [[self class] getProvinceList];
        }
    });
    return s_provinceList;
}
//城市
+ (NSArray *)shareCityList {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!s_cityList) {
            s_cityList = [[self class] getCityList];
        }
    });
    return s_cityList;
}

//省
+ (NSArray *)getProvinceList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"js"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSArray *provinceList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return provinceList;
}
+ (NSArray *)getCityList {
    NSArray *provinceList = [[self class] shareProvinceList];
    NSMutableArray *cityList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [provinceList count]; i++) {
        NSDictionary *provinceDict = [provinceList objectAtIndex:i];
        NSArray *cityForProvince = [provinceDict objectForKey:@"cities"];
        for (int j = 0; j < [cityForProvince count]; j++) {
            NSDictionary *cityDict = [cityForProvince objectAtIndex:j];
            CityModel *city = [[CityModel alloc] init];
            city.cityID = [NSString stringWithFormat:@"%@",[cityDict objectForKey:@"id"]];
            city.cityName = [cityDict objectForKey:@"name"];
            city.parentID = [NSString stringWithFormat:@"%@",[cityDict objectForKey:@"parentId"]];
            city.cityPinYin = [cityDict objectForKey:@"pinyin"];
            [cityList addObject:city];
        }
    }
    return cityList;
}

@end
