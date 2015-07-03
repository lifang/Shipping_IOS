//
//  ImageCollectionViewCell.m
//  GoodMore
//
//  Created by lihongliang on 15/6/29.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI
{
    _imv=[[UIImageView alloc]init];
    _imv.frame=CGRectMake(0, 0, 60, 60);
    [self.contentView addSubview:_imv];
   
}

@end
