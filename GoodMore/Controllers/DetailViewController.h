//
//  DetailViewController.h
//  GoodMore
//
//  Created by lihongliang on 15/6/1.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//


#import "CommonViewController.h"

@interface DetailViewController : CommonViewController

@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic,assign)int ID;

@property(nonatomic,assign)int canMT;//记录能否组队接单

@end
