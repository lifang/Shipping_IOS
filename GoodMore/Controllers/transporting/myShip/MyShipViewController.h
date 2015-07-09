//
//  MyShipViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"
typedef enum {
    TableViewTypeTeam = 201, //组队tableview
    TableViewTypeHistory,    //历史记录tableview
}TableViewType;

static NSString *PushToHistoryDetailNotification = @"PushToHistoryDetailNotification";

@interface MyShipViewController : CommonViewController

@end
