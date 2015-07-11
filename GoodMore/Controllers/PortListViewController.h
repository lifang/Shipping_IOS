//
//  PortListViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"


@protocol PortListDelegate <NSObject>

-(void)getPortInfoWithportInfo:(NSString *)portInfo portID:(int)portID index:(NSInteger)index;

@end

@interface PortListViewController : CommonViewController

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,assign)id <PortListDelegate> delegate;

@end
