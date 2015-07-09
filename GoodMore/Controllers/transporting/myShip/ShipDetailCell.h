//
//  ShipDetailCell.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//点击协议
@protocol ShipDetailCellDelegate <NSObject>

@optional

-(void)deleteDataWithSelectedID:(NSString *)selectedID;

@end
#define ShipDetailCellHeight 80

@interface ShipDetailCell : UITableViewCell

@property(nonatomic,strong)UIImageView *leftTopView;

@property(nonatomic,strong)UILabel *logistNameLabel;

@property(nonatomic,strong)UILabel *weightLabel;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *phoneNumLabel;

@property(nonatomic,strong)UILabel  *priceLabel;

@property(nonatomic,strong)UIButton *deleteBtn;

@property(nonatomic,strong)NSString *selectedID;

@property(nonatomic,weak)id<ShipDetailCellDelegate> delegate;

@end
