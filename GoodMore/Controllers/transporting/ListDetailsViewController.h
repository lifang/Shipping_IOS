//
//  ListDetailsViewController.h
//  GoodMore
//
//  Created by comdosoft on 15/7/11.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"

@interface ListDetailsViewController : CommonViewController
@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic,assign)int ID;

@property(nonatomic,assign)int canMT;//记录能否组队接单
@end
