//
//  PayNumberCell.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "PayNumberCell.h"

@implementation PayNumberCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *v = [[UIView alloc]init];
        v.frame = CGRectMake(10, 5, self.frame.size.width - 20, ShipDetailCellHeight - 10);
        CALayer *readBtnLayer = [v layer];
        [readBtnLayer setMasksToBounds:YES];
        [readBtnLayer setCornerRadius:1.0];
        [readBtnLayer setBorderWidth:0.5];
        [readBtnLayer setBorderColor:[kColor(200, 200, 200, 0.7) CGColor]];
        [self.contentView addSubview:v];
        
        UIView *v2 = [[UIView alloc]init];
        v2.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = v2;
        
        _leftTopView = [[UIImageView alloc]init];
        _leftTopView.image = [UIImage imageNamed:@"headShip"];
        _leftTopView.frame = CGRectMake(12, 8, 15, 15);
        _leftTopView.hidden = YES;
        [self.contentView addSubview:_leftTopView];
        
        _logistNameLabel = [[UILabel alloc]init];
        _logistNameLabel.text = @"汇通115";
        _logistNameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_logistNameLabel];
        
        _weightLabel = [[UILabel alloc]init];
        _weightLabel.text = @"2000吨";
        _weightLabel.font = [UIFont systemFontOfSize:13];
        _weightLabel.textColor = kColor(107, 107, 107, 1.0);
        [self.contentView addSubview:_weightLabel];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"叶森";
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nameLabel];
        
        _phoneNumLabel = [[UILabel alloc]init];
        _phoneNumLabel.text = @"18566669999";
        _phoneNumLabel.font = [UIFont systemFontOfSize:13];
        _phoneNumLabel.textColor = kColor(107, 107, 107, 1.0);
        [self.contentView addSubview:_phoneNumLabel];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.hidden = YES;
        _priceLabel.text = @"￥2.00";
        _priceLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_priceLabel];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = kColor(201, 201, 201, 0.6);
        line.frame = CGRectMake(K_MainWidth / 4 * 3.1, 20, 1, 40);
        [self.contentView addSubview:line];
        
        _setBtn = [[UIButton alloc]init];
        [_setBtn addTarget:self action:@selector(setClicked) forControlEvents:UIControlEventTouchUpInside];
        _setBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_setBtn setTitle:@"设置运费" forState:UIControlStateNormal];
        [_setBtn setBackgroundColor:[UIColor clearColor]];
        [_setBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_setBtn];
        
        _resetBtn = [[UIButton alloc]init];
        [_resetBtn addTarget:self action:@selector(resetClicked) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_resetBtn setTitle:@"重置运费" forState:UIControlStateNormal];
        [_resetBtn setBackgroundColor:[UIColor clearColor]];
        [_resetBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_resetBtn];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _logistNameLabel.frame = CGRectMake(CGRectGetMaxX(_leftTopView.frame), CGRectGetMaxY(_leftTopView.frame) - 5, 120,30);
    
    _weightLabel.frame = CGRectMake(_logistNameLabel.frame.origin.x , CGRectGetMaxY(_logistNameLabel.frame) - 8, 120, 20);
    
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_logistNameLabel.frame) - 40, _logistNameLabel.frame.origin.y, 200, 30);
    
    _phoneNumLabel.frame = CGRectMake(CGRectGetMaxX(_weightLabel.frame) - 42, CGRectGetMaxY(_logistNameLabel.frame) - 8, 240, 20);
    
    _priceLabel.frame = CGRectMake(K_MainWidth - 62, CGRectGetMaxY(_logistNameLabel.frame) - 35, 100, 30);
    
    _setBtn.frame = CGRectMake(K_MainWidth - 75, CGRectGetMaxY(_logistNameLabel.frame) - 20, 70, 20);
    
    _resetBtn.frame = CGRectMake(K_MainWidth - 75, CGRectGetMaxY(_logistNameLabel.frame) - 10, 70, 20);
}

-(void)setClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(setClickedWithIndex:)]) {
        [_delegate setClickedWithIndex:_index];
    }
}

-(void)resetClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(resetClickedWithIndex:)]) {
        [_delegate resetClickedWithIndex:_index];
    }
}

-(void)setPayNumContentWithShipInTeamModel:(ShipInTeam *)shipInTeamModel {
    if ([shipInTeamModel.isLeader isEqualToString:@"1"]) {
        _leftTopView.hidden = NO;
    }
    _logistNameLabel.text = shipInTeamModel.shipNumber;
    _nameLabel.text = shipInTeamModel.name;
    _weightLabel.text = [NSString stringWithFormat:@"%@吨",shipInTeamModel.volume];
    _phoneNumLabel.text = shipInTeamModel.phone;
}
@end
