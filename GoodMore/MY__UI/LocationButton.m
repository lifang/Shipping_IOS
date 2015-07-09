//
//  LocationButton.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "LocationButton.h"
#import "Constants.h"
@interface LocationButton ()

@end

@implementation LocationButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAndLayoutUI];
    }
    return self;
}


#pragma mark - UI

- (void)initAndLayoutUI {
    //CGFloat centerY = self.frame.size.height / 2 + self.frame.origin.y;
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (24-17)/2, 17, 17)];
    locationView.image = kImageName(@"choose.png");
    [self addSubview:locationView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationView.bounds.size.width, 0, 70, 24)];
    //_nameLabel.backgroundColor=[UIColor orangeColor];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:16.f];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.minimumScaleFactor = .8f;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
    
//    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width, centerY - 2, 9, 5)];
//    arrowView.image = kImageName(@"home_arrow.png");
//    [self addSubview:arrowView];
}

#pragma mark - Rewriten

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        _nameLabel.textColor = [UIColor grayColor];
    }
    else {
        _nameLabel.textColor = [UIColor whiteColor];
    }
}

@end
