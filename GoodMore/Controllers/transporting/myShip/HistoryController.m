//
//  HistoryController.m
//  GoodMore
//
//  Created by 黄含章 on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "HistoryController.h"
#import "ShipHistoryCell.h"
#import "HistoryDetailController.h"

@interface HistoryController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HistoryController

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(0, 0, K_MainWidth, K_MainHeight - 60 * 2);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark -- UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShipHistoryCell *cell = [[ShipHistoryCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:PushToHistoryDetailNotification object:nil userInfo:nil];
}

@end
