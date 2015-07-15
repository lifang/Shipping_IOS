//
//  ShipDetailCell.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ShipDetailCell.h"

@interface ShipDetailCell()

@property(nonatomic,assign)BOOL isExit;

@end

@implementation ShipDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isExit = NO;
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
        
        _deleteBtn = [[UIButton alloc]init];
        if ([reuseIdentifier isEqualToString:@"cell1"] || [reuseIdentifier isEqualToString:@"cell3"]) {
            _deleteBtn.hidden = YES;
        }
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        if ([reuseIdentifier isEqualToString:@"cell2"]) {
            [_deleteBtn setTitle:@"同意" forState:UIControlStateNormal];
        }
        [_deleteBtn setTitleColor:kColor(235, 88, 16, 1.0) forState:UIControlStateNormal];
        if ([reuseIdentifier isEqualToString:@"cell2"]) {
            [_deleteBtn addTarget:self action:@selector(agreenClicked) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_deleteBtn addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.contentView addSubview:_deleteBtn];
        
    }
    return self;
}

-(void)deleteClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteDataWithSelectedID:AndIsExit:)]) {
        [_delegate deleteDataWithSelectedID:_selectedID AndIsExit:_isExit];
    }
}

-(void)agreenClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(agreenWithSelectedID:)]) {
        [_delegate agreenWithSelectedID:_selectedID];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _logistNameLabel.frame = CGRectMake(CGRectGetMaxX(_leftTopView.frame), CGRectGetMaxY(_leftTopView.frame) - 5, 120,30);
    
    _weightLabel.frame = CGRectMake(_logistNameLabel.frame.origin.x , CGRectGetMaxY(_logistNameLabel.frame) - 8, 120, 20);
    
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_logistNameLabel.frame) - 40, _logistNameLabel.frame.origin.y, 200, 30);
    
    _phoneNumLabel.frame = CGRectMake(CGRectGetMaxX(_weightLabel.frame) - 42, CGRectGetMaxY(_logistNameLabel.frame) - 8, 240, 20);
    
    _priceLabel.frame = CGRectMake(CGRectGetMaxX(_phoneNumLabel.frame) - 150, CGRectGetMaxY(_logistNameLabel.frame) - 25, 100, 30);
    
    _deleteBtn.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) - 40, _priceLabel.frame.origin.y, 40, 30);
    
}

-(void)setContentWithShipInTeamModel:(ShipInTeam *)shipInTeamModel AndMyShipModel:(MyShipModel *)myshipModel{
    if ([myshipModel.isTeamLeader isEqualToString:@"1"]) {
        _priceLabel.hidden = NO;
        if ([shipInTeamModel.isLeader isEqualToString:@"1"]) {
            _leftTopView.hidden = NO;
            _priceLabel.hidden = YES;
        }
        if ([shipInTeamModel.isSelf isEqualToString:@"1"]) {
            
        }else{
            _deleteBtn.hidden = NO;
        }
    }else{
        if ([shipInTeamModel.isLeader isEqualToString:@"1"]) {
            _leftTopView.hidden = NO;
        }
        if ([shipInTeamModel.isSelf isEqualToString:@"1"]) {
            _isExit = YES;
            [_deleteBtn setTitle:@"退出" forState:UIControlStateNormal];
            _deleteBtn.hidden = NO;
        }else{
            _deleteBtn.hidden = YES;
        }
    }
    _logistNameLabel.text = shipInTeamModel.shipName;
    _weightLabel.text = [NSString stringWithFormat:@"%@吨",shipInTeamModel.volume];
    _nameLabel.text = shipInTeamModel.name;
    _phoneNumLabel.text = shipInTeamModel.phone;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",shipInTeamModel.submitMoney];
}

-(void)setContentWithShipnoInTeamModel:(ShipInTeam *)shipInTeamModel {
    _priceLabel.hidden = NO;
    _logistNameLabel.text = shipInTeamModel.shipName;
    _weightLabel.text = [NSString stringWithFormat:@"%@吨",shipInTeamModel.volume];
    _nameLabel.text = shipInTeamModel.name;
    _phoneNumLabel.text = shipInTeamModel.phone;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",shipInTeamModel.submitMoney];
}

-(void)setContentWithShipRankTeamModel:(ShipInTeam *)shipInTeamModel {
    _priceLabel.hidden = NO;
    _logistNameLabel.text = shipInTeamModel.shipName;
    _weightLabel.text = [NSString stringWithFormat:@"%@吨",shipInTeamModel.volume];
    _nameLabel.text = shipInTeamModel.name;
    _phoneNumLabel.text = shipInTeamModel.phone;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",shipInTeamModel.submitMoney];
}

@end
