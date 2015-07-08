//
//  AppDelegate.m
//  GoodMore
//
//  Created by lihongliang on 15/5/27.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "AppDelegate.h"

#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import "MyWalletViewController.h"


@interface AppDelegate ()<CLLocationManagerDelegate>
{
    
    CLLocationManager *_locationManager;
    NSTimer *_timer;
}
@property(nonatomic,assign)CLLocationDegrees latitude;
@property(nonatomic,assign)CLLocationDegrees longitude;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    
    
//    RootViewController*rootViewController=[[RootViewController alloc]init];
//    self.window.rootViewController=rootViewController;
    
    //NSString *deviceString=[UIDevice currentDevice].model;
    //NSLog(@"设备型号--------%@",deviceString);
    
    //UIScreen *currentScreen = [UIScreen mainScreen];
    
    //NSLog(@"applicationFrame.size.height = %f",currentScreen.applicationFrame.size.height);
    //NSLog(@"applicationFrame.size.width = %f",currentScreen.applicationFrame.size.width);
    
    //[self checkAppVersion];
    
    _rootViewController=[[RootViewController alloc]init];
    self.window.rootViewController=_rootViewController;
    
    [self getUserLocation];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:15*60 target:self selector:@selector(getUserLocation) userInfo:nil repeats:YES];
    
    [self.window makeKeyAndVisible];
    
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

@end
