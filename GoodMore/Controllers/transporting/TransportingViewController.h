//
//  TransportingViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/7/7.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"
typedef enum {
    ArriveLoading = 1,
    Loading,
    ArriveUnloading,
    Unloading,
    Complete,
}Status;


static NSString *RefreshListNotification = @"RefreshListNotification";

@interface TransportingViewController : CommonViewController

@end
