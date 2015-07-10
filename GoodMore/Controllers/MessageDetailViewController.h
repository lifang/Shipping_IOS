//
//  MessageDetailViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"
#import "MessageModel.h"

static NSString *RefreshMessageListNotification = @"RefreshMessageListNotification";

@interface MessageDetailViewController : CommonViewController

@property(nonatomic,strong)MessageModel *message;

@end
