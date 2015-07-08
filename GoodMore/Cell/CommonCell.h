//
//  CommonCell.h
//  GoodMore
//
//  Created by lihongliang on 15/7/7.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonCell : UITableViewCell

@property(nonatomic,strong)UILabel *companyName;

@property(nonatomic,strong)UIButton *statusButton;

@property(nonatomic,strong)UILabel *fromCity;

@property(nonatomic,strong)UILabel *fromPort;

@property(nonatomic,strong)UILabel *toCity;

@property(nonatomic,strong)UILabel *toPort;

@property(nonatomic,strong)UILabel *price;

@property(nonatomic,strong)UILabel *weight;

@property(nonatomic,strong)UILabel *loadTime;

@property(nonatomic,strong)UILabel *goods;

@property(nonatomic,strong)UILabel *endTime;

@property(nonatomic,strong)UILabel *deposit;

@end
