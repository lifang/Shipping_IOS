//
//  TransportingModel.m
//  GoodMore
//
//  Created by comdosoft on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "TransportingModel.h"

@implementation TransportingModel
- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"companyName"]) {
            _title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"companyName"]];
        }
        else
        {
            _title = @"";

        }
        if ([dict objectForKey:@"bPortName"]) {
            _fromCity = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bPortName"]];
        }
        else
        {
            _fromCity = @"";

        }
        if ([dict objectForKey:@"beginDockName"]) {
            _beginDockName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"beginDockName"]];
        }
        else {
            _beginDockName = @"";
        }
        if ([dict objectForKey:@"ePortName"]) {
            _ePortName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ePortName"]];
        }
        else
        {
            _ePortName = @"";
            
        }
        if ([dict objectForKey:@"ePortName"]) {
            _toPort = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ePortName"]];
        }
        else
        {
            _toPort = @"";
            
        }

        if ([dict objectForKey:@"maxPay"]) {
            _price = [NSString stringWithFormat:@"%@",[dict objectForKey:@"maxPay"]];
        }
        else
        {
            _price = @"";
            
        }
        if ([dict objectForKey:@"amount"]) {
            _weight = [NSString stringWithFormat:@"%@",[dict objectForKey:@"amount"]];
        }
        else
        {
            _weight = @"";
            
        }
        if ([dict objectForKey:@"workTime"]) {
            _loadTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"workTime"]];
        }
        else
        {
            _loadTime = @"";
            
        }
        if ([dict objectForKey:@"cargos"]) {
            _goods = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cargos"]];
        }
        else
        {
            _goods = @"";
            
        }
        if ([dict objectForKey:@"toBPortTimeStr"]) {
            _toBPortTimeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"toBPortTimeStr"]];
        }
        else
        {
            _toBPortTimeStr = @"";
            
        }
        if ([dict objectForKey:@"inWriteTimeStr"]) {
            _inWriteTimeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"inWriteTimeStr"]];
        }
        else
        {
            _inWriteTimeStr = @"";
            
        }
        if ([dict objectForKey:@"toEPortTimeStr"]) {
            _toEPortTimeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"toEPortTimeStr"]];
        }
        else
        {
            _toEPortTimeStr = @"";
            
        }

        if ([dict objectForKey:@"outWriteTimeStr"]) {
            _outWriteTimeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"outWriteTimeStr"]];
        }
        else
        {
            _outWriteTimeStr = @"";
            
        }


    }
    return self;
}

@end
