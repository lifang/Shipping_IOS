//
//  TransportingViewController.m
//  GoodMore
//
//  Created by lihongliang on 15/7/7.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "TransportingViewController.h"
#import "Constants.h"
#import "MYInfoView.h"
#import "UIViewController+MMDrawerController.h"
@interface TransportingViewController ()
{
    
}
@end

@implementation TransportingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithImage:kImageName(@"head_small.png") style:UIBarButtonItemStyleDone target:self action:@selector(showRight:)];
//    self.navigationItem.rightBarButtonItem=rightItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(showRight:)];
    self.navigationItem.rightBarButtonItem = rightItem;


}

-(IBAction)showRight:(id)sender
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
