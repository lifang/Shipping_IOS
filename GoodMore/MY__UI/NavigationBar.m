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
    
    //字体属性
    NSDictionary *textDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil];
    
    nav.navigationBar.titleTextAttributes=textDict;
    
    //导航栏的颜色
    nav.navigationBar.barTintColor=kLightColor;
    
    nav.navigationBar.tintColor = [UIColor whiteColor];
}

@end
