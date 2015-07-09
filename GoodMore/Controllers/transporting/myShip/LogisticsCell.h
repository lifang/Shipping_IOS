//
//  LogisticsCell.h
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogisticsCell : UITableViewCell
/** 物流名字 */
@property(nonatomic,strong)UILabel *logistNameLabel;
/** 开始地 */
@property(nonatomic,strong)UILabel *startPlaceLabel;
/** 开始港口 */
@property(nonatomic,strong)UILabel *startPortLabel;
/** 结束地 */
@property(nonatomic,strong)UILabel *endPlaceLabel;
/** 结束港口 */
@property(nonatomic,strong)UILabel *endPortLabel;
/** 运费 */
@property(nonatomic,strong)UILabel *moneyLabel;
/** 装船时间 */
@property(nonatomic,strong)UILabel *dateLabel;
/** 货物重量 */
@property(nonatomic,strong)UILabel *weightLabel;
/** 货物种类 */
@property(nonatomic,strong)UILabel *goodsLabel;
/** 结束倒计时 */
@property(nonatomic,strong)UILabel *endTimeLabel;
/** 保证金 */
@property(nonatomic,strong)UILabel *marginLabel;
/** 船队密码 */
@property(nonatomic,strong)UILabel *shipPasswordLabel;
/** 船队吨位 */
@property(nonatomic,strong)UILabel *shipWeightLabel;
/** 组队成功 */
@property(nonatomic,strong)UILabel *successTeam;

@end
