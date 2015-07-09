//
//  HistoryDetailCell.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "HistoryDetailCell.h"

@implementation HistoryDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *v = [[UIView alloc]init];
        v.frame = CGRectMake(10, 5, self.frame.size.width - 20, HistoryDetailCellHeight - 10);
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
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _logistNameLabel.frame = CGRectMake(CGRectGetMaxX(_leftTopView.frame), CGRectGetMaxY(_leftTopView.frame) - 5, 120,30);
    
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_leftTopView.frame), CGRectGetMaxY(_logistNameLabel.frame) , 120, 20);
    
    _weightLabel.frame = CGRectMake(CGRectGetMaxX(_logistNameLabel.frame) - 40, CGRectGetMaxY(_leftTopView.frame) - 5, 200, 30);
    
    _phoneNumLabel.frame = CGRectMake(CGRectGetMaxX(_logistNameLabel.frame) - 40, CGRectGetMaxY(_weightLabel.frame) , 240, 20);
    
}
@end
