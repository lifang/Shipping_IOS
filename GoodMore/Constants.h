
//
//  Constants.h
//  GoodMore
//
//  Created by lihongliang on 15/5/29.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#ifndef GoodMore_Constants_h
#define GoodMore_Constants_h

#define kDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#import "MBProgressHUD.h"
#import "NetworkInterface.h"
//UI主体颜色
#define kMainColor [UIColor colorWithRed:3/255.0 green:127/255.0 blue:212/255.0 alpha:1.0]

#define kColor(r,g,b,a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
//我的钱包未选中的字体颜色  81BFEA
#define kTitleColor [UIColor colorWithRed:129/255.0 green:191/255.0 blue:234/255.0 alpha:1.0]
//我的钱包常用字体颜色   757474
#define kWalletTitleColor [UIColor colorWithRed:117/255.0 green:116/255.0 blue:116/255.0 alpha:1.0]
//弹出View的颜色
#define kViewColor [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0]
#define kGrayColor [UIColor grayColor]

#define kImageName(name) [UIImage imageNamed:name]

//正式
#define KServiceURL @"http://120.25.243.169:8080/HDDPlatForm/"

//测试
//#define KServiceURL @"http://120.25.243.169:8888/HDDPlatForm/"

//本地
//#define KServiceURL @"http://192.168.0.163:8080/HDDPlatForm/"

#define kAppVersionType  2   //版本更新


#define kServiceReturnWrong  @"服务端数据返回错误"
#define kNetworkFailed       @"网络连接失败"

#endif
