//
//  TopButton.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "TopButton.h"

#define BtnWidth 120.f
#define BtnHeight 40.f
#define imageWidth 18.f
#define imageHeight 12.f

@implementation TopButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _imageV = [[UIImageView alloc]init];
        _imageV.image = [UIImage imageNamed:@"sanjiao"];
        [self addSubview:_imageV];
        
        _firstBtn = [[UIButton alloc]init];
        _firstBtn.tag = BtnTypeOne;
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_firstBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _firstBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_firstBtn];
        
        _secondBtn = [[UIButton alloc]init];
        _secondBtn.tag = BtnTypeTwo;
        _secondBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_secondBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _secondBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_secondBtn];
        
        _rightIcon = [[UIButton alloc]init];
        [_rightIcon setBackgroundColor:[UIColor clearColor]];
        _rightIcon.tag = BtnTypeIcon;
        [_rightIcon addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightIcon setBackgroundImage:[UIImage imageNamed:@"head_small"] forState:UIControlStateNormal];
        [self addSubview:_rightIcon];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _firstBtn.frame = CGRectMake(20, 5, BtnWidth, BtnHeight);
    _secondBtn.frame = CGRectMake(CGRectGetMaxX(_firstBtn.frame), 5, BtnWidth, BtnHeight);
    _imageV.frame = CGRectMake(_firstBtn.frame.origin.x + BtnWidth / 2 - 5, CGRectGetMaxY(_firstBtn.frame) - imageHeight + 3 , 10, 9);
    _rightIcon.frame = CGRectMake(CGRectGetMaxX(_secondBtn.frame) + 20, 10, 24, 24);
}

-(void)btnClicked:(UIButton *)btn {
    
    if (_delegate && [_delegate respondsToSelector:@selector(TopBtnClickedWithBtnType:)]) {
        [_delegate TopBtnClickedWithBtnType:(BtnType)btn.tag];
    }
    
    switch (btn.tag) {
        case BtnTypeOne:
        {
            [UIView animateWithDuration:0.2 animations:^{
                _imageV.frame = CGRectMake(_firstBtn.frame.origin.x + BtnWidth / 2 - 5, CGRectGetMaxY(_firstBtn.frame) - imageHeight + 3 , 10, 9);
            }];
        }
            break;
        case BtnTypeTwo:
        {
            [UIView animateWithDuration:0.2 animations:^{
                _imageV.frame = CGRectMake(_secondBtn.frame.origin.x + BtnWidth / 2 - 5, CGRectGetMaxY(_firstBtn.frame) - imageHeight + 3 , 10, 9);
            }];
        }
            break;
            case BtnTypeIcon:
            
            break;
            
        default:
            break;
    }
}

@end
