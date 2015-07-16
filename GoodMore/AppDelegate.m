//
//  AppDelegate.m
//  GoodMore
//
//  Created by lihongliang on 15/5/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "AppDelegate.h"
#import "NetWorkInterface.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import "MyWalletViewController.h"
#import "BPush.h"

@interface AppDelegate ()<CLLocationManagerDelegate,BPushDelegate>
{
    
    CLLocationManager *_locationManager;
    NSTimer *_timer;
}
@property(nonatomic,assign)CLLocationDegrees latitude;
@property(nonatomic,assign)CLLocationDegrees longitude;

@end

@implementation AppDelegate

+ (AppDelegate *)shareAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    
    
    _rootViewController=[[RootViewController alloc]init];
    self.window.rootViewController=_rootViewController;
    
    [self getUserLocation];
    

    _timer = [NSTimer scheduledTimerWithTimeInterval:15*60 target:self selector:@selector(getUserLocation) userInfo:nil repeats:YES];
    
    [self.window makeKeyAndVisible];
    
    //******百度推送******
    // iOS8 下需要使⽤用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound
        | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    // 上线 AppStore 时需要修改 pushMode
    // 在 App 启动时注册百度云推送服务,需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"Wcs9yGqEzHeklGTxhsj6IyK3" pushMode:BPushModeDevelopment isDebug:NO];
    // 设置 BPush 的回调
    [BPush setDelegate:self];
    // App 是⽤用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    
    return YES;
}


#pragma mark ---定位----
-(void)getUserLocation
{
    if ([CLLocationManager locationServicesEnabled])
    {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        if (kDeviceVersion >= 8.0){
            [_locationManager requestWhenInUseAuthorization];
        }
        
        [_locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation =[locations lastObject];
    
    CLLocationCoordinate2D coordinate=currentLocation.coordinate;
    self.latitude=coordinate.latitude;
    self.longitude=coordinate.longitude;
    NSNumber *latitude=[NSNumber numberWithDouble:coordinate.latitude];
    NSNumber *longitude=[NSNumber numberWithDouble:coordinate.longitude];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:latitude forKey:@"latitude"];
    [userDefault setObject:longitude forKey:@"longitude"];
    [userDefault synchronize];
    

}
//获取用户位置数据失败回调的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.latitude=0;
    self.longitude=0;
    NSNumber *latitude=[NSNumber numberWithDouble:self.latitude];
    NSNumber *longitude=[NSNumber numberWithDouble:self.longitude];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:latitude forKey:@"latitude"];
    [userDefault setObject:longitude forKey:@"longitude"];
    [userDefault synchronize];
    
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown)
    {
        //无法获取位置信息
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"获取当前位置失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//**************推送
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
//调用API,注册deviceToken,并且绑定Push服务
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken];
    //[BPush bindChannel];
}
//若上面的方法不被调用,可以实现下面的方法来查看原因
//******  当deviceToken获取失败时,系统会回调此方法  **********
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"deviceToken获取失败,原因:%@",error);
}
//处理接收到的Push消息
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //收到推送通知
    [BPush handleNotification:userInfo];
    NSLog(@"------------收到推送通知:userInfo:%@",[userInfo description]);
//    if (application.applicationState==UIApplicationStateActive)
//    {
//        //前台
//    }else
//    {
//        //后台
//        
//    }
    if (userInfo)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您有新消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
    
}
//API调用返回结果:
-(void)onMethod:(NSString *)method response:(NSDictionary *)data
{
    NSLog(@"method:%@",method);
    NSLog(@"data:%@",[data description]);
    
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:data];
    if ([BPushRequestMethodBind isEqualToString:method])
    {
        NSString *appID = [dic valueForKey:BPushRequestAppIdKey];
        NSString *channelID=[dic valueForKey:BPushRequestChannelIdKey];
        NSString *userID = [dic valueForKey:BPushRequestUserIdKey];
        int returnCode=[[dic valueForKey:BPushRequestErrorCodeKey] intValue];
        
        NSLog(@"-------%@,%@,%@,%d",appID,channelID,userID,returnCode);
        
        if (returnCode==0)
        {
            [self uploadPushChannelID:channelID];
        }
    }
    
}
-(void)uploadPushChannelID:(NSString*)channelID
{
    NSString *deviceCode=[NSString stringWithFormat:@"1%@",channelID];
    [NetWorkInterface sendDeviceCodeWithID:[self.ID intValue] deviceCode:deviceCode finished:^(BOOL success, NSData *response) {
         NSLog(@"绑定推送!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    }];
}
@end
