//
//  ShipHistoryCell.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipHistoryCell.h"

@interface ShipHistoryCell()

@property(nonatomic,strong)UIImageView *logistLogo;

@property(nonatomic,strong)UIImageView *startLogo;

@property(nonatomic,strong)UIImageView *endLogo;

@property(nonatomic,strong)UIImageView *jiantouV;

@property(nonatomic,strong)UIView *blueView;

@property(nonatomic,strong)UIView *grayView;

@end

@implementation ShipHistoryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *grayView = [[UIView alloc]init];
        grayView.backgroundColor = kColor(213, 217, 218, 1.0);
        grayView.frame = CGRectMake(10, 13, K_MainWidth - 20, 34);
        [self.contentView addSubview:grayView];
        
        UIView *leftLine = [[UIView alloc]init];
        leftLine.backgroundColor = kColor(213, 217, 218, 1.0);
        leftLine.frame = CGRectMake(10, 47, 1, 160);
        [self.contentView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc]init];
        rightLine.backgroundColor = kColor(213, 217, 218, 1.0);
        rightLine.frame = CGRectMake(K_MainWidth - 11, 47, 1, 160);
        [self.contentView addSubview:rightLine];
        
        _logistLogo = [[UIImageView alloc]init];
        _logistLogo.image = [UIImage imageNamed:@"company"];
        _logistLogo.frame = CGRectMake(20, 18, 20, 20);
        [self.contentView addSubview:_logistLogo];
        
        _startLogo = [[UIImageView alloc]init];
        _startLogo.image = [UIImage imageNamed:@"from"];
        [self.contentView addSubview:_startLogo];
        
        _endLogo = [[UIImageView alloc]init];
        _endLogo.image = [UIImage imageNamed:@"to"];
        [self.contentView addSubview:_endLogo];
        
        _jiantouV = [[UIImageView alloc]init];
        _jiantouV.image = [UIImage imageNamed:@"jianTou"];
        [self.contentView addSubview:_jiantouV];
        
        _logistNameLabel = [[UILabel alloc]init];
        _logistNameLabel.font = [UIFont systemFontOfSize:15];
        _logistNameLabel.text = @"中宁物流";
        [self.contentView addSubview:_logistNameLabel];
        
        _startPlaceLabel = [[UILabel alloc]init];
        _startPlaceLabel.text = @"南通";
//        _startPlaceLabel.font = [UIFont systemFontOfSize:20];
        _startPlaceLabel.textColor = kColor(101, 101, 101, 1.0);
        [self.contentView addSubview:_startPlaceLabel];
        
        _startPortLabel = [[UILabel alloc]init];
        _startPortLabel.textAlignment = NSTextAlignmentCenter;
        _startPortLabel.text = @"马达加斯加港口";
        _startPortLabel.font = [UIFont systemFontOfSize:13];
        _startPortLabel.textColor = kColor(116, 116, 116, 1.0);
        [self.contentView addSubview:_startPortLabel];
        
        _endPlaceLabel = [[UILabel alloc]init];
        _endPlaceLabel.text = @"芜湖";
//        _endPlaceLabel.font = [UIFont systemFontOfSize:20];
        _endPlaceLabel.textColor = kColor(101, 101, 101, 1.0);
        [self.contentView addSubview:_endPlaceLabel];
        
        _endPortLabel = [[UILabel alloc]init];
        _endPortLabel.textAlignment = NSTextAlignmentCenter;
        _endPortLabel.text = @"安达曼港口";
        _endPortLabel.font = [UIFont systemFontOfSize:13];
        _endPortLabel.textColor = kColor(116, 116, 116, 1.0);
        [self.contentView addSubview:_endPortLabel];
        
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = kColor(250, 98, 14, 1.0);
        _moneyLabel.font = [UIFont systemFontOfSize:18];
        _moneyLabel.text = @"12.00 元";
        [self.contentView addSubview:_moneyLabel];
        
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = kColor(110, 110, 110, 1.0);
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.text = @"2015年7月5日装船";
        [self.contentView addSubview:_dateLabel];
        
        _weightLabel = [[UILabel alloc]init];
        _weightLabel.textColor = kColor(250, 98, 14, 1.0);
        _weightLabel.font = [UIFont systemFontOfSize:18];
        _weightLabel.text = @"2000 吨";
        [self.contentView addSubview:_weightLabel];
        
        _goodsLabel = [[UILabel alloc]init];
        _goodsLabel.textAlignment = NSTextAlignmentCenter;
        _goodsLabel.textColor = kColor(110, 110, 110, 1.0);
        _goodsLabel.font = [UIFont systemFontOfSize:12];
        _goodsLabel.text = @"水泥";
        [self.contentView addSubview:_goodsLabel];
        
        _blueView = [[UIView alloc]init];
        _blueView.backgroundColor = kColor(193, 230, 242, 1.0);
        [self.contentView addSubview:_blueView];

        
        _endTimeLabel = [[UILabel alloc]init];
        _endTimeLabel.textAlignment = NSTextAlignmentCenter;
        _endTimeLabel.font = [UIFont systemFontOfSize:12];
        _endTimeLabel.text = @"2小时53分36秒后结束";
        [self.contentView addSubview:_endTimeLabel];
        
        _marginLabel = [[UILabel alloc]init];
        _marginLabel.textAlignment = NSTextAlignmentCenter;
        _marginLabel.font = [UIFont systemFontOfSize:12];
        _marginLabel.text = @"保证金：200.00元";
        [self.contentView addSubview:_marginLabel];
        
        _successLabel = [[UILabel alloc]init];
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.backgroundColor = [UIColor clearColor];
        CALayer *readBtnLayer = [_successLabel layer];
        [readBtnLayer setMasksToBounds:YES];
        [readBtnLayer setCornerRadius:2.0];
        [readBtnLayer setBorderWidth:1.0];
        if ([reuseIdentifier isEqualToString:@"historyCell1"]) {
            _successLabel.text = @"组队成功";
            _successLabel.textColor = kLightColor;
            _successLabel.font = [UIFont systemFontOfSize:13];
            [readBtnLayer setBorderColor:kLightColor.CGColor];
        }
        if ([reuseIdentifier isEqualToString:@"historyCell2"]){
            _successLabel.text = @"组队失败";
            _successLabel.textColor = kColor(73, 76, 73, 1.0);
            _successLabel.font = [UIFont systemFontOfSize:13];
            [readBtnLayer setBorderColor:kColor(73, 76, 73, 1.0).CGColor];
        }
        if ([reuseIdentifier isEqualToString:@"historyCell3"]){
            _successLabel.text = @"计算运费";
            _successLabel.textColor = [UIColor orangeColor];
            _successLabel.font = [UIFont systemFontOfSize:13];
            [readBtnLayer setBorderColor:[UIColor orangeColor].CGColor];
        }
        if ([reuseIdentifier isEqualToString:@"historyCell4"]){
            _successLabel.text = @"完成";
            _successLabel.textColor = [UIColor greenColor];
            _successLabel.font = [UIFont systemFontOfSize:13];
            [readBtnLayer setBorderColor:[UIColor greenColor].CGColor];
        }
        _successLabel.frame = CGRectMake(K_MainWidth - 80, _logistNameLabel.frame.origin.y + 20, 60, 20);
        [self.contentView addSubview:_successLabel];
    }
    return self;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    _logistNameLabel.frame = CGRectMake(CGRectGetMaxX(_logistLogo.frame) + 5, _logistLogo.frame.origin.y, 120, 20);
    
    [self drawLineWithTopView:_logistNameLabel];
    
    _startLogo.frame = CGRectMake(_logistNameLabel.frame.origin.x - 10, CGRectGetMaxY(_logistNameLabel.frame) + 20, 14, 15);
    
    _startPlaceLabel.frame = CGRectMake(CGRectGetMaxX(_startLogo.frame) + 8, _startLogo.frame.origin.y - 7, 120, 30);
    
    _startPortLabel.frame = CGRectMake(0, CGRectGetMaxY(_startPlaceLabel.frame) + 2, K_MainWidth / 2, 15);
    
    _jiantouV.frame = CGRectMake(K_MainWidth / 2 - 15, CGRectGetMaxY(_startPlaceLabel.frame) - 5, 50, 4);
    
    _endLogo.frame = CGRectMake(CGRectGetMaxX(_jiantouV.frame) + 15, _startLogo.frame.origin.y, 14, 15);
    
    _endPlaceLabel.frame = CGRectMake(CGRectGetMaxX(_endLogo.frame) + 8, _endLogo.frame.origin.y - 7, 120, 30);
    
    _endPortLabel.frame = CGRectMake(K_MainWidth / 2 + 10, CGRectGetMaxY(_endPlaceLabel.frame) + 2, K_MainWidth / 2, 15);
    
    [self drawLineWithTopView:_endPortLabel];
    
    [self drawLineWithTopV:_endPortLabel AndHeight:50];
    
    _moneyLabel.frame = CGRectMake(_startLogo.frame.origin.x + 10, CGRectGetMaxY(_startPortLabel.frame) + 15, 120, 30);
    
    _weightLabel.frame = CGRectMake(_endLogo.frame.origin.x , CGRectGetMaxY(_endPortLabel.frame) + 15, 120, 30);
    
    _dateLabel.frame = CGRectMake(0, CGRectGetMaxY(_moneyLabel.frame) + 2, K_MainWidth / 2, 15);
    
    _goodsLabel.frame = CGRectMake(K_MainWidth / 2 , CGRectGetMaxY(_moneyLabel.frame) + 2, K_MainWidth / 2, 15);
    
    _blueView.frame = CGRectMake(10, CGRectGetMaxY(_goodsLabel.frame) + 15, K_MainWidth - 20, 30);
    
    _endTimeLabel.frame = CGRectMake(0, CGRectGetMaxY(_goodsLabel.frame) + 22, K_MainWidth / 2, 15);
    
    _marginLabel.frame = CGRectMake(K_MainWidth / 2 , CGRectGetMaxY(_goodsLabel.frame) + 22, K_MainWidth / 2, 15);
    
}

-(void)drawLineWithTopView:(UIView *)topView {
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(219, 223, 214, 1.0);
    line.frame = CGRectMake(20, CGRectGetMaxY(topView.frame) + 8, self.frame.size.width - 40, 1);
    [self.contentView addSubview:line];
}

-(void)drawLineWithTopV:(UIView *)topV AndHeight:(NSInteger)height {
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(219, 223, 214, 1.0);
    line.frame = CGRectMake(K_MainWidth / 2, CGRectGetMaxY(topV.frame) + 20, 1, height);
    [self.contentView addSubview:line];
}

-(void)setContentWithShipOrderModel:(ShipOrder *)shipOrderModel {
    _logistNameLabel.text = shipOrderModel.companyName;
    _startPlaceLabel.text = shipOrderModel.beginPortName;
    _startPortLabel.text = shipOrderModel.beginDockName;
    _endPlaceLabel.text = shipOrderModel.endPortName;
    _endPortLabel.text = shipOrderModel.endDockName;
    _moneyLabel.text = [NSString stringWithFormat:@"%@.00元",shipOrderModel.maxPay];
    _dateLabel.text = shipOrderModel.workTime;
    _weightLabel.text = [NSString stringWithFormat:@"%@吨",shipOrderModel.amount];
    _goodsLabel.text = shipOrderModel.cargos;
}

@end
