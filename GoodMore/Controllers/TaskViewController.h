//
//  TaskViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/5/29.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//



#import "CommonViewController.h"


static NSString *PortListNotification = @"PortListNotification";

@interface TaskViewController : CommonViewController

//@property(nonatomic,assign)NSInteger index;

@property(nonatomic,assign)int portId;

@property(nonatomic,strong)NSString *distance;

@end
