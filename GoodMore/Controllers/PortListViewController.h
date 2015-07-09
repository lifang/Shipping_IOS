//
//  PortListViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"


@protocol PortListDelegate <NSObject>

-(void)getPortInfo:(NSString *)portInfo;

@end

@interface PortListViewController : CommonViewController

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,assign)id <PortListDelegate> delegate;

@end
