//
//  NavigationBar.m
//  CustomSelect
//
//  Created by lihongliang on 15/5/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "NavigationBar.h"
#import "Constants.h"
@implementation NavigationBar

+(void)setNavigationBarStyle:(UINavigationController *)nav
{
    //[nav.navigationBar setBackgroundImage:[[UIImage imageNamed:@"blue.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 1, 21, 1)] forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *textDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
    nav.navigationBar.titleTextAttributes=textDict;
    
    nav.navigationBar.barTintColor=kMainColor;
   
    nav.navigationBar.tintColor = [UIColor whiteColor];
}

@end
