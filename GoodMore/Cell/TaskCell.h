//
//  TaskCell.h
//  GoodMore
//
//  Created by lihongliang on 15/6/1.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

@property(nonatomic,strong)UILabel *fromLabel;
@property(nonatomic,strong)UILabel *toLabel;
@property(nonatomic,strong)UIButton *statusBtn;
@property(nonatomic,strong)UILabel *whatLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *whereLabel;

@end
