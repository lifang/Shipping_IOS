//
//  ShipOrder.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/9.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipOrder.h"

@implementation ShipOrder
- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"applyNumbers"]) {
            _applyNumbers = [NSString stringWithFormat:@"%@",[dict objectForKey:@"applyNumbers"]];
        }else
        {
            _applyNumbers = @"";
        }
        if ([dict objectForKey:@"id"]) {
            _ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        else{
            _ID = @"";
        }
        if ([dict objectForKey:@"beginPortName"]) {
            _beginPortName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"beginPortName"]];
        }else{
            _beginPortName = @"-";
        }
        if ([dict objectForKey:@"endPortName"]) {
            _endPortName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"endPortName"]];
        }else{
            _endPortName = @"-";
        }
        if ([dict objectForKey:@"cargos"]) {
            _cargos = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cargos"]];
        }else{
            _cargos = @"-";
        }
        if ([dict objectForKey:@"workTime"]) {
            _workTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"workTime"]];
        }else{
            _workTime = @"-";
        }
        if ([dict objectForKey:@"storage"]) {
            _storage = [NSString stringWithFormat:@"%@",[dict objectForKey:@"storage"]];
        }else{
            _storage = @"-";
        }
        if ([dict objectForKey:@"companyName"]) {
            _companyName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"companyName"]];
        }else{
            _companyName = @"-";
        }
        if ([dict objectForKey:@"beginDockName"]) {
            _beginDockName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"beginDockName"]];
        }else{
            _beginDockName = @"-";
        }
        if ([dict objectForKey:@"endDockName"]) {
            _endDockName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"endDockName"]];
        }else{
            _endDockName = @"-";
        }
        if ([dict objectForKey:@"maxPay"]) {
            _maxPay = [[dict objectForKey:@"maxPay"] doubleValue];
        }else{
            _maxPay = 0.00;
        }
        if ([dict objectForKey:@"amount"]) {
            _amount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"amount"]];
        }else{
            _amount = @"-";
        }
        if ([dict objectForKey:@"teamStatus"]) {
            _teamStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"teamStatus"]];
        }
        if ([dict objectForKey:@"code"]) {
            _code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        }else{
            _code = @"";
        }
        if ([dict objectForKey:@"status"]) {
            _status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
        }else{
            _status = @"";
        }
        if ([dict objectForKey:@"allPay"]) {
            _allPay = [[dict objectForKey:@"allPay"] doubleValue];
        }
        if ([dict objectForKey:@"quote"]) {
            _quote = [[dict objectForKey:@"quote"] doubleValue];
        }
        if ([dict objectForKey:@"shipId"]) {
            _shipID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shipId"]];
        }
    }
    return self;
}

@end
