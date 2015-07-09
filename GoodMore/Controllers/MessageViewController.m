//
//  MessageViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MessageViewController.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "NetWorkInterface.h"


@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
   
}
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isMultiDelete;

@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我的消息";
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(showEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self initAndLayoutUI];
}
- (void)setIsMultiDelete:(BOOL)isMultiDelete {
    _isMultiDelete = isMultiDelete;
    [_tableView setEditing:_isMultiDelete animated:YES];
    if (_isMultiDelete) {
        [[UIApplication sharedApplication].delegate.window addSubview:_bottomView];
    }
    else {
        //[_selectedItem removeAllObjects];
        [_bottomView removeFromSuperview];
    }
    NSString *rightName = nil;
    if (_isMultiDelete) {
        rightName = @"取消";
    }
    else {
        rightName = @"编辑";
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:rightName
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(showEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)initAndLayoutUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    
    [self initBottomView];
}

- (void)initBottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    firstLine.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:firstLine];
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(10, 7, 80, 36);
    readBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [readBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [readBtn setTitle:@"标注为已读" forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(setReadAll:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:readBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kScreenWidth - 60, 7, 60, 36);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteMessage:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:deleteBtn];
}

- (void)setHeaderAndFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}


#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messageIndefier=@"messageIndentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:messageIndefier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageIndefier];
    }
    cell.textLabel.text=@"组队成功消息!";
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isMultiDelete) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }

}
#pragma mark action
-(IBAction)back:(id)sender
{
    //返回主页面
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [self.mm_drawerController setCenterViewController:delegate.rootViewController.mainController withCloseAnimation:YES completion:nil];
}
//编辑
-(IBAction)showEdit:(id)sender
{
    if (!_isMultiDelete && _tableView.isEditing) {
        _tableView.editing = NO;
    }
    self.isMultiDelete = !_isMultiDelete;
}
//标记为已读
-(IBAction)setReadAll:(id)sender
{
    
}
//删除消息
-(IBAction)deleteMessage:(id)sender
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
