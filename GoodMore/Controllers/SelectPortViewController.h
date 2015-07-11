//
//  SelectPortViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"

@protocol SelectPortDelegate <NSObject>

-(void)selectPortWithportId:(int)portId distance:(NSString*)distance;

@end

@interface SelectPortViewController : CommonViewController

@property(nonatomic,strong)id<SelectPortDelegate>delegate;

@end
