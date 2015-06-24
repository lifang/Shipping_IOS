//
//  RegularNumber.h
//  GoodMore
//
//  Created by lihongliang on 15/6/4.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularNumber : NSObject

//手机正则
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//纯数字
+ (BOOL)isNumber:(NSString *)string;
@end
