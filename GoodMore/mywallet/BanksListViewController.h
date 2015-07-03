//
//  BanksListViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/6/23.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"
#import "BanksModel.h"
@protocol BanksListDelegate <NSObject>

-(void)getSelectBank:(BanksModel*)bank;

@end

@interface BanksListViewController : CommonViewController
@property(nonatomic,assign)id<BanksListDelegate>delegate;
@end
