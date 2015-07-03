//
//  TaskCell.m
//  GoodMore
//
//  Created by lihongliang on 15/6/1.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "TaskCell.h"
#import "Constants.h"
@implementation TaskCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}
-(void)initUI
{
    CGFloat topSpace=10;
    CGFloat leftSpace=20;
    CGFloat bottomSpace=10;
    //CGFloat rightSpace=20;
    
    //地标图
    CGFloat size=15;
    CGFloat hSpace=3;
    CGFloat vSpace=10;
    
    //地点框长度
    CGFloat width = 160;
    CGFloat height = 20;
    
    //大横向间距
    CGFloat hSpaceBig= 3;
    //小label的尺寸
    CGFloat lWidth=80;
    CGFloat lHeight=20;
    
    UILabel *label1=[[UILabel alloc]init];
    label1.translatesAutoresizingMaskIntoConstraints=NO;
    label1.text=@"从";
    label1.textColor=kGrayColor;
    label1.textAlignment=NSTextAlignmentRight;
    label1.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:label1];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    
    UIImageView *imageView1=[[UIImageView alloc]init];
    imageView1.translatesAutoresizingMaskIntoConstraints=NO;
    imageView1.image=kImageName(@"from.png");
    [self.contentView addSubview:imageView1];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    
    _fromLabel=[[UILabel alloc]init];
    _fromLabel.translatesAutoresizingMaskIntoConstraints=NO;
    _fromLabel.textAlignment=NSTextAlignmentLeft;
    _fromLabel.textColor=kGrayColor;
    //_fromLabel.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:_fromLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_fromLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
    
    _statusBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _statusBtn.translatesAutoresizingMaskIntoConstraints=NO;
    //_statusBtn.backgroundColor=[UIColor orangeColor];
    [_statusBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _statusBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_statusBtn];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_statusBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20]];
    
    
    UILabel *label2=[[UILabel alloc]init];
    label2.translatesAutoresizingMaskIntoConstraints=NO;
    label2.text=@"至";
    label2.textColor=kGrayColor;
    label2.textAlignment=NSTextAlignmentRight;
    label2.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:label2];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:vSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:leftSpace]];
    
    UIImageView *imageView2=[[UIImageView alloc]init];
    imageView2.translatesAutoresizingMaskIntoConstraints=NO;
    imageView2.image=kImageName(@"to.png");
    [self.contentView addSubview:imageView2];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    
    _toLabel=[[UILabel alloc]init];
    _toLabel.translatesAutoresizingMaskIntoConstraints=NO;
    _toLabel.textAlignment=NSTextAlignmentLeft;
    _toLabel.textColor=kGrayColor;
    //_toLabel.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:_toLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_toLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
    
    UIImageView *imageView3=[[UIImageView alloc]init];
    imageView3.translatesAutoresizingMaskIntoConstraints=NO;
    imageView3.image=kImageName(@"what.png");
    [self.contentView addSubview:imageView3];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView3 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-bottomSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    
    _whatLabel=[[UILabel alloc]init];
    _whatLabel.translatesAutoresizingMaskIntoConstraints=NO;
    //_whatLabel.backgroundColor=[UIColor redColor];
    _whatLabel.textAlignment=NSTextAlignmentLeft;
    _whatLabel.textColor=kGrayColor;
    _whatLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_whatLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_whatLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView3 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_whatLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView3 attribute:NSLayoutAttributeRight multiplier:1.0 constant:5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_whatLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:lWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_whatLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:lHeight]];
    
    UIImageView *imageView4=[[UIImageView alloc]init];
    imageView4.translatesAutoresizingMaskIntoConstraints=NO;
    imageView4.image=kImageName(@"weight.png");
    [self.contentView addSubview:imageView4];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView4 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-bottomSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView4 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_whatLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpaceBig]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    
    _moneyLabel=[[UILabel alloc]init];
    _moneyLabel.translatesAutoresizingMaskIntoConstraints=NO;
    //_moneyLabel.backgroundColor=[UIColor redColor];
    _moneyLabel.textAlignment=NSTextAlignmentLeft;
    _moneyLabel.textColor=kGrayColor;
    _moneyLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_moneyLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView4 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView4 attribute:NSLayoutAttributeRight multiplier:1.0 constant:5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:lWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:lHeight]];
    
    _distanceImV=[[UIImageView alloc]init];
    _distanceImV.translatesAutoresizingMaskIntoConstraints=NO;
    //imageView5.image=kImageName(@"where.png");
    [self.contentView addSubview:_distanceImV];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_distanceImV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-bottomSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_distanceImV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_moneyLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:hSpaceBig]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_distanceImV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_distanceImV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:size]];
    
    _whereLabel=[[UILabel alloc]init];
    _whereLabel.translatesAutoresizingMaskIntoConstraints=NO;
    //_whereLabel.backgroundColor=[UIColor redColor];
    _whereLabel.textAlignment=NSTextAlignmentLeft;
    _whereLabel.textColor=kGrayColor;
    _whereLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_whereLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_whereLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_distanceImV attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_whereLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_distanceImV attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_whereLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:lWidth]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_whereLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:lHeight]];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
