//
//  AddCollectionViewCell.m
//  GoodMore
//
//  Created by lihongliang on 15/6/29.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "AddCollectionViewCell.h"
#import "Constants.h"
@implementation AddCollectionViewCell

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
    _addButton=[[UIButton alloc]init];
    _addButton.frame=CGRectMake(0, 0, 60, 60);
    [_addButton setBackgroundImage:kImageName(@"add.png") forState:UIControlStateNormal];
    [self.contentView addSubview:_addButton];
}
@end
