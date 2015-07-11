//
//  MessageDetailViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/10.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "NetWorkInterface.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"消息详情";
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self changeMessageStatus];
    
    
}
-(void)initUI
{
    CGFloat leftSpace=10;
    CGFloat topSpace=10;
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace, kScreenWidth-leftSpace*2, 30)];
    title.text=_message.title;
    title.font=[UIFont boldSystemFontOfSize:20];
    title.textColor=[UIColor blackColor];
    [self.view addSubview:title];
    
    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30, kScreenWidth-leftSpace*2, 20)];
    time.text=_message.createTime;
    time.font=[UIFont systemFontOfSize:12];
    time.textColor=[UIColor grayColor];
    [self.view addSubview:time];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+20, kScreenWidth-leftSpace*2, 1)];
    line.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line];
    
    
    
    UITextView *content=[[UITextView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+20+10, kScreenWidth-leftSpace*2, kScreenHeight-(topSpace+30+20+10))];
    content.text=_message.content;
    content.textColor=kGrayColor;
    content.editable=NO;
    content.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:content];
}
-(void)changeMessageStatus
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber *loginId=[userDefault objectForKey:@"loginId"];

    NSNumber *ID=_message.ID;
    NSArray *messageID=[[NSArray alloc]initWithObjects:ID, nil];
    [NetWorkInterface uploadMessageStausWithStatus:1 loginId:[loginId intValue] idStr:messageID finished:^(BOOL success, NSData *response) {
        
        NSLog(@"----标记为已读---!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    //hud.labelText = @"标注成功";
                    //[self updateMessageStautsForRead];
                    
                    [self initUI];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
