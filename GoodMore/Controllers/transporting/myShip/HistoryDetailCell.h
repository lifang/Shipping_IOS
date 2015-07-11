//
//  HistoryDetailCell.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShipModel.h"

#define HistoryDetailCellHeight 80

@interface HistoryDetailCell : UITableViewCell

@property(nonatomic,strong)UIImageView *leftTopView;

@property(nonatomic,strong)UILabel *logistNameLabel;

@property(nonatomic,strong)UILabel *weightLabel;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *phoneNumLabel;

-(void)setContentWithShipInTeamModel:(ShipInTeam *)shipInTeamModel;

@end
