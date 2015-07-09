//
//  MYInfo.h
//  侧滑栏
//
//  Created by lihongliang on 15/7/7.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYInfoViewDelegate <NSObject>

-(void)selectInfoWithIndex:(NSInteger)index;

@end

@interface MYInfoView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_data;
}

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *phone;
@property(nonatomic,strong)UILabel *cash;

@property(nonatomic,strong)id <MYInfoViewDelegate> delegate;

@end
