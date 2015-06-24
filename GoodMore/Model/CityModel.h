//
//  ProvinceModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/23.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
//@property(nonatomic,strong)NSNumber *ID;
//@property(nonatomic,strong)NSNumber *updated_at;
//@property(nonatomic,strong)NSString *name;
//@property(nonatomic,strong)NSString *pinyin;
//@property(nonatomic,strong)NSNumber *created_at;
//@property(nonatomic,strong)NSNumber *sort_index;
//@property(nonatomic,strong)NSNumber *parent_id;
//-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, strong) NSString *parentID;

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) NSString *cityPinYin;


@end
