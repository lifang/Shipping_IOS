//
//  RefreshViewController.h
//  GoodMore
//
//  Created by comdosoft on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "CommonViewController.h"
#import "RefreshView.h"

@interface RefreshViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>

@property (nonatomic, strong) UITableView *tableView;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
//********************************

/**父类初始化*/
- (void)initRefreshViewWithOffset:(CGFloat)offset;

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction;

- (void)updateFooterViewFrame;

//下拉刷新
- (void)pullDownToLoadData;
//上拉加载更多
- (void)pullUpToLoadData;

@end
