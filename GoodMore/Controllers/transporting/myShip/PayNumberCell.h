//
//  PayNumberCell.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShipModel.h"
//点击协议
@protocol PayNumberCellDelegate <NSObject>

@optional

-(void)setClickedWithIndex:(NSIndexPath *)index;

-(void)resetClickedWithIndex:(NSIndexPath *)index;

@end
#define ShipDetailCellHeight 80
@interface PayNumberCell : UITableViewCell

@property(nonatomic,strong)UIImageView *leftTopView;

@property(nonatomic,strong)UILabel *logistNameLabel;

@property(nonatomic,strong)UILabel *weightLabel;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *phoneNumLabel;

@property(nonatomic,strong)UILabel  *priceLabel;

@property(nonatomic,strong)UIButton *setBtn;

@property(nonatomic,strong)UIButton *resetBtn;

@property(nonatomic,strong)NSIndexPath *index;

@property(nonatomic,weak)id<PayNumberCellDelegate> delegate;

-(void)setPayNumContentWithShipInTeamModel:(ShipInTeam *)shipInTeamModel;
@end
