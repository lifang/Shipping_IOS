//
//  PayFreightViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/6/25.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"

@interface PayFreightViewController : CommonViewController

@property(nonatomic,strong)NSArray *shipListArray;//参与的船舶
@property(nonatomic,strong)NSNumber *paidMoney; //船队的运费
@property(nonatomic,strong)NSNumber *shipTeamID;
@end
