//
//  BanksModel.h
//  GoodMore
//
//  Created by lihongliang on 15/6/23.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BanksModel : NSObject
@property(nonatomic,strong)NSNumber *ID;
@property(nonatomic,strong)NSString *name;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
