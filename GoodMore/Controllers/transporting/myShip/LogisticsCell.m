//
//  LogisticsCell.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "LogisticsCell.h"

@interface LogisticsCell()

@property(nonatomic,strong)UIImageView *logistLogo;

@property(nonatomic,strong)UIImageView *startLogo;

@property(nonatomic,strong)UIImageView *endLogo;

@property(nonatomic,strong)UIImageView *jiantouV;

@property(nonatomic,strong)UIView *blueView;

@property(nonatomic,strong)UIView *grayView;

@property(nonatomic,strong)NSMutableArray *totalLastTime;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)NSString *reuseIdentifiers;
@end

@implementation LogisticsCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _reuseIdentifiers = reuseIdentifier;
        _totalLastTime = [[NSMutableArray alloc]init];
        
        _logistLogo = [[UIImageView alloc]init];
        _logistLogo.image = [UIImage imageNamed:@"company"];
        _logistLogo.frame = CGRectMake(20, 15, 20, 20);
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
        _startPlaceLabel.font = [UIFont systemFontOfSize:20];
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
        _endPlaceLabel.font = [UIFont systemFontOfSize:20];
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
        
        _grayView = [[UIView alloc]init];
        _grayView.backgroundColor = kColor(237, 237, 237, 1.0);
        [self.contentView addSubview:_grayView];
        
        _shipPasswordLabel = [[UILabel alloc]init];
        _shipPasswordLabel.textAlignment = NSTextAlignmentCenter;
        _shipPasswordLabel.font = [UIFont systemFontOfSize:14];
        _shipPasswordLabel.text = @"船队密码：565656";
        [self.contentView addSubview:_shipPasswordLabel];
        
        _shipWeightLabel = [[UILabel alloc]init];
        _shipWeightLabel.textAlignment = NSTextAlignmentCenter;
        _shipWeightLabel.font = [UIFont systemFontOfSize:14];
        _shipWeightLabel.text = @"船队吨位：4800吨";
        [self.contentView addSubview:_shipWeightLabel];
        
        if ([_reuseIdentifiers isEqualToString:@"1"] || [_reuseIdentifiers isEqualToString:@"2"] || [_reuseIdentifiers isEqualToString:@"3"] || [_reuseIdentifiers isEqualToString:@"4"]) {
            
        }else{
            _endTimeLabel = [[UILabel alloc]init];
            _endTimeLabel.textAlignment = NSTextAlignmentCenter;
            _endTimeLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_endTimeLabel];
            
            _marginLabel = [[UILabel alloc]init];
            _marginLabel.textAlignment = NSTextAlignmentCenter;
            _marginLabel.font = [UIFont systemFontOfSize:12];
            _marginLabel.text = @"保证金：200.00元";
            [self.contentView addSubview:_marginLabel];
            
            _blueView = [[UIView alloc]init];
            _blueView.backgroundColor = kColor(193, 230, 242, 1.0);
            [self.contentView addSubview:_blueView];
        }
        
        _successTeam = [[UILabel alloc]init];
        _successTeam.textAlignment = NSTextAlignmentCenter;
        _successTeam.backgroundColor = [UIColor clearColor];
        CALayer *readBtnLayer = [_successTeam layer];
        [readBtnLayer setMasksToBounds:YES];
        [readBtnLayer setCornerRadius:2.0];
        [readBtnLayer setBorderWidth:1.0];
        if ([reuseIdentifier isEqualToString:@"1"]) {
            _successTeam.text = @"组队成功";
            _successTeam.textColor = kLightColor;
            _successTeam.font = [UIFont systemFontOfSize:13];
            [readBtnLayer setBorderColor:kLightColor.CGColor];
        }
        if ([reuseIdentifier isEqualToString:@"2"]){
            _successTeam.text = @"组队失败";
            _successTeam.textColor = kColor(73, 76, 73, 1.0);
            _successTeam.font = [UIFont systemFontOfSize:13];
            [readBtnLayer setBorderColor:kColor(73, 76, 73, 1.0).CGColor];
        }
        if ([reuseIdentifier isEqualToString:@"3"]){
            _successTeam.text = @"计算运费";
            _successTeam.textColor = [UIColor orangeColor];
            _successTeam.font = [UIFont systemFontOfSize:13];
            [readBtnLayer setBorderColor:[UIColor orangeColor].CGColor];
        }
        if ([reuseIdentifier isEqualToString:@"4"]){
            _successTeam.text = @"完成";
            _successTeam.textColor = [UIColor greenColor];
            _successTeam.font = [UIFont systemFontOfSize:13];
            [readBtnLayer setBorderColor:[UIColor greenColor].CGColor];
        }
        _successTeam.frame = CGRectMake(K_MainWidth - 80, _logistNameLabel.frame.origin.y + 15, 60, 20);
        [self.contentView addSubview:_successTeam];
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
    
    _jiantouV.frame = CGRectMake(K_MainWidth / 2 - 15, CGRectGetMaxY(_startPlaceLabel.frame) - 10, 50, 4);
    
    _endLogo.frame = CGRectMake(CGRectGetMaxX(_jiantouV.frame) + 15, _startLogo.frame.origin.y, 14, 15);
    
    _endPlaceLabel.frame = CGRectMake(CGRectGetMaxX(_endLogo.frame) + 8, _endLogo.frame.origin.y - 7, 120, 30);
    
    _endPortLabel.frame = CGRectMake(K_MainWidth / 2 + 10, CGRectGetMaxY(_endPlaceLabel.frame) + 2, K_MainWidth / 2, 15);
    
    [self drawLineWithTopView:_endPortLabel];
    
    [self drawLineWithTopV:_endPortLabel AndHeight:50];
    
    _moneyLabel.frame = CGRectMake(_startLogo.frame.origin.x + 10, CGRectGetMaxY(_startPortLabel.frame) + 15, 120, 30);
    
    _weightLabel.frame = CGRectMake(_endLogo.frame.origin.x , CGRectGetMaxY(_endPortLabel.frame) + 15, 120, 30);
    
    _dateLabel.frame = CGRectMake(0, CGRectGetMaxY(_moneyLabel.frame) + 2, K_MainWidth / 2, 15);
    
    _goodsLabel.frame = CGRectMake(K_MainWidth / 2 , CGRectGetMaxY(_moneyLabel.frame) + 2, K_MainWidth / 2, 15);
    
    if ([_reuseIdentifiers isEqualToString:@"1"] || [_reuseIdentifiers isEqualToString:@"2"] || [_reuseIdentifiers isEqualToString:@"3"] || [_reuseIdentifiers isEqualToString:@"4"]) {
        _grayView.frame = CGRectMake(10, CGRectGetMaxY(_goodsLabel.frame) + 10, K_MainWidth - 20, 50);
        _shipPasswordLabel.frame = CGRectMake(0, CGRectGetMaxY(_goodsLabel.frame) + 25, K_MainWidth / 2, 15);
        _shipWeightLabel.frame = CGRectMake(K_MainWidth / 2 , CGRectGetMaxY(_goodsLabel.frame) + 25, K_MainWidth / 2, 15);
    }else{
        _blueView.frame = CGRectMake(10, CGRectGetMaxY(_goodsLabel.frame) + 15, K_MainWidth - 20, 30);
        _endTimeLabel.frame = CGRectMake(0, CGRectGetMaxY(_goodsLabel.frame) + 22, K_MainWidth / 2, 15);
        _grayView.frame = CGRectMake(10, CGRectGetMaxY(_blueView.frame), K_MainWidth - 20, 50);
        _marginLabel.frame = CGRectMake(K_MainWidth / 2 , CGRectGetMaxY(_goodsLabel.frame) + 22, K_MainWidth / 2, 15);
        _shipPasswordLabel.frame = CGRectMake(0, CGRectGetMaxY(_endTimeLabel.frame) + 22, K_MainWidth / 2, 15);
        _shipWeightLabel.frame = CGRectMake(K_MainWidth / 2 , CGRectGetMaxY(_endTimeLabel.frame) + 22, K_MainWidth / 2, 15);
    }
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

-(void)setContentWithMyshipModel:(MyShipModel *)myshipModel {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [dateFormatter dateFromString:myshipModel.shipOder.workTime];
    NSDate *date2 = [NSDate date];
    NSLog(@"%@",date1);
    int seconds = [date2 timeIntervalSinceDate:date1];
    [_totalLastTime addObject:[NSString stringWithFormat:@"%d",seconds]];
    [self startTimer];
    
    _endTimeLabel.text = [self lessSecondToDay:seconds];
    _logistNameLabel.text = myshipModel.shipOder.companyName;
    _startPlaceLabel.text = myshipModel.shipOder.beginPortName;
    _startPortLabel.text = myshipModel.shipOder.beginDockName;
    _endPlaceLabel.text = myshipModel.shipOder.endPortName;
    _endPortLabel.text = myshipModel.shipOder.endDockName;
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f元",myshipModel.shipOder.maxPay];
    _dateLabel.text = [NSString stringWithFormat:@"%@装船",myshipModel.shipOder.workTime];
    _weightLabel.text = [NSString stringWithFormat:@"%@吨",myshipModel.shipOder.amount];
    _goodsLabel.text = myshipModel.shipOder.cargos;
    _shipPasswordLabel.text = [NSString stringWithFormat:@"船队密码:%@",myshipModel.shipTeam.code];
    _shipWeightLabel.text = [NSString stringWithFormat:@"船队吨位:%@吨",myshipModel.shipTeam.allAccount];
}

-(void)setContentWithShipOrderModel:(ShipOrder *)shipOrderModel AndAllAccount:(NSString *)allAccount {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date1 = [dateFormatter dateFromString:shipOrderModel.workTime];
//    NSDate *date2 = [NSDate date];
//    NSLog(@"%@",date1);
//    int seconds = [date2 timeIntervalSinceDate:date1];
//    [_totalLastTime addObject:[NSString stringWithFormat:@"%d",seconds]];
//    [self startTimer];
//    
//    _endTimeLabel.text = [self lessSecondToDay:seconds];
    [_blueView removeFromSuperview];
    [_endTimeLabel removeFromSuperview];
    [_marginLabel removeFromSuperview];
    _logistNameLabel.text = shipOrderModel.companyName;
    _startPlaceLabel.text = shipOrderModel.beginPortName;
    _startPortLabel.text = shipOrderModel.beginDockName;
    _endPlaceLabel.text = shipOrderModel.endPortName;
    _endPortLabel.text = shipOrderModel.endDockName;
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f元",shipOrderModel.maxPay];
    _dateLabel.text = [NSString stringWithFormat:@"%@装船",shipOrderModel.workTime];
    _weightLabel.text = [NSString stringWithFormat:@"%@吨",shipOrderModel.amount];
    _goodsLabel.text = shipOrderModel.cargos;
    _shipPasswordLabel.text = [NSString stringWithFormat:@"船队密码:%@",shipOrderModel.code];
    _shipWeightLabel.text = [NSString stringWithFormat:@"船队吨位:%@吨",allAccount];
}

-(void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}

-(void)refreshLessTime {
    NSUInteger time;
    for (int i = 0; i < _totalLastTime.count; i++) {
        time = [_totalLastTime[i] integerValue];
        _endTimeLabel.text = [NSString stringWithFormat:@"%@",[self lessSecondToDay:--time]];
        NSString *newTime = [NSString stringWithFormat:@"%i",time];
        [_totalLastTime replaceObjectAtIndex:i withObject:newTime];
    }
}

- (NSString *)lessSecondToDay:(NSUInteger)seconds
{
    NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    NSString *time = [NSString stringWithFormat:@"%lu日%lu小时%lu分钟%lu秒",(unsigned long)day,(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    return time;
}
@end
