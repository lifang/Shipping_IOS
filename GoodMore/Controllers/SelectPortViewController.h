//
//  SelectPortViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"

@protocol SelectPortDelegate <NSObject>

-(void)selectPortWithloadportId:(int)loadportId unloadportId:(int)unloadportId;

@end

@interface SelectPortViewController : CommonViewController

@property(nonatomic,strong)id<SelectPortDelegate>delegate;

@end
